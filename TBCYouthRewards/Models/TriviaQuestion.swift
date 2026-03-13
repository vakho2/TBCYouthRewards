//
//  TriviaQuestion.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation

struct TriviaQuestion: Identifiable {
    let id = UUID()
    let question: String
    let answers: [String]
    let correctAnswer: String
}

struct TriviaResult: Codable {
    let isCorrect: Bool
    let pointsEarned: Int
    let totalPoints: Int
    let newLevel: Int
    let bonusAwarded: Bool
    let correctOptionIndex: Int
}
