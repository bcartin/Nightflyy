//
//  PaywallView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 10/25/24.
//

import SwiftUI

struct PaywallView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(AuthenticationManager.self) private var authenticationManager
    @Binding var viewModel: NFPSignUpViewModel
    
    var body: some View {
        ZStack {
            
            Image("paywall_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            VStack() {
                RoundedRectangle(cornerRadius: 3)
                    .fill(.gray.opacity(0.9))
                    .frame(width: 86, height: 6)
                    .safeAreaPadding(.top, 64)
                
                Spacer()
                
                HStack {
                    Text("Upgrade to Nightflyy+")
                        .foregroundStyle(.white)
                        .font(.custom("NeuropolXRg-Regular", size: 17))
                        .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [.backgroundBlack, .backgroundBlack, .mainPurple]), startPoint: .leading, endPoint: .trailing)
                        )
                )
                .padding(.bottom, 4)
                
                Text("Join for the perks, stay for the vibes!")
                    .foregroundStyle(.gray)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.bottom, 20)
                
                Text("Limited Time Offer")
                    .foregroundStyle(.onlineBlue)
                    .font(.system(size: 12, weight: .medium))
                
                Text("Free for 7 Days then $7.99/month")
                    .foregroundStyle(.gray)
                    .font(.system(size: 18, weight: .medium))
                
                FeaturesView()
                
                Text("By tapping the button I agree to the Terms and automatic monthly charge of $7.99 until I cancel. Cancel in account prior to any renewal to avoid charges. Perks will vary depending on the venue. Cancel anytime.")
                    .foregroundStyle(.gray)
                    .font(.system(size: 10))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                
                Button {
                    viewModel.checkForReferral()
                } label: {
                    Text("Join Now, First Round On Us")
                }
                .mainButtonStyle()
                
                
                Button {
                    viewModel.restoreSubscriptionOrSkip()
                } label: {
                    Text(authenticationManager.isSigningUp ? "Skip" : "Renew Subscription")
                        .foregroundStyle(.mainPurple)
                        .font(.system(size: 17))
                        .padding()
                }
            }
            .padding(.bottom, 32)
        }
        .ignoresSafeArea(.container, edges: .all)
        .gesture(
            DragGesture()
                .onChanged({ value in
                }).onEnded({ value in
                    if value.location.y - value.startLocation.y > 150 {
                        dismiss()
                    }
                })
        )
    }
}

#Preview {
    PaywallView(viewModel: .constant(NFPSignUpViewModel()))
}


struct FeaturesView: View {
    
    struct Feature: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let color: Color
    }
    
    var features: [Feature] = [
        Feature(title: "Exclusive Perks", subtitle: "Enjoy exclusive perks at your favorite spots weekly", color: .onlineBlue),
        Feature(title: "Explore", subtitle: "Discover new bars, clubs, breweries, and more in your area.", color: .orange),
        Feature(title: "VIP Experience", subtitle: "Unlock the VIP Nightflyy experience.", color: .red),
        Feature(title: "Amazing Value", subtitle: "Redeem just 1 perk to get your money's worth!", color: .green)
    ]
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        - 140
        
        ScrollView(.horizontal) {
            HStack(spacing: 25) {
                ForEach(features) { feature in
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(feature.title)
                                .foregroundStyle(.gray)
                                .font(.system(size: 17, weight: .medium))
                            
                            Text(feature.subtitle)
                                .foregroundStyle(.gray)
                                .font(.system(size: 12))
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    .frame(width: width, height: 80)
                    .background {
                        ZStack(alignment: .trailing) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(feature.color)
                                .frame(width: width, height: 80)
                            
                            Rectangle()
                                .fill(.backgroundBlack)
                                .frame(width: width - 10, height: 80)
                        }
                    }
                }
            }
            .scrollTargetLayout()
        }
        .safeAreaPadding(.horizontal, 70)
        .padding(.top, 8)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        
    }
}
