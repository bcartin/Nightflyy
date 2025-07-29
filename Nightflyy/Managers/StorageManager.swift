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
        let imageFileName = UUID().uuidString
        let imageStorageRef = storageRef.child("profile_images").child(imageFileName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let newImage = self.resizeImage(image: photo)
        if let uploadData = newImage.jpegData(compressionQuality: 1.0) {
            do {
                _ = try await imageStorageRef.putDataAsync(uploadData, metadata: metadata)
                let url = try await imageStorageRef.downloadURL()
                let urlString = url.absoluteString
                return urlString
            }
            catch {
                throw error
            }
        }
        return nil
    }
    
    func saveEventPhoto(photo: UIImage) async throws -> String? {
        let imageFileName = UUID().uuidString
        let imageStorageRef = storageRef.child("event_images").child(imageFileName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let newImage = self.resizeImage(image: photo)
        if let uploadData = newImage.jpegData(compressionQuality: 1.0) {
            do {
                _ = try await imageStorageRef.putDataAsync(uploadData, metadata: metadata)
                let url = try await imageStorageRef.downloadURL()
                let urlString = url.absoluteString
                return urlString
            }
            catch {
                throw error
            }
        }
        return nil
    }
    
    func deletePhoto(url: String) async throws {
        do {
            if let storageUrl = URL(string: url) {
                let fileRef = try Storage.storage().reference(for: storageUrl)
                try await fileRef.delete()
            }
        }
        catch {
            throw error
        }
    }
    
    public func resizeImage(image: UIImage, maxSize: CGSize = CGSize(width: 400, height: 700)) -> UIImage {
        var returnImage : UIImage = UIImage()
        var actualHeight = image.size.height
        var actualWidth = image.size.width
        let maxWidth = maxSize.width
        let maxHeight = maxSize.height
        var imageRatio = actualWidth/actualHeight
        let maxRatio = maxWidth/maxHeight
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imageRatio < maxRatio {
                imageRatio = maxHeight / actualHeight
                actualWidth = imageRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imageRatio > maxRatio{
                imageRatio = maxWidth / actualWidth
                actualHeight = imageRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        if let img = UIGraphicsGetImageFromCurrentImageContext() {
            if let imageData = img.jpegData(compressionQuality: 1.0) {
                UIGraphicsEndImageContext()
                returnImage = UIImage(data: imageData)!
            }
        }
        return returnImage
    }
    
}
