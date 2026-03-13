//
//  TriviaViewModel.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation
import Combine

final class TriviaViewModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = [
        TriviaQuestion(
            question: "What is the capital of France?",
            answers: ["Paris", "Berlin", "Madrid", "Rome"],
            correctAnswer: "Paris"
        ),
        TriviaQuestion(
            question: "Which planet is known as the Red Planet?",
            answers: ["Mars", "Venus", "Jupiter", "Saturn"],
            correctAnswer: "Mars"
        ),
        TriviaQuestion(
            question: "What is 12 × 4?",
            answers: ["36", "48", "52", "44"],
            correctAnswer: "48"
        )
    ]

    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswer: String? = nil
    @Published var isCorrect: Bool? = nil
    @Published var didAwardXP: Bool = false

    var currentQuestion: TriviaQuestion {
        questions[currentQuestionIndex]
    }

    func selectAnswer(_ answer: String, gameManager: GameProgressManager) {
        guard selectedAnswer == nil else { return }

        selectedAnswer = answer
        let correct = answer == currentQuestion.correctAnswer
        isCorrect = correct

        if correct && !didAwardXP {
            gameManager.addXP(20)
            didAwardXP = true
        }
    }

    func nextQuestion() {
        guard currentQuestionIndex + 1 < questions.count else { return }
        currentQuestionIndex += 1
        selectedAnswer = nil
        isCorrect = nil
        didAwardXP = false
    }

    var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }

    func resetQuiz() {
        currentQuestionIndex = 0
        selectedAnswer = nil
        isCorrect = nil
        didAwardXP = false
    }
}
