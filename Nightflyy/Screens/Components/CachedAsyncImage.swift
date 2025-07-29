//
//  CachedAsyncImage.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/2/25.
//

import SwiftUI

public struct CachedAsyncImage<S: Shape>: View {
    private let shape: S
    private let url: URL?
    private let contentMode: ContentMode = .fill
    private let size: CGSize
    @State private var image: Image? = nil
    @State private var isLoading = false

    public init(url: URL?, size: CGSize, shape: S, contentMode: ContentMode = .fill) {
        self.url = url
        self.size = size
        self.shape = shape
    }

    public var body: some View {
        if let image = image {
            image
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .frame(width: size.width, height: size.height)
                .clipShape(shape)
        } else {
            SkeletonView(shape)
                .frame(width: size.width, height: size.height)
                .task {
                    await loadImage()
                }
        }
    }

    private func loadImage() async {
        guard let url = url, !isLoading else { return }

        // Ensure state updates are isolated to the main actor
        isLoading = true

        // Check if the image is already cached
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            await MainActor.run {
                self.image = Image(uiImage: cachedImage)
                self.isLoading = false
            }
            return
        }

        // Fetch the image from the network
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Cache the image
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: request)

            if let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.image = Image(uiImage: uiImage)
                    self.isLoading = false
                }
            }
        } catch {
            // Handle any errors here (e.g., network failure)
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}
