//
//  NetworkHelper.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/26/25.
//

import Foundation

class NetworkHelper {
    
    static func BuildApiUrl(base: String, endPoint: String) -> URL? {
        guard let baseString: String = try? AppConfiguration.value(for: base) else { return nil }
        let urlString = baseString + endPoint
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
}
