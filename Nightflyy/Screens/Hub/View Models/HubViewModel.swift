//
//  HubViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/3/25.
//


import SwiftUI

@Observable
class HubViewModel: NSObject {
    
    var selectedSegment: Int = 1
    let segments = [SegmentedViewOption(id: 1, title: "Upcoming"), SegmentedViewOption(id: 2, title: "Hosting"), SegmentedViewOption(id: 3, title: "Calendar")]

    func navigateToCreateNewEvent() {
        let viewModel = CreateEventViewModel(event: Event())
        Router.shared.navigateTo(.CreateEvent(viewModel))
    }
}
