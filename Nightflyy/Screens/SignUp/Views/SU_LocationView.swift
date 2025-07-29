//
//  SU_LocationView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/22/25.
//

import SwiftUI

struct SU_LocationView: View {
    
    @Binding var viewModel: SignupViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Find Nearby Parties")
                .font(.system(size: 24, weight: .bold))
            
            Text("We use your location to help you find events and venues in your area.")
                .multilineTextAlignment(.center)
                .font(.system(size: 14, weight: .bold))
            
            Spacer()
            
            Image("location_permission")
                .resizable()
                .frame(width: 240, height: 240)
                .aspectRatio(contentMode: .fit)
            
            Spacer()
            
            Button("Continue") {
                LocationManager.shared.askPermission()
                viewModel.goToScreen(.paywall)
            }
            .mainButtonStyle()
            
            Button("Skip") {
                viewModel.goToScreen(.paywall)
            }
            .foregroundStyle(.mainPurple)
        }
        .ignoresSafeArea()
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SU_LocationView(viewModel: .constant(SignupViewModel()))
}
