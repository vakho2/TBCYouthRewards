//
//  TriviaViewModel.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation
import Combine

final class TriviaViewModel: ObservableObject {
    private let triviaService = TriviaService()

    let allSubjects = [
        "Geography",
        "Physics",
        "Math",
        "History",
        "Chemistry",
        "Biology",
        "Literature"
    ]

    @Published var selectedSubject: String?
    @Published var highlightedSubject: String?
    @Published var questions: [TriviaQuestion] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswerIndex: Int?
    @Published var answerResult: TriviaAnswerResponse?
    @Published var isLoading: Bool = false
    @Published var isSpinning: Bool = false
    @Published var errorMessage: String?
    @Published var sessionXP: Int = 0
    @Published var correctAnswersCount: Int = 0
    @Published var sessionCompleted: Bool = false

    var hasStarted: Bool {
        !questions.isEmpty || isSpinning
    }

    var currentQuestion: TriviaQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var totalQuestions: Int {
        questions.count
    }

    var progressValue: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(currentQuestionIndex + 1) / Double(totalQuestions)
    }

    var submitButtonTitle: String {
        if answerResult != nil {
            return currentQuestionIndex == totalQuestions - 1 ? "Finish Session" : "Next Question"
        }
        return "Submit Answer"
    }

    var canSubmit: Bool {
        selectedAnswerIndex != nil && answerResult == nil && !isLoading
    }

    @MainActor
    func startTriviaSession(gameManager: GameProgressManager) async {
        guard gameManager.userId != 0 else { return }

        isLoading = true
        isSpinning = true
        errorMessage = nil
        selectedSubject = nil
        highlightedSubject = nil
        questions = []
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        answerResult = nil
        sessionXP = 0
        correctAnswersCount = 0
        sessionCompleted = false

        do {
            let spinResult = try await triviaService.spin()
            let finalSubject = spinResult.subject
            await animateSubjectSelection(finalSubject: finalSubject)

            let loadedQuestions = try await triviaService.loadQuestions(
                subject: finalSubject,
                userId: gameManager.userId
            )

            let sessionQuestions = Array(loadedQuestions.prefix(10))

            if sessionQuestions.isEmpty {
                errorMessage = "No trivia questions available."
                isLoading = false
                isSpinning = false
                return
            }

            selectedSubject = finalSubject
            questions = sessionQuestions
        } catch {
            errorMessage = error.localizedDescription
        }

        isSpinning = false
        isLoading = false
    }

    @MainActor
    private func animateSubjectSelection(finalSubject: String) async {
        let cycles = 12

        for _ in 0..<cycles {
            highlightedSubject = allSubjects.randomElement()
            try? await Task.sleep(nanoseconds: 120_000_000)
        }

        highlightedSubject = finalSubject
        try? await Task.sleep(nanoseconds: 350_000_000)
    }

    @MainActor
    func selectAnswer(_ index: Int) {
        guard answerResult == nil else { return }
        selectedAnswerIndex = index
    }

    @MainActor
    func submitOrContinue(gameManager: GameProgressManager) async {
        if answerResult != nil {
            goToNextQuestion()
            return
        }

        guard let question = currentQuestion else { return }
        guard let selectedAnswerIndex else { return }
        guard gameManager.userId != 0 else { return }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await triviaService.submitAnswer(
                userId: gameManager.userId,
                questionId: question.id,
                selectedOptionIndex: selectedAnswerIndex
            )

            answerResult = result
            sessionXP += result.pointsEarned

            if result.isCorrect {
                correctAnswersCount += 1
            }

            gameManager.totalPoints = result.totalPoints
            await gameManager.loadProfile(username: gameManager.username)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    @MainActor
    private func goToNextQuestion() {
        if currentQuestionIndex + 1 < totalQuestions {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            answerResult = nil
        } else {
            sessionCompleted = true
        }
    }

    @MainActor
    func resetSession() {
        selectedSubject = nil
        highlightedSubject = nil
        questions = []
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        answerResult = nil
        isLoading = false
        isSpinning = false
        errorMessage = nil
        sessionXP = 0
        correctAnswersCount = 0
        sessionCompleted = false
    }
}
