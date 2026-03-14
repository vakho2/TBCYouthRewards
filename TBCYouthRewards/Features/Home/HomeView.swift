//
//  HomeView.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Binding var selectedTab: AppTab
    @State private var isCheckInPresented = false
    @State private var activeActionTitle: String?
    @State private var activeActionXP: Int = 0
    @State private var checkInRewardText: String?
    @EnvironmentObject var gameProgressManager: GameProgressManager

    @State private var showBalanceCard = false
    @State private var showLevelCard = false
    @State private var showStreakSection = false
    @State private var showActionsSection = false
    @State private var showCardBanner = false
    @State private var showLeaderboardSection = false
    @State private var showRewardsSection = false
    @State private var animatedProgress: Double = 0

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.blue.opacity(0.12))
                    .frame(height: 110)
                    .overlay(
                        VStack(alignment: .leading, spacing: 8) {
                            Text("TOTAL BALANCE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)

                            HStack(alignment: .firstTextBaseline, spacing: 6) {
                                Image(systemName: "star.circle.fill")
                                    .foregroundColor(.blue)

                                Text("\(gameProgressManager.totalPoints)")
                                    .font(.system(size: 34, weight: .bold))
                                    .contentTransition(.numericText())

                                Text("pts")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    )
                    .opacity(showBalanceCard ? 1 : 0)
                    .offset(y: showBalanceCard ? 0 : 18)

                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .frame(height: 140)
                    .overlay(
                        VStack(alignment: .leading, spacing: 12) {
                            Text("CURRENT LEVEL")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)

                            HStack {
                                HStack(alignment: .firstTextBaseline, spacing: 6) {
                                    Text("Level \(gameProgressManager.currentLevel)")
                                        .font(.title2)
                                        .fontWeight(.bold)

                                    Text(gameProgressManager.levelTitle)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Text("\(gameProgressManager.currentLevelXP) / \(gameProgressManager.nextLevelXP) XP")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .contentTransition(.numericText())
                            }

                            ProgressView(
                                value: animatedProgress,
                                total: Double(max(gameProgressManager.nextLevelXP, 1))
                            )
                            .tint(.blue)
                            .animation(.easeInOut(duration: 0.7), value: animatedProgress)

                            HStack(spacing: 6) {
                                Image(systemName: "info.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Text("Earn \(gameProgressManager.nextLevelXP - gameProgressManager.currentLevelXP) more XP to unlock Level \(gameProgressManager.currentLevel + 1) perks")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(20)
                    )
                    .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
                    .opacity(showLevelCard ? 1 : 0)
                    .offset(y: showLevelCard ? 0 : 18)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Daily Streak • \(gameProgressManager.currentStreak) days")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .frame(height: 120)
                        .overlay(
                            HStack(spacing: 18) {
                                ForEach(0..<5, id: \.self) { index in
                                    let dayNumber = index + 1
                                    streakItem(
                                        title: "DAY \(dayNumber)",
                                        icon: iconForStreakDay(dayNumber),
                                        isActive: gameProgressManager.currentStreak >= dayNumber,
                                        isBonus: dayNumber == 5,
                                        isCurrent: dayNumber == gameProgressManager.currentStreak
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        )
                        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
                }
                .opacity(showStreakSection ? 1 : 0)
                .offset(y: showStreakSection ? 0 : 18)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Quests & Actions")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 12) {
                        ForEach(viewModel.quickActions) { action in
                            actionItem(title: action.title, icon: action.icon)
                        }
                    }
                }
                .opacity(showActionsSection ? 1 : 0)
                .offset(y: showActionsSection ? 0 : 18)

                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [Color.cyan, Color.blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 140)
                    .overlay(
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Custom Card Designer")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Personalize your physical card with unique AI-generated skins.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))

                            Button {
                                selectedTab = .cards
                            } label: {
                                Text("Design Now")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PressableScaleStyle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                    )
                    .opacity(showCardBanner ? 1 : 0)
                    .offset(y: showCardBanner ? 0 : 18)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Leaderboard")
                            .font(.title3)
                            .fontWeight(.bold)

                        Spacer()

                        Button("View All") {
                            selectedTab = .leaderboard
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    }

                    HStack(spacing: 12) {
                        ForEach(viewModel.leaderboardUsers) { user in
                            previewCard(name: user.name, value: user.xp)
                        }
                    }
                }
                .opacity(showLeaderboardSection ? 1 : 0)
                .offset(y: showLeaderboardSection ? 0 : 18)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Top Rewards")
                            .font(.title3)
                            .fontWeight(.bold)

                        Spacer()

                        Button("Explore") {
                            selectedTab = .rewards
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    }

                    VStack(spacing: 12) {
                        ForEach(viewModel.topRewards) { reward in
                            topRewardRow(title: reward.title, points: reward.points)
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
                .padding(.top, 4)
                .opacity(showRewardsSection ? 1 : 0)
                .offset(y: showRewardsSection ? 0 : 18)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
            .animation(.spring(response: 0.46, dampingFraction: 0.88), value: showBalanceCard)
            .animation(.spring(response: 0.46, dampingFraction: 0.88), value: showLevelCard)
            .animation(.spring(response: 0.46, dampingFraction: 0.88), value: showStreakSection)
            .animation(.spring(response: 0.46, dampingFraction: 0.88), value: showActionsSection)
            .animation(.spring(response: 0.46, dampingFraction: 0.88), value: showCardBanner)
            .animation(.spring(response: 0.46, dampingFraction: 0.88), value: showLeaderboardSection)
            .animation(.spring(response: 0.46, dampingFraction: 0.88), value: showRewardsSection)
        }
        .background(Color(.systemGroupedBackground))
        .task {
            if gameProgressManager.userId == 0 && !gameProgressManager.isLoadingProfile {
                await gameProgressManager.loadProfile(username: "Sopo")
            }

            if gameProgressManager.tasks.isEmpty {
                await gameProgressManager.loadTasks()
            }

            runEntranceAnimations()
        }
        .onChange(of: gameProgressManager.currentLevelXP) { _, newValue in
            withAnimation(.easeInOut(duration: 0.7)) {
                animatedProgress = Double(newValue)
            }
        }
        .onChange(of: gameProgressManager.nextLevelXP) { _, _ in
            withAnimation(.easeInOut(duration: 0.7)) {
                animatedProgress = Double(gameProgressManager.currentLevelXP)
            }
        }
        .sheet(isPresented: $isCheckInPresented) {
            VStack(spacing: 20) {
                Text("Daily Check-in")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Claim your daily reward and keep your streak alive.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                Text("+10 XP")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.blue)

                Button {
                    Task {
                        if let result = await gameProgressManager.claimDailyCheckInFromAPI() {
                            checkInRewardText = result.bonusXP > 0
                                ? "Daily Check-in complete! +\(result.baseXP) XP and +\(result.bonusXP) bonus XP for a \(result.streak)-day streak."
                                : "Daily Check-in complete! +\(result.baseXP) XP."
                            isCheckInPresented = false
                        } else {
                            checkInRewardText = gameProgressManager.profileErrorMessage ?? "Check-in failed."
                            isCheckInPresented = false
                        }
                    }
                } label: {
                    Text("Claim Reward")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(PressableScaleStyle())
                .padding(.top, 8)
            }
            .padding(24)
            .presentationDetents([.medium])
        }
        .alert("Level Up!", isPresented: $gameProgressManager.didLevelUp) {
            Button("OK") {
                gameProgressManager.resetLevelUpState()
            }
        } message: {
            Text(gameProgressManager.levelUpRewardText ?? "")
        }
        .alert(item: Binding(
            get: {
                activeActionTitle.map { ActionAlert(title: $0, xp: activeActionXP) }
            },
            set: { _ in
                activeActionTitle = nil
                activeActionXP = 0
            }
        )) { item in
            Alert(
                title: Text(item.title),
                message: Text("+\(item.xp) XP added"),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(
            "Check-in Status",
            isPresented: Binding(
                get: { checkInRewardText != nil },
                set: { if !$0 { checkInRewardText = nil } }
            )
        ) {
            Button("OK") {
                checkInRewardText = nil
            }
        } message: {
            Text(checkInRewardText ?? "")
        }
    }

    private func runEntranceAnimations() {
        showBalanceCard = false
        showLevelCard = false
        showStreakSection = false
        showActionsSection = false
        showCardBanner = false
        showLeaderboardSection = false
        showRewardsSection = false

        animatedProgress = 0

        withAnimation(.spring(response: 0.42, dampingFraction: 0.9)) {
            showBalanceCard = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.spring(response: 0.46, dampingFraction: 0.88)) {
                showLevelCard = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            withAnimation(.spring(response: 0.46, dampingFraction: 0.88)) {
                showStreakSection = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
            withAnimation(.spring(response: 0.46, dampingFraction: 0.88)) {
                showActionsSection = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
            withAnimation(.spring(response: 0.46, dampingFraction: 0.88)) {
                showCardBanner = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
            withAnimation(.spring(response: 0.46, dampingFraction: 0.88)) {
                showLeaderboardSection = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.48) {
            withAnimation(.spring(response: 0.46, dampingFraction: 0.88)) {
                showRewardsSection = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            withAnimation(.easeInOut(duration: 0.8)) {
                animatedProgress = Double(gameProgressManager.currentLevelXP)
            }
        }
    }

    private func streakItem(title: String, icon: String, isActive: Bool = false, isBonus: Bool = false, isCurrent: Bool = false) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isBonus ? Color.clear : (isActive ? Color.blue : Color.gray.opacity(0.15)))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(isBonus ? Color.blue : Color.clear, style: StrokeStyle(lineWidth: 2, dash: [4]))
                    )
                    .scaleEffect(isCurrent ? 1.06 : 1)
                    .animation(
                        isCurrent
                        ? .easeInOut(duration: 1.1).repeatForever(autoreverses: true)
                        : .default,
                        value: isCurrent
                    )

                if let number = Int(icon) {
                    Text("\(number)")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: icon)
                        .foregroundColor(isBonus ? .blue : .white)
                }
            }

            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        }
    }

    private func iconForStreakDay(_ day: Int) -> String {
        if day == 5 {
            return "gift"
        }

        if gameProgressManager.currentStreak >= day {
            if day == gameProgressManager.currentStreak {
                return "flame.fill"
            } else {
                return "checkmark"
            }
        }

        return "\(day)"
    }

    private func actionItem(title: String, icon: String) -> some View {
        Button {
            if title == "Check-in" {
                isCheckInPresented = true
            } else if title == "Trivia" {
                selectedTab = .trivia
            } else if title == "Metro Tap" {
                Task {
                    if let response = await gameProgressManager.completeTask(taskId: 1) {
                        activeActionTitle = "Metro Tap"
                        activeActionXP = response.pointsEarned
                    } else {
                        activeActionTitle = "Metro Tap Failed"
                        activeActionXP = 0
                    }
                }
            } else if title == "Snack" {
                Task {
                    if let response = await gameProgressManager.completeTask(taskId: 2) {
                        activeActionTitle = "Snack Spend Bonus"
                        activeActionXP = response.pointsEarned
                    } else {
                        activeActionTitle = "Snack Failed"
                        activeActionXP = 0
                    }
                }
            }
        } label: {
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(height: 72)
                    .overlay(
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundColor(.blue)
                    )

                Text(title)
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PressableScaleStyle())
    }

    private func previewCard(name: String, value: String) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .frame(height: 130)
            .overlay(
                VStack(spacing: 10) {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 52, height: 52)

                    Text(name)
                        .font(.subheadline)
                        .fontWeight(.bold)

                    Text(value)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 12)
            )
            .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
    }

    private func topRewardRow(title: String, points: String) -> some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(Color(.systemGray6))
            .frame(height: 88)
            .overlay(
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.10))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "star")
                                .font(.title3)
                                .foregroundColor(.blue)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(1)

                        Text(points.uppercased())
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding(.horizontal, 14)
            )
    }
}

struct ActionAlert: Identifiable {
    let id = UUID()
    let title: String
    let xp: Int
}

struct PressableScaleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}
