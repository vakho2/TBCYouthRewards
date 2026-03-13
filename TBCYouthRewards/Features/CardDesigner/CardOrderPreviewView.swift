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
                            colors: viewModel.selectedTheme.colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 220)
                    .overlay(
                        ZStack {
                            if let image = viewModel.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 320, height: 220)
                                    .scaleEffect(viewModel.scale)
                                    .rotationEffect(.degrees(viewModel.rotation))
                                    .offset(viewModel.offset)
                                    .clipShape(RoundedRectangle(cornerRadius: 28))
                            }

                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text("TBC YOUTH")
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .fontWeight(.bold)

                                    Spacer()
                                }

                                Spacer()

                                HStack(spacing: 14) {
                                    ForEach(0..<4) { _ in
                                        Text("••••")
                                            .foregroundColor(.white)
                                            .font(.title3)
                                    }
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("CARD HOLDER")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.caption)

                                    Text("ALEX JOHNSON")
                                        .foregroundColor(.white)
                                        .font(.title3)
                                }
                            }
                            .padding(24)
                        }
                    )

                VStack(spacing: 12) {
                    HStack {
                        Text("Card Type")
                        Spacer()
                        Text("TBC Youth")
                    }

                    HStack {
                        Text("Design Theme")
                        Spacer()
                        Text("Custom")
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
