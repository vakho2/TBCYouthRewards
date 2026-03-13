//
//  UserProfile.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation

struct UserProfile: Codable {
    let id: Int
    let username: String
    let points: Int
    let xp: Int
    let level: Int
    let streak: Int
    let weeklyPoints: Int
    let nextLevelXP: Int
    let hasCheckedInToday: Bool
}
