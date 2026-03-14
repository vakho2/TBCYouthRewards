//
//  GameProgressManager.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import Foundation
import Combine

final class GameProgressManager: ObservableObject {
    private let userService = UserService()
    private let checkinService = CheckinService()
    private let paymentService = PaymentService()
    private let taskService = TaskService()

    @Published var userId: Int = 0
    @Published var username: String = "Vakho"
    @Published var weeklyPoints: Int = 0
    @Published var hasCheckedInToday: Bool = false
    @Published var isLoadingProfile: Bool = false
    @Published var profileErrorMessage: String?
    @Published var tasks: [TaskModel] = []

    @Published var totalPoints: Int = 2450
    @Published var totalXP: Int = 1850
    @Published var currentLevel: Int = 4
    @Published var didLevelUp: Bool = false
    @Published var levelUpRewardText: String?

    @Published var currentStreak: Int = 3
    @Published var nextLevelXPValue: Int = 500

    func addXP(_ amount: Int) {
        let previousLevel = currentLevel

        totalXP += amount
        totalPoints += amount
        currentLevel = (totalXP / 500) + 1

        if currentLevel > previousLevel {
            didLevelUp = true
            applyMilestoneRewardIfNeeded(for: currentLevel)
        }
    }

    @MainActor
    func loadProfile(username: String) async {

        isLoadingProfile = true
        profileErrorMessage = nil

        do {
            let profile = try await userService.loadProfile(username: username)

            userId = profile.id
            self.username = profile.username
            totalPoints = profile.points
            totalXP = profile.xp
            currentLevel = profile.level
            currentStreak = profile.streak
            weeklyPoints = profile.weeklyPoints
            hasCheckedInToday = profile.hasCheckedInToday
            nextLevelXPValue = profile.nextLevelXP
        } catch {
            profileErrorMessage = error.localizedDescription
        }

        isLoadingProfile = false
    }

    @MainActor
    func claimDailyCheckInFromAPI() async -> CheckInResult? {
        guard userId != 0 else { return nil }

        do {
            let response = try await checkinService.checkin(userId: userId)

            totalPoints = response.totalPoints
            currentStreak = response.streakDay
            hasCheckedInToday = true

            await loadProfile(username: username)

            return CheckInResult(
                baseXP: response.pointsEarned,
                bonusXP: response.bonusAwarded ? 5 : 0,
                streak: response.streakDay
            )
        } catch {
            profileErrorMessage = error.localizedDescription
            return nil
        }
    }

    @MainActor
    func simulatePayment(taskId: Int) async -> PaymentSimulateResponse? {
        guard userId != 0 else { return nil }

        do {
            let response = try await paymentService.simulatePayment(userId: userId, taskId: taskId)
            totalPoints = response.totalPoints
            await loadProfile(username: username)
            return response
        } catch {
            profileErrorMessage = error.localizedDescription
            return nil
        }
    }

    @MainActor
    func loadTasks() async {
        do {
            let result = try await taskService.loadTasks()
            tasks = result
        } catch {
            profileErrorMessage = error.localizedDescription
        }
    }

    @MainActor
    func completeTask(taskId: Int) async -> TaskCompleteResponse? {
        guard userId != 0 else { return nil }

        do {
            let response = try await taskService.completeTask(taskId: taskId, userId: userId)
            totalPoints = response.totalPoints
            await loadProfile(username: username)
            return response
        } catch {
            profileErrorMessage = error.localizedDescription
            return nil
        }
    }

    func resetLevelUpState() {
        didLevelUp = false
        levelUpRewardText = nil
    }

    private func applyMilestoneRewardIfNeeded(for level: Int) {
        switch level {
        case 5:
            totalPoints += 500
            levelUpRewardText = "Level 5 reached! Bonus +500 pts"
        case 20:
            totalPoints += 2500
            levelUpRewardText = "Level 20 reached! Bonus +2500 pts"
        case 50:
            totalPoints += 10000
            levelUpRewardText = "Level 50 reached! Bonus +10000 pts"
        default:
            levelUpRewardText = "Level \(level) reached!"
        }
    }

    var currentLevelXP: Int {
        totalXP % 500
    }

    var nextLevelXP: Int {
        nextLevelXPValue
    }

    var levelTitle: String {
        switch currentLevel {
        case 1...4:
            return "Explorer"
        case 5...9:
            return "Achiever"
        case 10...19:
            return "Challenger"
        case 20...49:
            return "Champion"
        default:
            return "Legend"
        }
    }
}

struct CheckInResult {
    let baseXP: Int
    let bonusXP: Int
    let streak: Int

    var totalXP: Int {
        baseXP + bonusXP
    }
}
