//
//  RewardService.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import Foundation

final class RewardService {
    func loadRewards(userId: Int) async throws -> [Reward] {
        try await APIClient.shared.request(
            "/Reward",
            queryItems: [
                URLQueryItem(name: "userId", value: "\(userId)")
            ]
        )
    }

    func redeemReward(userId: Int, rewardId: Int) async throws -> RewardRedeemResponse {
        let body = try JSONEncoder().encode(RewardRedeemRequest(rewardId: rewardId))

        return try await APIClient.shared.request(
            "/Reward/redeem",
            method: "POST",
            queryItems: [
                URLQueryItem(name: "userId", value: "\(userId)")
            ],
            body: body
        )
    }
}
