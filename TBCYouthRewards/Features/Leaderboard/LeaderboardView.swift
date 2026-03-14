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
            VStack(spacing: 18) {
                if let currentUser {
                    currentUserCard(currentUser)
                }

                if viewModel.topThree.count == 3 {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Top 3")
                            .font(.system(size: 22, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        topThreePodium
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("All Rankings")
                        .font(.system(size: 22, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(viewModel.remainingUsers) { user in
                        rankingRow(user)
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

    private func currentUserCard(_ user: LeaderboardUser) -> some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(Color.blue.opacity(0.12))
            .frame(height: 150)
            .overlay(
                VStack(alignment: .leading, spacing: 10) {
                    Text("WEEKLY LEADERBOARD")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)

                    Text("Rank #\(user.rank)")
                        .font(.system(size: 24, weight: .bold))

                    Text("\(formattedPoints(user.weeklyPoints)) pts • Level \(user.level)")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    Text("\(viewModel.remainingToNextRank(username: gameProgressManager.username)) pts to reach Rank #\(max(user.rank - 1, 1))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
            )
    }

    private var topThreePodium: some View {
        let users = viewModel.topThree
        let first = users.first(where: { $0.rank == 1 })
        let second = users.first(where: { $0.rank == 2 })
        let third = users.first(where: { $0.rank == 3 })

        return RoundedRectangle(cornerRadius: 28)
            .fill(Color.white)
            .frame(height: 250)
            .overlay(
                HStack(alignment: .bottom, spacing: 18) {
                    if let second {
                        podiumUser(
                            user: second,
                            size: 92,
                            fill: Color(red: 0.69, green: 0.75, blue: 0.81),
                            stroke: Color(red: 0.82, green: 0.85, blue: 0.88),
                            crown: false,
                            rankOffsetX: 4
                        )
                        .padding(.bottom, 10)
                    }

                    if let first {
                        podiumUser(
                            user: first,
                            size: 122,
                            fill: Color(red: 0.95, green: 0.73, blue: 0.20),
                            stroke: Color(red: 0.98, green: 0.87, blue: 0.58),
                            crown: true,
                            rankOffsetX: 8
                        )
                        .padding(.bottom, 28)
                    }

                    if let third {
                        podiumUser(
                            user: third,
                            size: 92,
                            fill: Color(red: 0.87, green: 0.62, blue: 0.36),
                            stroke: Color(red: 0.94, green: 0.82, blue: 0.69),
                            crown: false,
                            rankOffsetX: 4
                        )
                        .padding(.bottom, 10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            )
    }

    private func podiumUser(
        user: LeaderboardUser,
        size: CGFloat,
        fill: Color,
        stroke: Color,
        crown: Bool,
        rankOffsetX: CGFloat
    ) -> some View {
        VStack(spacing: 8) {
            if crown {
                Image(systemName: "crown.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.yellow)
                    .padding(.bottom, 2)
            } else {
                Spacer()
                    .frame(height: 22)
            }

            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(fill)
                    .frame(width: size, height: size)
                    .overlay(
                        Circle()
                            .stroke(stroke, lineWidth: 5)
                    )
                    .overlay(
                        Text(initials(for: user.username))
                            .font(.system(size: size * 0.32, weight: .bold))
                            .foregroundColor(.white)
                    )

                Text("\(user.rank)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray)
                    .frame(width: 28, height: 28)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                    .offset(x: rankOffsetX, y: -6)
            }

            Text(user.username)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text("\(formattedPoints(user.weeklyPoints)) XP")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(user.rank == 1 ? .orange : .blue)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }

    private func rankingRow(_ user: LeaderboardUser) -> some View {
        let isCurrentUser = user.username.lowercased() == gameProgressManager.username.lowercased()

        return RoundedRectangle(cornerRadius: 22)
            .fill(isCurrentUser ? Color.blue.opacity(0.12) : Color.white)
            .frame(height: 94)
            .overlay(
                HStack(spacing: 14) {
                    Text("#\(user.rank)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.blue)
                        .frame(width: 44)

                    Circle()
                        .fill(Color.gray.opacity(0.12))
                        .frame(width: 54, height: 54)
                        .overlay(
                            Text(initials(for: user.username))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.gray)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.username)
                            .font(.system(size: 18, weight: .bold))

                        Text("Level \(user.level)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Text("\(formattedPoints(user.weeklyPoints)) pts")
                        .font(.system(size: 18, weight: .bold))
                }
                .padding(.horizontal, 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.black.opacity(0.04), lineWidth: 1)
            )
    }

    private func initials(for username: String) -> String {
        let parts = username.split(separator: " ")
        if parts.count >= 2 {
            let first = parts[0].first.map(String.init) ?? ""
            let second = parts[1].first.map(String.init) ?? ""
            return (first + second).uppercased()
        }
        return username.prefix(1).uppercased()
    }

    private func formattedPoints(_ points: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: points)) ?? "\(points)"
    }

    private func levelTitle(for level: Int) -> String {
        switch level {
        case 1...4:
            return "Explorer"
        case 5...9:
            return "Achiever"
        case 10...19:
            return "Challenger"
        case 20...49:
            return "Champion"
        default:
            return "Legend"
        }
    }
}
