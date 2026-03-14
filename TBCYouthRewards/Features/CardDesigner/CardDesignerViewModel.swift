//
//  CardDesignerViewModel.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 12.03.26.
//

import SwiftUI
import Combine

final class CardDesignerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var offset: CGSize = .zero
    @Published var lastOffset: CGSize = .zero

    func reset() {
        selectedImage = nil
        offset = .zero
        lastOffset = .zero
    }

    func clampedOffset(
        proposed: CGSize,
        image: UIImage,
        containerSize: CGSize
    ) -> CGSize {
        let imageSize = image.size
        guard imageSize.width > 0, imageSize.height > 0,
              containerSize.width > 0, containerSize.height > 0 else {
            return .zero
        }

        let widthScale = containerSize.width / imageSize.width
        let heightScale = containerSize.height / imageSize.height
        let fillScale = max(widthScale, heightScale)

        let renderedWidth = imageSize.width * fillScale
        let renderedHeight = imageSize.height * fillScale

        let maxX = max((renderedWidth - containerSize.width) / 2, 0)
        let maxY = max((renderedHeight - containerSize.height) / 2, 0)

        return CGSize(
            width: min(max(proposed.width, -maxX), maxX),
            height: min(max(proposed.height, -maxY), maxY)
        )
    }
}
