//
//  CardDesignerViewModel.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import Foundation
import SwiftUI
import Combine

final class CardDesignerViewModel: ObservableObject {
    @Published var selectedTheme: CardTheme = .blue
    @Published var scale: CGFloat = 1.0
    @Published var rotation: Double = 0
    @Published var selectedImage: UIImage?
    @Published var offset: CGSize = .zero
    @Published var lastOffset: CGSize = .zero

    func reset() {
        selectedTheme = .blue
        scale = 1.0
        rotation = 0
        selectedImage = nil
        offset = .zero
        lastOffset = .zero
    }
}

enum CardTheme: CaseIterable, Identifiable {
    case blue
    case pink
    case green
    case orange
    case navy
    case purple

    var id: Self { self }

    var colors: [Color] {
        switch self {
        case .blue:
            return [Color.cyan, Color.blue]
        case .pink:
            return [Color.pink, Color.red.opacity(0.7)]
        case .green:
            return [Color.mint, Color.green]
        case .orange:
            return [Color.orange, Color.yellow]
        case .navy:
            return [Color.indigo, Color.black]
        case .purple:
            return [Color.purple, Color.blue.opacity(0.7)]
        }
    }

    var circleColor: Color {
        switch self {
        case .blue: return .blue
        case .pink: return .pink
        case .green: return .mint
        case .orange: return .orange
        case .navy: return .indigo
        case .purple: return .purple
        }
    }
}
