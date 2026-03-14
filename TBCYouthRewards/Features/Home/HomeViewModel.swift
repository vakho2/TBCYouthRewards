//
//  HomeViewModel.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var leaderboardUsers: [HomeLeaderboardUser] = [
        HomeLeaderboardUser(name: "Alex K.", xp: "1,200 XP"),
        HomeLeaderboardUser(name: "Mariam G.", xp: "1,050 XP"),
        HomeLeaderboardUser(name: "Luka M.", xp: "980 XP")
    ]

    @Published var topRewards: [HomeRewardItem] = [
        HomeRewardItem(title: "Cinema Ticket", subtitle: "", points: "400 pts"),
        HomeRewardItem(title: "PlayStation 5", subtitle: "", points: "5,000 pts"),
        HomeRewardItem(title: "Roblox Gift Card", subtitle: "", points: "500 pts")
    ]

    @Published var quickActions: [HomeQuickAction] = [
        HomeQuickAction(title: "Check-in", icon: "person.fill.checkmark"),
        HomeQuickAction(title: "Trivia", icon: "questionmark.square"),
        HomeQuickAction(title: "Metro Tap", icon: "tram.fill"),
        HomeQuickAction(title: "Snack", icon: "takeoutbag.and.cup.and.straw.fill")
    ]
}
