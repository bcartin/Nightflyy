//
//  EventPreferencesViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import SwiftUI

@Observable
class EventPreferencesViewModel {
    
    var selectedSegment: Int = 1
    let segments = [SegmentedViewOption(id: 1, title: "Music"), SegmentedViewOption(id: 2, title: "Crowds"), SegmentedViewOption(id: 3, title: "Venues")]
    var error: Error?

    var account: Account
    var isLoading: Bool = false
    
    init() {
        self.account =  AccountManager.shared.account ?? Account()
    }
    
    var selectedMusic: [String] {
        get {
            return account.music ?? []
        }
        set(newValue) {
            account.music = newValue
        }
    }
    
    var selectedVenues: [String] {
        get {
            return account.venues ?? []
        }
        set(newValue) {
            account.venues = newValue
        }
    }
    
    var selectedClientele: [String] {
        get {
            return account.clientele ?? []
        }
        set(newValue) {
            account.clientele = newValue
        }
    }
    
    func saveChanges() {
        Task {
                self.isLoading = true
                do {
                    try account.save()
                    try? await Task.sleep(for: .seconds(2))
                    isLoading = false
                    AccountManager.shared.account = self.account
                    General.showSavedMessage()
                }
                catch {
                    self.error = error
                }
            }
    }
    
}

