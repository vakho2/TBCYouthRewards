//
//  HomeModels.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation

struct HomeLeaderboardUser: Identifiable {
    let id = UUID()
    let name: String
    let xp: String
}

struct HomeRewardItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let points: String
}

struct HomeStreakDay: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let isActive: Bool
    let isBonus: Bool
}

struct HomeQuickAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}
