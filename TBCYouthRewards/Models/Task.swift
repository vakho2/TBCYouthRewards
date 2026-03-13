//
//  Task.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import Foundation

struct TaskModel: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let taskType: String
    let pointsReward: Int
}
