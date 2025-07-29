//
//  NSCache+Subscript.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/12/24.
//

import Foundation


extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject {
    subscript(_ key: String) -> CacheEntry? {
        get {
            let value = object(forKey: key as NSString)
            return value?.entry
        }
        set {
            if let entry = newValue {
                let value = CacheEntryObject(entry: entry)
                setObject(value, forKey: key as NSString)
            } else {
                removeObject(forKey: key as NSString)
            }
        }
    }
}
