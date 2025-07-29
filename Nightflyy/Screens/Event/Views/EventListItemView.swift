//
//  EventListItemView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/11/24.
// 

import SwiftUI

struct EventListItemView: View {
    
    var viewModel: EventListItemViewModel
    var tapAction: ButtonAction? = nil
    
    var body: some View {
        HStack(spacing: 0) {
                EventImage(imageUrl: viewModel.event.eventFlyerUrl, size: CGSize(width: 70, height: 70))
                    .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.event.eventName ?? "")
                        .foregroundStyle(.white)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text("Hosted by \(viewModel.eventOwner?.username ?? "Unclaimed")")
                        .foregroundStyle(.gray)
                        .font(.system(size: 12))
                    
                    Text(viewModel.event.eventVenue ?? "")
                        .foregroundStyle(.gray)
                        .font(.system(size: 12))
                }
                .padding(.leading, 12)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 4) {
                    Text(viewModel.weekday)
                        .foregroundStyle(.white)
                        .font(.footnote)
                        .fontWeight(.medium)
                    
                    Text(viewModel.month)
                        .foregroundStyle(.gray)
                        .font(.system(size: 12))
                    
                    Text(viewModel.day)
                        .foregroundStyle(.gray)
                        .font(.system(size: 12))
                }
                .padding(.trailing, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.05))
            .shadow(color: .gray.opacity(0.3), radius: 10.0)
            .cornerRadius(12, corners: .allCorners)
            .overlay(content: {
                if viewModel.isSelected {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.mainPurple, lineWidth: 4)
                }
            })
            .onTapGesture {
                tapAction?()
            }
    }
}

//#Preview {
//    EventListItemView(viewModel: EventListItemViewModel(event: TestData.events.first!), tapAction: nil)
//        .preferredColorScheme(.dark)
//}
