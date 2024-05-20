//
//  EventCardView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 10/10/24.
//

import SwiftUI

struct EventCardView: View {
    
    var imageName: String
    var size: CGSize
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)
                
                Text("Username")
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                
                Spacer()
            }
            .padding(.bottom, 8)
            
            ZStack(alignment: .top) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - 110, height: (size.width - 110) * 1.375)
                    .clipShape(.rect(cornerRadius: 12))
                    .padding(.bottom)
                
                HStack() {
                    Spacer()
                    
                    VStack(alignment: .trailing ,spacing: 12) {
                        
                        Text("TUE, DEC 31")
                            .foregroundStyle(.white)
                            .padding(6)
                            .background(.mainPurple)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.trailing, 18)
                            .padding(.top, 4)
                        
                        Spacer()
                            .frame(height: (size.width - 255) * 1.375)
                        
                        Button {
                            
                        } label: {
                            Image("ic_interested")
                                .resizable()
                                .padding(8)
                                .frame(width: 42, height: 42)
                                .foregroundStyle(.gray)
                                .overlay {
                                    Circle()
                                        .stroke(.gray, lineWidth: 1)
                                }
                        }
                        
                        Button {
                            
                        } label: {
                            Image("ic_share")
                                .resizable()
                                .padding(8)
                                .frame(width: 42, height: 42)
                                .foregroundStyle(.gray)
                                .overlay {
                                    Circle()
                                        .stroke(.gray, lineWidth: 1)
                                }
                        }
                        
                        Button {
                            
                        } label: {
                            Image("ic_crowd")
                                .resizable()
                                .padding(8)
                                .frame(width: 42, height: 42)
                                .foregroundStyle(.gray)
                                .overlay {
                                    Circle()
                                        .stroke(.gray, lineWidth: 1)
                                }
                        }
                        
                    }
                    .frame(minHeight: .zero)
                }
            }
            
            Text("Event Name")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 4)
            
            HStack {
                Image("ic_pin")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(.mainPurple)
                
                Text("New York, NY")
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
            }
            
        }
        .frame(width: size.width - 86)
        .background(.backgroundBlack)
    }
}

#Preview {
    EventCardView(imageName: "event1", size: CGSize(width: UIScreen.main.bounds.size.width, height: 392))
}
