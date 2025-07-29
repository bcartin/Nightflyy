//
//  AnalyticsManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 7/14/25.
//

import Mixpanel

class AnalyticsManager {
    
    static func setUserID(value: String?) {
        #if RELEASE
        Mixpanel.mainInstance().identify(distinctId: value ?? "Unknown")
        #endif
    }
    
}
