//
//  EventGuestListViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/21/25.
//

import Foundation
import SwiftUI

@Observable
class EventGuestListViewModel: NSObject {
    
    var event: Event
    var selectedSegment: Int
    let segments = [SegmentedViewOption(id: 1, title: "Going"), SegmentedViewOption(id: 2, title: "Interested"), SegmentedViewOption(id: 3, title: "Invited")]
    
    init(event: Event, selectedSegment: Int) {
        self.event = event
        self.selectedSegment = selectedSegment
    }
    
    var displayArray: [String] {
        selectedSegment == 1 ? event.attending ?? [] : selectedSegment == 2 ? event.interested ?? [] : event.invited ?? []
    }
}
