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

                                Text("pts")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    )

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
                            }

                            ProgressView(
                                value: Double(gameProgressManager.currentLevelXP),
                                total: Double(gameProgressManager.nextLevelXP)
                            )
                            .tint(.blue)

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
                                        isBonus: dayNumber == 5
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        )
                        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
                }

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
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                    )

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

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Featured Rewards")
                            .font(.title3)
                            .fontWeight(.bold)

                        Spacer()

                        Button("Shop More") {
                            selectedTab = .rewards
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    }

                    HStack(spacing: 12) {
                        ForEach(viewModel.featuredRewards) { reward in
                            rewardCard(title: reward.title, subtitle: reward.subtitle, points: reward.points)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Activity")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(viewModel.recentActivities) { activity in
                        activityRow(title: activity.title, subtitle: activity.subtitle, value: activity.value)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .task {
            if gameProgressManager.userId == 0 && !gameProgressManager.isLoadingProfile {
                await gameProgressManager.loadProfile(username: "Sopo")
            }

            if gameProgressManager.tasks.isEmpty {
                await gameProgressManager.loadTasks()
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

    private func streakItem(title: String, icon: String, isActive: Bool = false, isBonus: Bool = false) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isBonus ? Color.clear : (isActive ? Color.blue : Color.gray.opacity(0.15)))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(isBonus ? Color.blue : Color.clear, style: StrokeStyle(lineWidth: 2, dash: [4]))
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
                        viewModel.addRecentActivity(
                            title: "Metro Tap",
                            value: "+\(response.pointsEarned) XP"
                        )
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
                        viewModel.addRecentActivity(
                            title: "Snack Spend Bonus",
                            value: "+\(response.pointsEarned) XP"
                        )
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
        .buttonStyle(.plain)
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

    private func rewardCard(title: String, subtitle: String, points: String) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .frame(height: 180)
            .overlay(
                VStack(alignment: .leading, spacing: 10) {
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.1))
                            .frame(height: 84)

                        Text(points)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .padding(8)
                    }

                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.bold)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)

                    Spacer()
                }
                .padding(10)
            )
            .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
    }

    private func activityRow(title: String, subtitle: String, value: String) -> some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(Color.white)
            .frame(height: 76)
            .overlay(
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.green.opacity(0.12))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "bolt.fill")
                                .foregroundColor(.green)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(.bold)

                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text(value)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 14)
            )
            .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
    }
}

struct ActionAlert: Identifiable {
    let id = UUID()
    let title: String
    let xp: Int
}
