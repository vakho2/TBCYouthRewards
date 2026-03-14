//
//  RewardItem.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation

struct Reward: Codable, Identifiable {
    let id: Int
    let title: String
    let cost: Int
    let levelRequired: Int
    let isRepeatable: Bool
    let isRedeemed: Bool
    let rewardType: String
}
