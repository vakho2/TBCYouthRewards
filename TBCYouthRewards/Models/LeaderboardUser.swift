//
//  LeaderboardUser.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation

struct LeaderboardUser: Codable, Identifiable {
    let username: String
    let weeklyPoints: Int
    let level: Int
    let rank: Int

    var id: String { username }
}
