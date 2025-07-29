//
//  Cache.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/12/24.
//

import Foundation

enum CacheEntry {
    case account(Account)
    case event(Event)
}

final class CacheEntryObject {
    let entry: CacheEntry
    
    init(entry: CacheEntry) {
        self.entry = entry
    }
}

let firebaseCache: NSCache<NSString, CacheEntryObject> = NSCache()
