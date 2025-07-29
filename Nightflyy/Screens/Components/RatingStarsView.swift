//
//  RatingStarsView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/22/25.
//

import SwiftUI

struct RatingStarsView: View {
    
    var rating: Float
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1..<6, id: \.self) { number in
                Image(systemName: image(for: number))
                    .foregroundStyle(.yellow.gradient)
            }
        }
    }
    
    func image(for number: Int) -> String {
        let dNumber = Float(number)
        return dNumber > rating ? dNumber - 1 >= rating ? "star" : "star.leadinghalf.filled" : "star.fill"
    }
    
    
}

#Preview {
    RatingStarsView(rating: 3.1)
}
