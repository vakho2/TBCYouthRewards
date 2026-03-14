//
//  TriviaQuestion.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation

struct TriviaQuestion: Codable {
    let id: Int
    let question: String
    let options: [String]
}
