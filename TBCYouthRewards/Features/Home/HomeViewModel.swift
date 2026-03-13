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

    @Published var featuredRewards: [HomeRewardItem] = [
        HomeRewardItem(title: "Starbucks Voucher", subtitle: "Get 10 GEL off", points: "500 pts"),
        HomeRewardItem(title: "Cavea Ticket", subtitle: "Any movie screening", points: "800 pts")
    ]

    @Published var recentActivities: [HomeActivityItem] = [
        HomeActivityItem(title: "Daily Check-in", subtitle: "Today, 09:12 AM", value: "+10 XP"),
        HomeActivityItem(title: "Snack Spend Bonus", subtitle: "Yesterday, 04:30 PM", value: "+25 pts")
    ]

    @Published var quickActions: [HomeQuickAction] = [
        HomeQuickAction(title: "Check-in", icon: "person.fill.checkmark"),
        HomeQuickAction(title: "Trivia", icon: "questionmark.square"),
        HomeQuickAction(title: "Metro Tap", icon: "tram.fill"),
        HomeQuickAction(title: "Snack", icon: "takeoutbag.and.cup.and.straw.fill")
    ]

    func addRecentActivity(title: String, value: String) {
        recentActivities.insert(
            HomeActivityItem(
                title: title,
                subtitle: "Today",
                value: value
            ),
            at: 0
        )
    }
}
