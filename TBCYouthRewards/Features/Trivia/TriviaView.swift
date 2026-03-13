//
//  TriviaView.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import SwiftUI

struct TriviaView: View {
    @StateObject private var viewModel = TriviaViewModel()
    @EnvironmentObject var gameProgressManager: GameProgressManager

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(spacing: 6) {
                    Text("Trivia Challenge")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.questions.count)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 8)

                VStack(alignment: .leading, spacing: 20) {
                    Text(viewModel.currentQuestion.question)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(spacing: 12) {
                        ForEach(viewModel.currentQuestion.answers, id: \.self) { answer in
                            Button {
                                viewModel.selectAnswer(answer, gameManager: gameProgressManager)
                            } label: {
                                HStack {
                                    Text(answer)
                                        .foregroundColor(.primary)
                                        .font(.body)
                                        .fontWeight(.medium)

                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 64)
                                .frame(maxWidth: .infinity)
                                .background(answerBackground(for: answer))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(answerBorderColor(for: answer), lineWidth: 1.5)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.selectedAnswer != nil)
                        }
                    }

                    if let isCorrect = viewModel.isCorrect {
                        VStack(spacing: 12) {
                            if isCorrect {
                                Text("Correct! +20 XP")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            } else {
                                Text("Wrong Answer")
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }

                            Button {
                                if viewModel.isLastQuestion {
                                    viewModel.resetQuiz()
                                } else {
                                    viewModel.nextQuestion()
                                }
                            } label: {
                                Text(viewModel.isLastQuestion ? "Restart Quiz" : "Next Question")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text("YOUR PROGRESS")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)

                    Text("Level \(gameProgressManager.currentLevel) • \(gameProgressManager.currentLevelXP) / \(gameProgressManager.nextLevelXP) XP")
                        .font(.subheadline)
                        .foregroundColor(.primary)

                    ProgressView(
                        value: Double(gameProgressManager.currentLevelXP),
                        total: Double(gameProgressManager.nextLevelXP)
                    )
                    .tint(.blue)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .alert("Level Up!", isPresented: $gameProgressManager.didLevelUp) {
            Button("OK") {
                gameProgressManager.resetLevelUpState()
            }
        } message: {
            Text(gameProgressManager.levelUpRewardText ?? "")
        }
    }

    private func answerBackground(for answer: String) -> Color {
        guard let selectedAnswer = viewModel.selectedAnswer else {
            return .white
        }

        if answer == viewModel.currentQuestion.correctAnswer {
            return Color.green.opacity(0.12)
        }

        if answer == selectedAnswer && selectedAnswer != viewModel.currentQuestion.correctAnswer {
            return Color.red.opacity(0.12)
        }

        return .white
    }

    private func answerBorderColor(for answer: String) -> Color {
        guard let selectedAnswer = viewModel.selectedAnswer else {
            return Color.gray.opacity(0.15)
        }

        if answer == viewModel.currentQuestion.correctAnswer {
            return .green
        }

        if answer == selectedAnswer && selectedAnswer != viewModel.currentQuestion.correctAnswer {
            return .red
        }

        return Color.gray.opacity(0.15)
    }
}
