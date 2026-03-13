//
//  LeaderboardView.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @EnvironmentObject var gameProgressManager: GameProgressManager

    var body: some View {
        let currentUser = viewModel.currentUser(username: gameProgressManager.username)

        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                if let currentUser {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.blue.opacity(0.12))
                        .frame(height: 120)
                        .overlay(
                            VStack(alignment: .leading, spacing: 8) {
                                Text("WEEKLY LEADERBOARD")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)

                                Text("Rank #\(currentUser.rank)")
                                    .font(.title2)
                                    .fontWeight(.bold)

                                Text("\(currentUser.weeklyPoints) pts • Level \(currentUser.level)")
                                    .foregroundColor(.gray)

                                Text("\(viewModel.remainingToNextRank(username: gameProgressManager.username)) pts to reach Rank #\(max(currentUser.rank - 1, 1))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                        )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Top 3")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 12) {
                        ForEach(viewModel.topThree) { user in
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(height: 150)
                                .overlay(
                                    VStack(spacing: 10) {
                                        Text("#\(user.rank)")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)

                                        Circle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 52, height: 52)

                                        Text(user.username)
                                            .font(.subheadline)
                                            .fontWeight(.bold)

                                        Text("\(user.weeklyPoints) pts")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 12)
                                )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("All Rankings")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(viewModel.users) { user in
                        let isCurrentUser = user.username.lowercased() == gameProgressManager.username.lowercased()

                        RoundedRectangle(cornerRadius: 18)
                            .fill(isCurrentUser ? Color.blue.opacity(0.12) : Color.white)
                            .frame(height: 72)
                            .overlay(
                                HStack(spacing: 12) {
                                    Text("#\(user.rank)")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                        .frame(width: 36)

                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 40, height: 40)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(user.username)
                                            .font(.subheadline)
                                            .fontWeight(.bold)

                                        Text("Level \(user.level)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    Text("\(user.weeklyPoints) pts")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                                .padding(.horizontal, 14)
                            )
                            .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .task {
            await viewModel.loadLeaderboard()
        }
    }
}
