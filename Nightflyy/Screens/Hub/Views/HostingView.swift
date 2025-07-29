//
//  HostingView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/28/25.
//

import SwiftUI

struct HostingView: View {
    
    var viewModel = HostingViewModel()
    
    var noEventsView: some View {
        VStack {
            Spacer()
            Text("You have no events that you're hosting")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 48)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var body: some View {
        
        
        ScrollView(.vertical, showsIndicators: false) {
            if viewModel.eventsHosting.isEmpty {
                noEventsView
            }
            else {
                
                GeometryReader { proxy in
                    VStack(alignment: .center, spacing: 12) {
                        EventImage(imageUrl: viewModel.headerEvent?.event.eventFlyerUrl, size: CGSize(width: proxy.size.width - 24, height: 400))
                            .frame(width: proxy.size.width)
                            .overlay(alignment: .bottom) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(viewModel.headerEvent?.event.eventName ?? "Untitled Event")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 32, weight: .bold))
                                        
                                        Spacer()
                                        
                                        Text(viewModel.headerEvent?.numberOFRSVPs ?? "")
                                            .foregroundStyle(.gray)
                                        Image("ic_crowd")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(.gray)
                                    }
                                    
                                    HStack {
                                        Text("\(viewModel.headerEvent?.weekday.uppercased() ?? ""), \(viewModel.headerEvent?.month ?? "")  \(viewModel.headerEvent?.day ?? "")")
                                            .font(.title3)
                                            .fontWeight(.medium)
                                        
                                        Spacer()
                                        
                                        Button {
                                            viewModel.goToGuestList()
                                        } label: {
                                            Text("VIEW GUEST LIST")
                                                .foregroundStyle(.mainPurple)
                                        }
                                        
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.backgroundBlackLight)
                                .cornerRadius(12,corners: [.bottomLeft, .bottomRight])
                                .padding(.horizontal, 12)
                            }
                            .onTapGesture {
                                viewModel.headerEvent?.navigateToEvent()
                            }
                        
                        
                        ForEach(viewModel.additionalEvents, id: \.self) { viewModel in
                            EventListItemView(viewModel: viewModel) {
                                viewModel.navigateToEvent()
                            }
                            .padding(.horizontal, 12)
                        }
                    }
                    
                }
            }
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
    HostingView()
        .preferredColorScheme(.dark)
    
    //    HubView(showMenu: .constant(false))
}
