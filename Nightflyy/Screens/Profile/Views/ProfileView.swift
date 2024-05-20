//
//  ProfileView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/8/24.
//

import SwiftUI

struct ProfileView: View {
    
    let account: Account = TestData.account
    var safeArea: EdgeInsets
    var size: CGSize
    
    var body: some View {
            ScrollView(.vertical) {
                VStack {
                    ProfileImage()
                    
                    HStack(alignment: .top, spacing: 16) {
                        Text(account.name ?? "")
                        
                        Spacer()
                        
                        VStack(alignment: .center) {
                            Text("Followers")
                            Text("694")
                        }
                        
                        VStack(alignment: .center) {
                            Text("Following")
                            Text("210")
                        }
                    }
                    .foregroundStyle(.white)
                    .font(.system(size: 18))
                    .padding(.horizontal, 15)
                    
                    Text(account.bio ?? "")
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.vertical, 12)
                    
                    Divider()
                        .background(.white)
                    
                    HStack {
                        
                        IconButton(iconName: "ic_follow", title: "Follow") {
                            // FOLLOW ACTION
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        IconButton(iconName: "ic_message", title: "Message") {
                            // FOLLOW ACTION
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        IconButton(iconName: "ic_invite", title: "Invite") {
                            // FOLLOW ACTION
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                    
                    Divider()
                        .background(.white)
                    
                    EventListView(header: "Upcoming Events", events: [])
                    EventListView(header: "Events Attending", events: [TestData.event])
                    EventListView(header: "Past Events", events: [])
                }
                .overlay(alignment: .top) {
                    HeaderView()
                }
            }
            .scrollIndicators(.hidden)
            .coordinateSpace(name: "SCROLL")
    }
    
    @ViewBuilder
    func ProfileImage() -> some View {
        let height = size.height * 0.45
        GeometryReader{ proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            AsyncImage(url: URL(string: account.profileImageUrl ?? "")) { image in
                image.image?.resizable()
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
            .clipped()
            .overlay(content: {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(
                            .linearGradient(colors: [
                                .black.opacity(0 - progress),
                                .black.opacity(0.1 - progress),
                                .black.opacity(0.2 - progress),
                                .black.opacity(0.3 - progress),
                                .black.opacity(0.4 - progress),
                                .black.opacity(0.6 - progress),
                                .black.opacity(0.8 - progress),
                                .black.opacity(1)
                            ], startPoint: .top, endPoint: .bottom)
                        )
                    
                    HStack {
                        Text(account.username ?? "")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Image("plus_badge_user")
                            .resizable()
                            .frame(width: 24, height: 25)
                        
                        Spacer()
                    }
                    .opacity(1 + (progress > 0 ? -progress : progress))
                    .padding([.horizontal, .bottom], 15)
                    .offset(y: minY < 0 ? minY : 0)
                }
            })
            .offset(y: -minY)
        }
        .frame(height: height + safeArea.top)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let height = size.height * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProress = minY / height
            
            HStack(spacing: 10) {
                Button {
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image("ic_dotmenu")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .tint(.white)
                }


            }
            .overlay(content: {
                Text(account.username ?? "")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .offset(y: -titleProress > 0.75 ? 0 : 45)
                    .clipped()
                    .animation(.easeInOut(duration: 0.25), value: -titleProress > 0.75)
            })
            .padding(.top, safeArea.top + 10)
            .padding([.horizontal, .bottom], 15)
            .background(
                .black
                    .opacity(-progress > 1 ? 1 : 0)
            )
            .offset(y: -minY)
        }
        .frame(height: 35)
    }
    
    @ViewBuilder
    func EventListView(header: String, events: [Event]) -> some View {
        
        VStack(alignment: .leading) {
            Text(header.uppercased())
                .foregroundStyle(.white)
                .fontWeight(.medium)
            
            if events.isEmpty {
                Text("No Events")
                    .foregroundStyle(.gray)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            else {
                ForEach(events) { event in
                    EventListItemView(event: event)
                }
            }
            
        }
        .padding(.top, 8)
        .padding(.horizontal, 12)
        
    }
}

#Preview {
    ProfileContainer()
        .preferredColorScheme(.dark)
}
