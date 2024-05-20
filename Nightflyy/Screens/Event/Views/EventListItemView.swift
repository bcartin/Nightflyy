//
//  EventListItemView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/11/24.
//

import SwiftUI

struct EventListItemView: View {
    
    var event: Event
    
    var body: some View {
        HStack() {
            EventImage(imageUrl: event.eventFlyerUrl, size: CGSize(width: 100, height: 88))
                .cornerRadius(12, corners: [.topLeft, .bottomLeft])
            
            VStack(alignment: .leading, spacing: 8) {
                Text(event.eventName ?? "")
                    .foregroundStyle(.white)
                    .font(.system(size: 17, weight: .bold))
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text("Hosted by Nightflyy")
                    .foregroundStyle(.gray)
                    .font(.system(size: 12))
                
                Text("Gilded Club")
                    .foregroundStyle(.gray)
                    .font(.system(size: 12))
            }
            .padding(.leading, 12)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 8) {
                Text("Tue")
                    .foregroundStyle(.white)
                    .font(.system(size: 17, weight: .bold))
                
                Text("Dec")
                    .foregroundStyle(.gray)
                    .font(.system(size: 12))
                
                Text("31")
                    .foregroundStyle(.gray)
                    .font(.system(size: 12))
            }
            .padding(.trailing, 24)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.1))
        .cornerRadius(12, corners: .allCorners)
    }
}

#Preview {
    EventListItemView(event: TestData.event)
        .preferredColorScheme(.dark)
}
