//
//  UpcomingView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/28/25.
//

import SwiftUI

struct UpcomingView: View {
    
    var viewModel = UpcomingViewModel()
    
    var noEventsView: some View {
        Text("No Events")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 48)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("GOING")
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
                    .padding(.vertical, 12)
                
                if viewModel.eventsAttending.isEmpty {
                    noEventsView
                }
                else {
                    ForEach(viewModel.eventsAttending, id: \.self) { viewModel in
                        EventListItemView(viewModel: viewModel) {
                            viewModel.navigateToEvent()
                        }
                    }
                }
                
                Text("INTERESTED")
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
                    .padding(.vertical, 12)
                
                if viewModel.eventsInterested.isEmpty {
                    noEventsView
                }
                else {
                    ForEach(viewModel.eventsInterested, id: \.self) { viewModel in
                        EventListItemView(viewModel: viewModel) {
                            viewModel.navigateToEvent()
                        }
                    }
                }
                
                Text("INVITED")
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
                    .padding(.vertical, 12)
                
                if viewModel.eventsInvited.isEmpty {
                    noEventsView
                }
                else {
                    ForEach(viewModel.eventsInvited, id: \.self) { viewModel in
                        EventListItemView(viewModel: viewModel) {
                            viewModel.navigateToEvent()
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
        }
        .task {
            await viewModel.fetchEvents(refetch: false)
        }
        .refreshable {
            await viewModel.fetchEvents(refetch: true)
        }
    }
}

#Preview {
    //UpcomingView()
    
    HubView(showMenu: .constant(false), viewModel: HubViewModel())
}
