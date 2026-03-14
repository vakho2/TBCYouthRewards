//
//  TriviaService.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 14.03.26.
//

import Foundation

final class TriviaService {
    func spin() async throws -> TriviaSpinResponse {
        try await APIClient.shared.request("/Trivia/spin")
    }

    func loadQuestions(subject: String, userId: Int) async throws -> [TriviaQuestion] {
        try await APIClient.shared.request(
            "/Trivia/questions",
            queryItems: [
                URLQueryItem(name: "subject", value: subject),
                URLQueryItem(name: "userId", value: "\(userId)")
            ]
        )
    }

    func submitAnswer(userId: Int, questionId: Int, selectedOptionIndex: Int) async throws -> TriviaAnswerResponse {
        let body = try JSONEncoder().encode(
            TriviaAnswerRequest(
                questionId: questionId,
                selectedOptionIndex: selectedOptionIndex
            )
        )

        return try await APIClient.shared.request(
            "/Trivia/answer",
            method: "POST",
            queryItems: [
                URLQueryItem(name: "userId", value: "\(userId)")
            ],
            body: body
        )
    }
}
