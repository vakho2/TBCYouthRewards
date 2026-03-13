//
//  CheckinService.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import Foundation

struct CheckinResponse: Codable {
    let pointsEarned: Int
    let streakDay: Int
    let bonusAwarded: Bool
    let totalPoints: Int
}

final class CheckinService {
    func checkin(userId: Int) async throws -> CheckinResponse {
        try await APIClient.shared.request(
            "/Checkin",
            method: "POST",
            queryItems: [
                URLQueryItem(name: "userId", value: "\(userId)")
            ]
        )
    }
}
