//
//  PillListView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/22/25.
//

import SwiftUI

struct PillListView: View {
    
    var header: String
    var items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(header.uppercased())
                .foregroundStyle(.gray)
                .font(.system(size: 13))
                .padding(.bottom, 6)
            
            TagLayout(alignment: .leading, spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.callout)
                        .frame(height: 35)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 15)
                        .background{
                            Capsule()
                                .fill(.backgroundBlack)
                                .stroke(.mainPurple, lineWidth: 1)
                        }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

#Preview {
    PillListView(header: "", items: [])
}
