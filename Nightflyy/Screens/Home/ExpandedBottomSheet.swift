//
//  ExpandedBottomSheet.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 10/17/24.
//

import SwiftUI

struct ExpandedBottomSheet: View { 
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    @State private var animateContent: Bool = false
    @State private var offsetY: CGFloat = 0
    
    
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                    .fill(.backgroundBlack)
                    .overlay(content: {
                        ZStack {
                            Image("paywall_background")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .opacity(animateContent ? 1 : 0)
                                .clipShape(RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0))
                            
                            VStack(spacing: 12) {
                                Spacer()
                                
                                Text("Free for 7 Days then $7.99/month")
                                
                                FeaturesView()
                                
                                Text("By tapping the button I agree to the Terms and automatic monthly charge of $7.99 until I cancel. Cancel in account prior to any renewal to avoid charges. Perks will vary depending on the venue. Cancel anytime.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                
                                Button {
                                    
                                } label: {
                                    Text("Join Now, First Round On Us")
                                }
                                .mainButtonStyle()

                                
                                Button {
                                    // RENEW SUBSCRItion action
                                } label: {
                                    Text("Renew Subscription")
                                        .foregroundStyle(.mainPurple)
                                        .font(.system(size: 17))
                                        .padding()
                                }
                            }
                            .padding(.bottom, 32)
                        }
                    })
                    .overlay(alignment: .top) {
                        UseYourPerk(expandSheet: $expandSheet, animation: animation) // is this necessary? try removing
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
                
                VStack(spacing: 15) {
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : size.height)
                }
                .padding(.top, 64)
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationY = value.translation.height
                        offsetY = (translationY > 0 ? translationY : 0)
                    }).onEnded({ value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if offsetY > size.height * 0.4 {
                                expandSheet = false
                                animateContent = false
                            }
                            else {
                                offsetY = .zero
                            }
                        }
                    })
            )
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
}

extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            
            return 0
        }
        
        return 0
    }
}


struct FeaturesView: View {
    
    var colors: [Color] = [.onlineBlue, .orange, .red, .green]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 25) {
                ForEach(colors, id: \.self) { color in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(color)
                        .frame(width: UIScreen.main.bounds.width
                               - 140, height: 80)
                }
            }
            .scrollTargetLayout()
        }
        .safeAreaPadding(.horizontal, 70)
        .padding(.vertical, 16)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
