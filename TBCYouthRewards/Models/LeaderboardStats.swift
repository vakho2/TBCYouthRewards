//
//  LeaderboardStats.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 14.03.26.
//

import Foundation

struct LeaderboardStats: Codable {
    let totalUsers: Int
    let totalPointsDistributed: Int
    let averageLevel: Double
    let topPlayer: String
    let lastUpdate: String
}
