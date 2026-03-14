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
            VStack(spacing: 14) {
                if !viewModel.hasStarted {
                    landingCard
                } else if viewModel.isSpinning {
                    spinningCard
                } else if viewModel.sessionCompleted {
                    resultSummaryCard
                } else {
                    if let question = viewModel.currentQuestion {
                        progressCard
                        questionCard(question)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 20)
        }
        .background(Color(.systemGroupedBackground))
        .alert(
            "Trivia Status",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var landingCard: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 3)
                    .frame(width: 70, height: 70)

                Circle()
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .frame(width: 46, height: 46)

                Image(systemName: "questionmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.blue)
            }

            VStack(spacing: 10) {
                Text("Daily Trivia Challenge")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)

                Text("Spin the wheel and answer 10 questions. Get them right and earn 50 XP each.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            subjectCloud(activeSubject: nil)

            Button {
                Task {
                    await viewModel.startTriviaSession(gameManager: gameProgressManager)
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.title3)
                    Text("Spin the Wheel")
                        .font(.system(size: 20, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(
                    LinearGradient(
                        colors: [Color.cyan, Color.blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .buttonStyle(.plain)
        }
        .padding(22)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }

    private var spinningCard: some View {
        VStack(spacing: 22) {
            Text("Picking your subject...")
                .font(.system(size: 22, weight: .bold))

            subjectCloud(activeSubject: viewModel.highlightedSubject)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }

    private var progressCard: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("IN PROGRESS")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)

                    Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.totalQuestions)")
                        .font(.system(size: 20, weight: .bold))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    Text("Potential Rewards")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack(spacing: 6) {
                        rewardPill(text: "+50 XP", foreground: .blue, background: Color.blue.opacity(0.10))
                        rewardPill(text: "+50 Points", foreground: .green, background: Color.green.opacity(0.10))
                    }
                }
            }

            ProgressView(value: viewModel.progressValue)
                .tint(.cyan)
                .scaleEffect(y: 1.2)

            HStack {
                HStack(spacing: 4) {
                    Text("Session XP:")
                        .font(.body)
                        .foregroundColor(.secondary)

                    Text("\(viewModel.sessionXP)")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }

                Spacer()

                Text("\(viewModel.correctAnswersCount)/\(viewModel.currentQuestionIndex + (viewModel.answerResult == nil ? 0 : 1)) Correct")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }

    private func questionCard(_ question: TriviaQuestion) -> some View {
        VStack(spacing: 18) {
            HStack {
                Spacer()
                subjectBadge(title: viewModel.selectedSubject ?? "")
                Spacer()
            }

            Text(question.question)
                .font(.system(size: 18, weight: .bold))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 4)

            VStack(spacing: 12) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    answerRow(
                        letter: optionLetter(for: index),
                        title: option,
                        index: index
                    )
                }
            }

            Button {
                Task {
                    await viewModel.submitOrContinue(gameManager: gameProgressManager)
                }
            } label: {
                HStack(spacing: 8) {
                    Spacer()
                    Text(viewModel.submitButtonTitle)
                        .font(.system(size: 18, weight: .bold))
                    Image(systemName: viewModel.answerResult == nil ? "arrow.right" : "arrow.right.circle.fill")
                        .font(.body)
                    Spacer()
                }
                .foregroundColor(buttonForegroundColor)
                .frame(height: 56)
                .background(buttonBackgroundColor)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled((viewModel.answerResult == nil && !viewModel.canSubmit) || viewModel.isLoading)

            if let result = viewModel.answerResult {
                Text(result.isCorrect ? "Correct answer" : "Wrong answer")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(result.isCorrect ? .green : .red)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }

    private var resultSummaryCard: some View {
        VStack(spacing: 18) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 56))
                .foregroundColor(.blue)

            Text("Session Completed")
                .font(.system(size: 26, weight: .bold))

            VStack(spacing: 8) {
                summaryRow(title: "Subject", value: viewModel.selectedSubject ?? "-")
                summaryRow(title: "Correct Answers", value: "\(viewModel.correctAnswersCount)/\(viewModel.totalQuestions)")
                summaryRow(title: "Session XP", value: "\(viewModel.sessionXP)")
                summaryRow(title: "Total Points", value: "\(gameProgressManager.totalPoints)")
            }

            Button {
                viewModel.resetSession()
            } label: {
                Text("Play Again")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
        }
        .padding(22)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }

    private func subjectCloud(activeSubject: String?) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                subjectChip("Geography", active: activeSubject == "Geography")
                subjectChip("Physics", active: activeSubject == "Physics")
                subjectChip("Math", active: activeSubject == "Math")
            }

            HStack(spacing: 8) {
                subjectChip("History", active: activeSubject == "History")
                subjectChip("Biology", active: activeSubject == "Biology")
            }

            HStack(spacing: 8) {
                subjectChip("Chemistry", active: activeSubject == "Chemistry")
                subjectChip("Literature", active: activeSubject == "Literature")
            }
        }
    }

    private func subjectChip(_ title: String, active: Bool) -> some View {
        Text(title.uppercased())
            .font(.system(size: 13, weight: .bold))
            .foregroundColor(active ? .white : Color.gray.opacity(0.8))
            .padding(.horizontal, 14)
            .frame(height: 40)
            .background(
                active
                ? LinearGradient(colors: [Color.cyan, Color.blue], startPoint: .leading, endPoint: .trailing)
                : LinearGradient(colors: [Color.gray.opacity(0.08), Color.gray.opacity(0.08)], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .animation(.easeInOut(duration: 0.2), value: active)
    }

    private func subjectBadge(title: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "cross.case")
                .font(.subheadline)
            Text(title)
                .font(.system(size: 16, weight: .bold))
        }
        .foregroundColor(.blue)
        .padding(.horizontal, 14)
        .frame(height: 38)
        .background(Color.blue.opacity(0.10))
        .clipShape(Capsule())
    }

    private func answerRow(letter: String, title: String, index: Int) -> some View {
        let isSelected = viewModel.selectedAnswerIndex == index
        let isCorrect = viewModel.answerResult?.correctOptionIndex == index
        let isWrongSelected = viewModel.answerResult != nil && isSelected && !isCorrect

        return Button {
            viewModel.selectAnswer(index)
        } label: {
            HStack(spacing: 14) {
                Circle()
                    .fill(circleBackground(isSelected: isSelected, isCorrect: isCorrect, isWrongSelected: isWrongSelected))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(letter)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(circleForeground(isCorrect: isCorrect, isWrongSelected: isWrongSelected))
                    )

                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, 14)
            .frame(minHeight: 84)
            .background(answerBackground(isSelected: isSelected, isCorrect: isCorrect, isWrongSelected: isWrongSelected))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(answerBorder(isSelected: isSelected, isCorrect: isCorrect, isWrongSelected: isWrongSelected), lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
        .disabled(viewModel.answerResult != nil)
    }

    private func rewardPill(text: String, foreground: Color, background: Color) -> some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(foreground)
            .padding(.horizontal, 12)
            .frame(height: 34)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .padding(.vertical, 2)
    }

    private func optionLetter(for index: Int) -> String {
        ["A", "B", "C", "D"][safe: index] ?? "A"
    }

    private func answerBackground(isSelected: Bool, isCorrect: Bool, isWrongSelected: Bool) -> Color {
        if isCorrect {
            return Color.green.opacity(0.10)
        }
        if isWrongSelected {
            return Color.red.opacity(0.10)
        }
        if isSelected {
            return Color.blue.opacity(0.08)
        }
        return Color.white
    }

    private func answerBorder(isSelected: Bool, isCorrect: Bool, isWrongSelected: Bool) -> Color {
        if isCorrect {
            return Color.green.opacity(0.55)
        }
        if isWrongSelected {
            return Color.red.opacity(0.45)
        }
        if isSelected {
            return Color.blue.opacity(0.45)
        }
        return Color.gray.opacity(0.15)
    }

    private func circleBackground(isSelected: Bool, isCorrect: Bool, isWrongSelected: Bool) -> Color {
        if isCorrect {
            return Color.green.opacity(0.18)
        }
        if isWrongSelected {
            return Color.red.opacity(0.18)
        }
        if isSelected {
            return Color.blue.opacity(0.14)
        }
        return Color.gray.opacity(0.08)
    }

    private func circleForeground(isCorrect: Bool, isWrongSelected: Bool) -> Color {
        if isCorrect {
            return .green
        }
        if isWrongSelected {
            return .red
        }
        return Color.gray.opacity(0.75)
    }

    private var buttonBackgroundColor: Color {
        if viewModel.answerResult != nil {
            return Color.blue
        }
        return viewModel.canSubmit ? Color.blue.opacity(0.22) : Color.blue.opacity(0.12)
    }

    private var buttonForegroundColor: Color {
        if viewModel.answerResult != nil {
            return .white
        }
        return viewModel.canSubmit ? .blue : .white
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
