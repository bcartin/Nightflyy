//
//  UserDefaultsKeys.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/2/25.
//

import Foundation

enum UserDefaultsKeys :String {
    case hideSwipeForActionsPrompt
    case bonusCredit
    
    func getValue<T>() -> T? {
        switch self {
            
        case .hideSwipeForActionsPrompt:
            UserDefaults.standard.bool(forKey: rawValue) as? T ?? false as! T
        case .bonusCredit:
            UserDefaults.standard.integer(forKey: rawValue) as? T
        }
   
    }
    
    func setValue<T>(_ value: T) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    func removeValue() {
        UserDefaults.standard.removeObject(forKey: rawValue)
    }
}
