//
//  RewardsViewModel.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation
import Combine

final class RewardsViewModel: ObservableObject {
    private let rewardService = RewardService()

    @Published var rewards: [Reward] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    @MainActor
    func loadRewards(userId: Int) async {
        guard userId != 0 else { return }

        isLoading = true
        errorMessage = nil

        do {
            rewards = try await rewardService.loadRewards(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    @MainActor
    func redeemReward(userId: Int, rewardId: Int, gameManager: GameProgressManager) async {
        guard userId != 0 else { return }

        errorMessage = nil
        successMessage = nil

        do {
            let response = try await rewardService.redeemReward(userId: userId, rewardId: rewardId)

            if response.success {
                gameManager.totalPoints = response.remainingPoints
                await gameManager.loadProfile(username: gameManager.username)
                await loadRewards(userId: userId)
                successMessage = "Reward redeemed successfully."
            } else {
                errorMessage = "Reward redeem failed."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    var featuredRewards: [Reward] {
        Array(rewards.prefix(3))
    }

    func canRedeem(_ reward: Reward, gameManager: GameProgressManager) -> Bool {
        gameManager.totalPoints >= reward.cost &&
        gameManager.currentLevel >= reward.levelRequired &&
        (!reward.isRedeemed || reward.isRepeatable)
    }

    func hasEnoughLevel(for reward: Reward, gameManager: GameProgressManager) -> Bool {
        gameManager.currentLevel >= reward.levelRequired
    }

    func hasEnoughPoints(for reward: Reward, gameManager: GameProgressManager) -> Bool {
        gameManager.totalPoints >= reward.cost
    }
}
