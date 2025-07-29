//
//  UniversalLink.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/18/25.
//

import Foundation

class UniversalLink {
    
    var url: URL
    var type: UniversalLinkType
    var objectId: String?
    
    init(url: URL) {
        self.url = url
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let typeString = components?.queryItems?.first{$0.name == "type"}?.value ?? ""
        type = UniversalLinkType(rawValue: typeString) ?? .other
        objectId = components?.queryItems?.first{$0.name == "id"}?.value
    }
    
}
