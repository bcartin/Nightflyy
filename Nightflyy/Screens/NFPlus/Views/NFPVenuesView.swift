//
//  NFPVenuesView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 8/13/25.
//

import SwiftUI

struct NFPVenuesView: View {
    
    @Binding var viewModel: NFPRedeemViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Nightflyy+ Venues")
                .font(.system(size: 18, weight: .bold))
                .padding(.top, 24)
                .multilineTextAlignment(.center)
                .padding(24)
            
            ScrollView(.vertical) {
                ForEach(viewModel.nfpVenues) { account in

                    VenueListItemView(viewModel: VenueListItemViewModel(venue: account)) {  }
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
    }
}

#Preview {
    NFPVenuesView(viewModel: .constant(NFPRedeemViewModel()))
}
