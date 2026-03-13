//
//  MainTabView.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = MainTabViewModel()
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(AppTab.home)

            TriviaView()
                .tabItem {
                    Image(systemName: "questionmark.circle")
                    Text("Trivia")
                }
                .tag(AppTab.trivia)

            LeaderboardView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("Leaderboard")
                }
                .tag(AppTab.leaderboard)

            RewardsView()
                .tabItem {
                    Image(systemName: "gift")
                    Text("Rewards")
                }
                .tag(AppTab.rewards)

            CardDesignerView()
                .tabItem {
                    Image(systemName: "creditcard")
                    Text("Cards")
                }
                .tag(AppTab.cards)
        }
        .tint(.blue)
    }
}
