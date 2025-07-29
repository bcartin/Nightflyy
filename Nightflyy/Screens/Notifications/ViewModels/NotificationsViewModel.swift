//
//  NotificationsViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/2/25.
//
//
import Foundation
import SwiftUI

@Observable
class NotificationsViewModel {
    
    init() {
        hideSwipeForActionPrompt = UserDefaultsKeys.hideSwipeForActionsPrompt.getValue() ?? false
    }
    
    var hideSwipeForActionPrompt: Bool = false
    
    
    func setHideSwipeForActionPrompt(_ value: Bool) {
        UserDefaultsKeys.hideSwipeForActionsPrompt.setValue(value)
        withAnimation { self.hideSwipeForActionPrompt = value }
        
    }
}
