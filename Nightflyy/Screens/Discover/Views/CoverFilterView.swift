//
//  CoverFilterView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/16/25.
//

import SwiftUI

struct CoverFilterView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedMaxCover: Int?
    @State var displayMaxCover: Float = 0
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Max Cover Charge")
                .foregroundStyle(.white)
                .font(.system(size: 21, weight: .bold))
                .padding()
                .padding(.bottom, 18)
            
            Text("$\(Int(displayMaxCover))")
                .foregroundStyle(.white)
                .font(.system(size: 72, weight: .bold))
            
            Slider(value: $displayMaxCover, in: 0...200)
                .padding(.horizontal, 32)
                .tint(.mainPurple)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button("CANCEL") {
                    selectedMaxCover = nil
                    dismiss()
                }
                .padding()
                
                Button("OK") {
                    selectedMaxCover = Int(displayMaxCover)
                    dismiss()
                }
                .padding()
            }
            .foregroundStyle(.white)
            .font(.system(size: 21, weight: .bold))
            .padding(.trailing, 36)
            .padding(.bottom, 18)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
    }
}

#Preview {
    CoverFilterView(selectedMaxCover: .constant(nil))
}
