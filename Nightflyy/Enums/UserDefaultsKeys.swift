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
    case nfpReferred
    case lastNotificationsFetchDate

    func getValue<T>() -> T? {
        switch self {

        case .hideSwipeForActionsPrompt:
            UserDefaults.standard.bool(forKey: rawValue) as? T
        case .bonusCredit:
            UserDefaults.standard.integer(forKey: rawValue) as? T
        case .nfpReferred:
            UserDefaults.standard.string(forKey: rawValue) as? T
        case .lastNotificationsFetchDate:
            UserDefaults.standard.object(forKey: rawValue) as? Date as? T
        }
   
    }
    
    func setValue<T>(_ value: T) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    func removeValue() {
        UserDefaults.standard.removeObject(forKey: rawValue)
    }
}
