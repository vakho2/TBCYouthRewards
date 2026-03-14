//
//  RewardsView.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import SwiftUI

struct RewardsView: View {
    @StateObject private var viewModel = RewardsViewModel()
    @EnvironmentObject var gameProgressManager: GameProgressManager
    @State private var selectedCategory: RewardCategory = .all

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                topSummarySection
                infoBanner
                filterChips
                rewardsGrid
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .task {
            await viewModel.loadRewards(userId: gameProgressManager.userId)
        }
        .alert(
            "Reward Status",
            isPresented: Binding(
                get: { viewModel.successMessage != nil || viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.successMessage = nil; viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK") {
                viewModel.successMessage = nil
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.successMessage ?? viewModel.errorMessage ?? "")
        }
    }

    private var topSummarySection: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color.cyan, Color.blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 132)
                .overlay(
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Available Balance")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.92))

                        Text("\(gameProgressManager.totalPoints)")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)

                        Text("PTS")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(18)
                )

            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .frame(height: 132)
                .overlay(
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Level \(gameProgressManager.currentLevel)")
                            .font(.title3)
                            .foregroundColor(.secondary)

                        ProgressView(
                            value: Double(gameProgressManager.currentLevelXP),
                            total: Double(max(gameProgressManager.nextLevelXP, 1))
                        )
                        .tint(.cyan)
                        .scaleEffect(y: 1.2)

                        Text("Progress to Level \(gameProgressManager.currentLevel + 1)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(18)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        }
    }

    private var infoBanner: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle")
                .font(.title3)
                .foregroundColor(.blue)

            Text("Keep playing, checking in, and earning XP to level up and unlock even cooler rewards.")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color.blue.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(RewardCategory.allCases, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Text(category.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedCategory == category ? .white : .secondary)
                            .padding(.horizontal, 18)
                            .frame(height: 40)
                            .background(selectedCategory == category ? Color.blue : Color.white)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.black.opacity(selectedCategory == category ? 0 : 0.06), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var rewardsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            ForEach(filteredRewards) { reward in
                rewardCard(reward)
            }
        }
    }

    private var filteredRewards: [Reward] {
        let rewards = viewModel.rewards.filter {
            let title = $0.title.lowercased()
            return !title.contains("custom card") &&
                   !title.contains("card designer") &&
                   !title.contains("your own card")
        }

        switch selectedCategory {
        case .all:
            return rewards
        case .premium:
            return rewards.filter { $0.rewardType.lowercased().contains("premium") || $0.levelRequired >= 10 }
        case .basic:
            return rewards.filter { $0.levelRequired <= 5 && !$0.rewardType.lowercased().contains("limited") }
        case .limited:
            return rewards.filter { $0.rewardType.lowercased().contains("limited") }
        }
    }

    private func rewardCard(_ reward: Reward) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.white)

                Image(rewardImageName(for: reward))
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                    .padding(.horizontal, 12)
                    .padding(.top, 22)

                smallBadge(
                    reward.rewardType.capitalized,
                    bg: rewardBadgeColor(for: reward),
                    fg: .white
                )
                .padding(12)
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            )

            VStack(alignment: .leading, spacing: 8) {
                Text(reward.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                HStack(spacing: 6) {
                    Text("\(formattedPoints(reward.cost)) PTS")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    smallBadge("Lvl \(reward.levelRequired)+", bg: Color.gray.opacity(0.10), fg: .secondary)
                }

                redeemButton(for: reward)
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }

    private func redeemButton(for reward: Reward) -> some View {
        Group {
            if reward.isRedeemed && !reward.isRepeatable {
                actionButton(title: "Redeemed", enabled: false)
            } else if viewModel.canRedeem(reward, gameManager: gameProgressManager) {
                actionButton(title: "Redeem", enabled: true) {
                    Task {
                        await viewModel.redeemReward(
                            userId: gameProgressManager.userId,
                            rewardId: reward.id,
                            gameManager: gameProgressManager
                        )
                    }
                }
            } else if !viewModel.hasEnoughLevel(for: reward, gameManager: gameProgressManager) {
                actionButton(title: "Locked", enabled: false)
            } else {
                actionButton(title: "Not enough", enabled: false)
            }
        }
    }

    private func actionButton(title: String, enabled: Bool, action: (() -> Void)? = nil) -> some View {
        Button {
            action?()
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(enabled ? .white : .black)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(enabled ? Color.blue : Color.gray.opacity(0.20))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }

    private func smallBadge(_ title: String, bg: Color, fg: Color) -> some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(fg)
            .padding(.horizontal, 12)
            .frame(height: 34)
            .background(bg)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func rewardBadgeColor(for reward: Reward) -> Color {
        let type = reward.rewardType.lowercased()
        if type.contains("limited") { return .orange }
        if type.contains("premium") { return .blue }
        return .gray
    }

    private func rewardImageName(for reward: Reward) -> String {
        let title = reward.title.lowercased()

        if title.contains("cinema") || title.contains("ticket") || title.contains("cavea") {
            return "reward_cinema_ticket"
        }

        if title.contains("internet") || title.contains("data") {
            return "reward_internet"
        }

        if title.contains("playstation") || title.contains("ps5") {
            return "reward_ps5"
        }

        if title.contains("roblox") {
            return "reward_roblox"
        }

        if title.contains("steam") {
            return "reward_steam"
        }

        return "reward_cinema_ticket"
    }

    private func formattedPoints(_ points: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: points)) ?? "\(points)"
    }
}

enum RewardCategory: CaseIterable {
    case all
    case premium
    case basic
    case limited

    var title: String {
        switch self {
        case .all:
            return "All"
        case .premium:
            return "Premium"
        case .basic:
            return "Basic"
        case .limited:
            return "Limited"
        }
    }
}
