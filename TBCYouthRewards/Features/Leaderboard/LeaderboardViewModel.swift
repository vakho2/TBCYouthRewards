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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @MainActor
    func loadLeaderboard() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await leaderboardService.loadWeeklyLeaderboard()
            users = result
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
        Array(users.prefix(3))
    }

    func remainingToNextRank(username: String) -> Int {
        guard let currentUser = currentUser(username: username) else { return 0 }
        guard let aboveUser = users.first(where: { $0.rank == currentUser.rank - 1 }) else { return 0 }
        return max(aboveUser.weeklyPoints - currentUser.weeklyPoints + 1, 0)
    }
}
