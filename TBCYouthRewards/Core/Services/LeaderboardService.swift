//
//  LeaderboardService.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import Foundation

final class LeaderboardService {
    func loadWeeklyLeaderboard() async throws -> [LeaderboardUser] {
        try await APIClient.shared.request("/Leaderboard/weekly")
    }
}
