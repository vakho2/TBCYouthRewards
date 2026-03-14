//
//  LeaderboardViewModel.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation
import Combine

final class LeaderboardViewModel: ObservableObject {
    private let leaderboardService = LeaderboardService()

    @Published var users: [LeaderboardUser] = []
    @Published var stats: LeaderboardStats?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @MainActor
    func loadLeaderboard() async {
        isLoading = true
        errorMessage = nil

        do {
            async let weekly = leaderboardService.loadWeeklyLeaderboard()
            async let statsResult = leaderboardService.loadLeaderboardStats()

            users = try await weekly
            stats = try await statsResult
        } catch {
            print("❌ Leaderboard error:", error)
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func currentUser(username: String) -> LeaderboardUser? {
        users.first { $0.username.lowercased() == username.lowercased() }
    }

    var topThree: [LeaderboardUser] {
        users.filter { $0.rank <= 3 }.sorted { $0.rank < $1.rank }
    }

    var remainingUsers: [LeaderboardUser] {
        users.filter { $0.rank > 3 }
    }

    func remainingToNextRank(username: String) -> Int {
        guard let currentUser = currentUser(username: username) else { return 0 }
        guard let aboveUser = users.first(where: { $0.rank == currentUser.rank - 1 }) else { return 0 }
        return max(aboveUser.weeklyPoints - currentUser.weeklyPoints + 1, 0)
    }

    var averageLevelText: String {
        guard let stats else { return "-" }
        return String(format: "%.1f", stats.averageLevel)
    }
}
