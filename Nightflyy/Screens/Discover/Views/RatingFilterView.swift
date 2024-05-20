//
//  RatingFilterView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/16/25.
//

import SwiftUI

struct RatingFilterView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedRating: Int?
    @State var displayRating: Int = 0
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Venue Rating")
                .foregroundStyle(.white)
                .font(.system(size: 21, weight: .bold))
                .padding()
                .padding(.bottom, 18)
            
            HStack(spacing: 0) {
                Button {
                    displayRating = 1
                } label: {
                    Image(systemName: getImage(for: 1))
                        .foregroundStyle(.yellow)
                        .font(.system(size: 42))
                }
                
                Button {
                    displayRating = 2
                } label: {
                    Image(systemName: getImage(for: 2))
                        .foregroundStyle(.yellow)
                        .font(.system(size: 42))
                }
                
                Button {
                    displayRating = 3
                } label: {
                    Image(systemName: getImage(for: 3))
                        .foregroundStyle(.yellow)
                        .font(.system(size: 42))
                }
                
                Button {
                    displayRating = 4
                } label: {
                    Image(systemName: getImage(for: 4))
                        .foregroundStyle(.yellow)
                        .font(.system(size: 42))
                }
                
                Button {
                    displayRating = 5
                } label: {
                    Image(systemName: getImage(for: 5))
                        .foregroundStyle(.yellow)
                        .font(.system(size: 42))
                }

            }
            
            Text("\(Int(displayRating)) Stars")
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .bold))
            
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button("CANCEL") {
                    selectedRating = nil
                    dismiss()
                }
                .padding()
                
                Button("OK") {
                    selectedRating = Int(displayRating)
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
    
    func getImage(for value: Int) -> String {
        return value <= displayRating ? "star.fill" : "star"
    }
}

#Preview {
    RatingFilterView(selectedRating: .constant(nil))
}
