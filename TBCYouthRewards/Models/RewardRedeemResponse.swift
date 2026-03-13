//
//  RewardRedeemResponse.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import Foundation

struct RewardRedeemResponse: Codable {
    let success: Bool
    let remainingPoints: Int
    let isRedeemed: Bool
}
