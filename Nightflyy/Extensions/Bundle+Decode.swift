//
//  Bundle+Decode.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/5/24.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        // 1. Locate the JSON file
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }
        
        // 2. Create a property for the data
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        
        // 3. Create a decoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        // 4. Create a property for the decoded data
//        guard let loaded = try? decoder.decode(T.self, from: data) else {
//            fatalError("Failed to decode \(file) from bundle")
//        }
        do {
            let loaded = try decoder.decode(T.self, from: data)
            return loaded
        }
        catch {
            print(error.localizedDescription)
        }
        
        // 5. Return the ready to use data
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle")
        }
        return loaded
    }
}
