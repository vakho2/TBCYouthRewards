//
//  CardOrderPreviewView.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import SwiftUI

struct CardOrderPreviewView: View {
    @ObservedObject var viewModel: CardDesignerViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameProgressManager: GameProgressManager
    @State private var isOrderPlaced = false

    var body: some View {
        VStack(spacing: 24) {
            if isOrderPlaced {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.green)

                    Text("Order Confirmed")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Your custom physical card has been successfully ordered.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            } else {
                Text("Card Preview")
                    .font(.title2)
                    .fontWeight(.bold)

                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.13, green: 0.22, blue: 0.49),
                                Color(red: 0.21, green: 0.42, blue: 0.86)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 220)
                    .overlay(
                        GeometryReader { proxy in
                            let size = proxy.size

                            ZStack {
                                if let image = viewModel.selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: size.width, height: size.height)
                                        .offset(viewModel.offset)
                                        .clipped()
                                }

                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)

                                VStack(alignment: .leading, spacing: 20) {
                                    HStack {
                                        HStack(spacing: 12) {
                                            Circle()
                                                .fill(Color.white.opacity(0.18))
                                                .frame(width: 32, height: 32)

                                            Text("TBC YOUTH")
                                                .foregroundColor(.white)
                                                .font(.title3)
                                                .fontWeight(.bold)
                                        }

                                        Spacer()

                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.yellow)
                                            .frame(width: 54, height: 40)
                                    }

                                    Spacer()

                                    HStack(spacing: 14) {
                                        ForEach(0..<4, id: \.self) { _ in
                                            Text("••••")
                                                .foregroundColor(.white)
                                                .font(.title3)
                                        }
                                    }

                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("CARD HOLDER")
                                            .foregroundColor(.white.opacity(0.8))
                                            .font(.caption)

                                        Text(gameProgressManager.username.uppercased())
                                            .foregroundColor(.white)
                                            .font(.title3)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.75)
                                    }
                                }
                                .padding(24)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 28))
                        }
                    )

                VStack(spacing: 12) {
                    HStack {
                        Text("Card Type")
                        Spacer()
                        Text("TBC Youth")
                    }

                    HStack {
                        Text("Uploaded Photo")
                        Spacer()
                        Text(viewModel.selectedImage == nil ? "No" : "Yes")
                    }

                    HStack {
                        Text("Delivery")
                        Spacer()
                        Text("3-5 days")
                    }
                }
                .font(.subheadline)
                .padding(20)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Button {
                    isOrderPlaced = true
                } label: {
                    Text("Confirm Order")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .padding(24)
    }
}
