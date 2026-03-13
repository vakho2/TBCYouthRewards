//
//  CardDesigner.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import SwiftUI
import PhotosUI

struct CardDesignerView: View {
    @StateObject private var viewModel = CardDesignerViewModel()
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showOrderPreview = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                cardPreview

                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            HStack {
                                Image(systemName: "photo")
                                Text("Upload Image")
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }

                        Button {
                            viewModel.reset()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Reset")
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Scale")
                                .font(.title3)
                                .fontWeight(.semibold)

                            Spacer()

                            Text("\(Int(viewModel.scale * 100))%")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                        }

                        Slider(value: $viewModel.scale, in: 0.8...1.4)

                        HStack {
                            Text("Rotate")
                                .font(.title3)
                                .fontWeight(.semibold)

                            Spacer()

                            Text("\(Int(viewModel.rotation))°")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                        }

                        Slider(value: $viewModel.rotation, in: -20...20)
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Theme Presets")
                            .font(.title3)
                            .fontWeight(.bold)

                        HStack(spacing: 16) {
                            ForEach(CardTheme.allCases) { theme in
                                Button {
                                    viewModel.selectedTheme = theme
                                } label: {
                                    Circle()
                                        .fill(theme.circleColor)
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Circle()
                                                .stroke(
                                                    viewModel.selectedTheme == theme ? Color.blue : Color.clear,
                                                    lineWidth: 3
                                                )
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    Button {
                        showOrderPreview = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Preview & Order Physical Card")
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right")
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .frame(height: 60)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                guard let newItem else { return }
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        viewModel.selectedImage = image
                    }
                }
            }
        }
        .sheet(isPresented: $showOrderPreview) {
            CardOrderPreviewView(viewModel: viewModel)
        }
    }

    private var cardPreview: some View {
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
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        viewModel.offset = CGSize(
                                            width: viewModel.lastOffset.width + value.translation.width,
                                            height: viewModel.lastOffset.height + value.translation.height
                                        )
                                    }
                                    .onEnded { _ in
                                        viewModel.lastOffset = viewModel.offset
                                    }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 28))
                    }

                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)

                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 32, height: 32)

                                Text("TBC YOUTH")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }

                            Spacer()

                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.yellow)
                                .frame(width: 50, height: 38)
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
                                .fontWeight(.medium)
                        }
                    }
                    .padding(24)
                }
            )
    }
}
