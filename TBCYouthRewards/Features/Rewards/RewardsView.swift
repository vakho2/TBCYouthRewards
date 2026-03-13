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

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.blue.opacity(0.12))
                    .frame(height: 120)
                    .overlay(
                        VStack(alignment: .leading, spacing: 8) {
                            Text("YOUR REWARDS BALANCE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)

                            Text("\(gameProgressManager.totalPoints) pts")
                                .font(.system(size: 30, weight: .bold))

                            Text("Level \(gameProgressManager.currentLevel) • Use your points to unlock rewards")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                    )

                VStack(alignment: .leading, spacing: 12) {
                    Text("Featured Rewards")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(viewModel.featuredRewards) { reward in
                        rewardRow(reward)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("All Rewards")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(viewModel.rewards) { reward in
                        rewardRow(reward)
                    }
                }
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

    private func rewardRow(_ reward: Reward) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .frame(height: 120)
            .overlay(
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 72, height: 72)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(reward.title)
                            .font(.subheadline)
                            .fontWeight(.bold)

                        Text(reward.rewardType)
                            .font(.caption)
                            .foregroundColor(.gray)

                        Text("\(reward.cost) pts • Level \(reward.levelRequired)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }

                    Spacer()

                    if reward.isRedeemed && !reward.isRepeatable {
                        Text("Redeemed")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.12))
                            .clipShape(Capsule())
                    } else if viewModel.canRedeem(reward, gameManager: gameProgressManager) {
                        Button {
                            Task {
                                await viewModel.redeemReward(
                                    userId: gameProgressManager.userId,
                                    rewardId: reward.id,
                                    gameManager: gameProgressManager
                                )
                            }
                        } label: {
                            Text("Claim")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .clipShape(Capsule())
                        }
                    } else if !viewModel.hasEnoughLevel(for: reward, gameManager: gameProgressManager) {
                        Text("Locked")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.12))
                            .clipShape(Capsule())
                    } else {
                        Text("Not enough")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 14)
            )
            .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
    }
}
