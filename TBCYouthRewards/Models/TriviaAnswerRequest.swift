//
//  TriviaAnswerRequest.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 14.03.26.
//

import Foundation

struct TriviaAnswerRequest: Codable {
    let questionId: Int
    let selectedOptionIndex: Int
}
