//
//  TriviaAnswerResponse.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 14.03.26.
//

import Foundation

struct TriviaAnswerResponse: Codable {
    let isCorrect: Bool
    let pointsEarned: Int
    let totalPoints: Int
    let newLevel: Int
    let bonusAwarded: Bool
    let correctOptionIndex: Int
    let dailyTriviaAnswersCount: Int?
}
