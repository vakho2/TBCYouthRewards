//
//  TBCYouthRewardsApp.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import SwiftUI

@main
struct TBCYouthRewardsApp: App {
    @StateObject private var gameProgressManager = GameProgressManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(gameProgressManager)
        }
    }
}
