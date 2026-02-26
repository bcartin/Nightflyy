//
//  StorageManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/10/25.
//

import Foundation
import FirebaseStorage
import SwiftUI
import UIKit

class StorageManager {
    
    let storageRef = Storage.storage().reference()
    
    func saveProfilePhoto(photo: UIImage) async throws -> String? {
        try await savePhoto(photo: photo, path: "profile_images")
    }
    
    func saveEventPhoto(photo: UIImage) async throws -> String? {
        try await savePhoto(photo: photo, path: "event_images")
    }
    
    func deletePhoto(url: String) async throws {
        if let storageUrl = URL(string: url) {
            let fileRef = try Storage.storage().reference(for: storageUrl)
            try await fileRef.delete()
        }
    }
    
    private func savePhoto(photo: UIImage, path: String) async throws -> String? {
        let imageFileName = UUID().uuidString
        let imageStorageRef = storageRef.child(path).child(imageFileName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let newImage = self.resizeImage(image: photo)
        if let uploadData = newImage.jpegData(compressionQuality: 1.0) {
            _ = try await imageStorageRef.putDataAsync(uploadData, metadata: metadata)
            let url = try await imageStorageRef.downloadURL()
            return url.absoluteString
        }
        return nil
    }
    
    public func resizeImage(image: UIImage, maxSize: CGSize = CGSize(width: 400, height: 700)) -> UIImage {
        var actualHeight = image.size.height
        var actualWidth = image.size.width
        let maxWidth = maxSize.width
        let maxHeight = maxSize.height
        var imageRatio = actualWidth / actualHeight
        let maxRatio = maxWidth / maxHeight
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imageRatio < maxRatio {
                imageRatio = maxHeight / actualHeight
                actualWidth = imageRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imageRatio > maxRatio {
                imageRatio = maxWidth / actualWidth
                actualHeight = imageRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let targetSize = CGSize(width: actualWidth, height: actualHeight)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
}
