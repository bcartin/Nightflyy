//
//  EventCardSmallView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/24.
//

import SwiftUI

struct EventCardSmallView: View {
    
    var event: Event
    @Environment(Router.self) private var router
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            EventImage(imageUrl: event.eventFlyerUrl, size: CGSize(width: 136, height: 124))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading) {
                Text(event.eventName ?? "")
                    .foregroundStyle(.white)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.top, 2)
                    .padding(.horizontal, 4)
                
                Text(event.eventVenue ?? "")
                    .foregroundStyle(.gray)
                    .font(.system(size: 12))
                    .padding(.bottom, 4)
                    .padding(.horizontal, 4)
            }
            .frame(maxWidth: 136, alignment: .leading)
            .background(Color.black.brightness(0.1))
            .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        }
        .onTapGesture {
            let viewModel = EventViewModel(event: event)
            router.navigateTo(.Event(viewModel))
        }
    }
}

#Preview {
    EventCardSmallView(event: TestData.events.first!)
}
