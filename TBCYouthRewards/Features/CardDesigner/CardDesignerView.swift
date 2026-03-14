//
//  CardDesigner.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct CardDesignerView: View {
    @StateObject private var viewModel = CardDesignerViewModel()
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showOrderPreview = false
    @State private var showSourceDialog = false
    @State private var showFileImporter = false
    @EnvironmentObject var gameProgressManager: GameProgressManager

    private var cardWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }

    private var cardHeight: CGFloat {
        cardWidth / 1.58
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                bonusCard

                if viewModel.selectedImage == nil {
                    uploadArea
                } else {
                    cardEditor
                    actionButtons
                }

                tipsSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showSourceDialog) {
            VStack(spacing: 20) {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 42, height: 5)
                    .padding(.top, 8)

                Text("Select Image Source")
                    .font(.title3)
                    .fontWeight(.bold)

                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                        Text("Photo Library")
                        Spacer()
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .padding(.horizontal, 16)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding(.horizontal, 20)

                Button {
                    showSourceDialog = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        showFileImporter = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "folder")
                        Text("Files")
                        Spacer()
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .padding(.horizontal, 16)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding(.horizontal, 20)

                if viewModel.selectedImage != nil {
                    Button {
                        viewModel.reset()
                        showSourceDialog = false
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Remove Photo")
                            Spacer()
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .padding(.horizontal, 16)
                        .background(Color.red.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .padding(.horizontal, 20)
                }

                Button {
                    showSourceDialog = false
                } label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
            .presentationDetents([.height(viewModel.selectedImage == nil ? 280 : 350)])
            .presentationDragIndicator(.hidden)
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                guard url.startAccessingSecurityScopedResource() else { return }
                defer { url.stopAccessingSecurityScopedResource() }

                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    viewModel.selectedImage = image
                    viewModel.offset = .zero
                    viewModel.lastOffset = .zero
                }
            case .failure:
                break
            }
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                guard let newItem else { return }
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        viewModel.selectedImage = image
                        viewModel.offset = .zero
                        viewModel.lastOffset = .zero
                    }
                }
            }
        }
        .sheet(isPresented: $showOrderPreview) {
            CardOrderPreviewView(viewModel: viewModel)
                .environmentObject(gameProgressManager)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Card Designer")
                .font(.system(size: 32, weight: .bold))

            Text("Upload your favorite picture, place it on the card, and order your personalized design.")
                .font(.title3)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var bonusCard: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.75))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "star.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("10% Points Bonus")
                    .font(.headline)
                    .fontWeight(.bold)

                Text("Your custom card gives you extra points on every reward action.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.08), Color.green.opacity(0.07)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.blue.opacity(0.14), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }

    private var uploadArea: some View {
        Button {
            showSourceDialog = true
        } label: {
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(width: 64, height: 64)

                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.blue)
                }

                Text("Tap to upload your photo")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("PNG, JPG, JPEG, HEIC")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 240)
            .background(Color.blue.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 26)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [7]))
            )
            .clipShape(RoundedRectangle(cornerRadius: 26))
        }
        .buttonStyle(.plain)
    }

    private var cardEditor: some View {
        VStack(spacing: 16) {
            cardPreview

            HStack(spacing: 12) {
                actionChip(title: "Upload Image", systemImage: "photo.on.rectangle") {
                    showSourceDialog = true
                }

                actionChip(title: "Reset", systemImage: "arrow.counterclockwise") {
                    viewModel.reset()
                }
            }
        }
    }

    private var cardPreview: some View {
        GeometryReader { proxy in
            let size = proxy.size

            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.21, blue: 0.48),
                            Color(red: 0.21, green: 0.40, blue: 0.84)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    ZStack {
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height)
                                .offset(viewModel.offset)
                                .clipped()
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            let proposed = CGSize(
                                                width: viewModel.lastOffset.width + value.translation.width,
                                                height: viewModel.lastOffset.height + value.translation.height
                                            )

                                            viewModel.offset = viewModel.clampedOffset(
                                                proposed: proposed,
                                                image: image,
                                                containerSize: size
                                            )
                                        }
                                        .onEnded { _ in
                                            viewModel.lastOffset = viewModel.offset
                                        }
                                )
                        }

                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)

                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color.white.opacity(0.18))
                                        .frame(width: 34, height: 34)

                                    Text("TBC YOUTH")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                }

                                Spacer()

                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.yellow)
                                    .frame(width: 56, height: 42)
                            }

                            Spacer()

                            HStack(spacing: 16) {
                                ForEach(0..<4, id: \.self) { _ in
                                    Text("••••")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("CARD HOLDER")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.82))

                                Text(gameProgressManager.username.uppercased())
                                    .font(.system(size: 19, weight: .medium))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.75)
                            }
                        }
                        .padding(22)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                }
                .shadow(color: .black.opacity(0.10), radius: 18, x: 0, y: 10)
        }
        .frame(width: cardWidth, height: cardHeight)
    }

    private var actionButtons: some View {
        Button {
            showOrderPreview = true
        } label: {
            HStack(spacing: 10) {
                Spacer()
                Text("Preview & Order Physical Card")
                    .font(.headline)
                    .fontWeight(.bold)
                Image(systemName: "arrow.right")
                    .font(.headline)
                Spacer()
            }
            .foregroundColor(.black)
            .frame(height: 60)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 26))
        }
        .buttonStyle(.plain)
    }

    private var tipsSection: some View {
        VStack(spacing: 12) {
            infoRow(
                title: "Upload",
                subtitle: "Choose any image from Photos or Files.",
                systemImage: "square.and.arrow.up"
            )

            infoRow(
                title: "Move",
                subtitle: "Drag the photo to place it exactly where you want.",
                systemImage: "hand.draw"
            )

            infoRow(
                title: "Order",
                subtitle: "Preview your design and request the physical card.",
                systemImage: "checkmark.circle"
            )
        }
    }

    private func infoRow(title: String, subtitle: String, systemImage: String) -> some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.blue.opacity(0.08))
                .frame(width: 52, height: 52)
                .overlay(
                    Image(systemName: systemImage)
                        .font(.title3)
                        .foregroundColor(.blue)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )
    }

    private func actionChip(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.title3)

                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(title == "Upload Image" ? .blue : .primary)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(title == "Upload Image" ? Color.blue.opacity(0.10) : Color.gray.opacity(0.10))
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
        .buttonStyle(.plain)
    }
}
