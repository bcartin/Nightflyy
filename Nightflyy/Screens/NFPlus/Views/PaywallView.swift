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
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.gray)
                            .font(.title2.bold())
                            .offset(y: -12)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 48)
                        .fill(.backgroundBlack)
                        .frame(height: 160)
                        .shadow(color: .onlineBlue, radius: 24)
                        
                    VStack {
                        HStack {
                            Text("Upgrade to Nightflyy+")
                                .foregroundStyle(.white)
                                .font(.custom("NeuropolXRg-Regular", size: 18))
                                .padding()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(gradient: Gradient(colors: [.backgroundBlack, .backgroundBlack, .mainPurple]), startPoint: .leading, endPoint: .trailing)
                                )
                        )
                        .padding(.bottom, 4)
                        
                        Text("Better Vibes Start Here")
                            .foregroundStyle(.white)
                            .font(.system(size: 13, weight: .medium))
                            .padding(.bottom, 20)
                    }
                    
                }
                .offset(x: 0, y: 50)
                
                VStack {
                    
                    Spacer()
                        .frame(height: 40)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureView(title: "VIP Perks. Every Week.",
                                    subtitle: "Drink specials, food discounts, free entry & more.",
                                    iconName: "ic_perks")
                        
                        FeatureView(title: "Explore Your City.",
                                    subtitle: "Try new bars, clubs & restaurants",
                                    iconName: "ic_explore")
                        
                        FeatureView(title: "Find Your People.",
                                    subtitle: "A community that matches your vibe",
                                    iconName: "ic_crowds")
                        
                        FeatureView(title: "It Pays For Itself.",
                                    subtitle: "Value you feel the first time",
                                    iconName: "ic_value")
                    }
                    
                    HStack(spacing: 0) {
                        Text("14 days free trial.")
                            .foregroundStyle(.onlineBlue)
                        
                        Text("Then $12.00/month")
                            .foregroundStyle(.white)
                    }
                    .font(.system(size: 14, weight: .medium))
                    .padding(.top, 44)
                    .padding(.bottom)
                    
                    Button {
                        viewModel.checkForReferral()
                    } label: {
                        Text("Start Free Trial")
                            .padding()
                            .padding(.horizontal, 85)
                            .foregroundStyle(.white)
                            .background(.onlineBlue.gradient)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    Text("By tapping the button I agree to the Terms and automatic monthly charge of $12.00 until I cancel. Cancel in account prior to any renewal to avoid charges. Perks will vary depending on the venue. Cancel anytime.")
                        .foregroundStyle(.gray)
                        .font(.system(size: 10))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                    
                    Button {
                        viewModel.restoreSubscriptionOrSkip()
                    } label: {
                        Text(authenticationManager.isSigningUp ? "Skip" : "Restore Subscription")
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                            .padding(.bottom, 36)
                    }
                  
                }
                .frame(maxWidth: .infinity)
                .background(.backgroundBlack)
            }
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
//    PaywallView()
}

struct FeatureView: View {
    let title: String
    let subtitle: String
    let iconName: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(iconName)
                .resizable()
                .frame(width: 25, height: 25)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
                Text(subtitle)
                    .foregroundStyle(.gray)
                    .font(.system(size: 12))
            }
        }
    }
}


