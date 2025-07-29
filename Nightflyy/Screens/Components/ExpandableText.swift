//
//  ExpandableText.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/15/24.
//

import SwiftUI

struct ExpandableText: View {
    
    var label: String? = nil
    var text: String
    @State var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let label {
                Text(label.uppercased())
                    .foregroundStyle(.gray)
                    .font(.system(size: 13))
            }
            
            Text(text)
                .lineLimit($isExpanded.wrappedValue ? nil : 4)
                .overlay {
                    GeometryReader { proxy in
                        if proxy.size.height > 86 && !isExpanded {
                            Rectangle()
                                .fill(
                                    LinearGradient(colors: [.clear, .clear, .backgroundBlack], startPoint: .top, endPoint: .bottom)
                                    
                                )
                        }
                    }
                }
                .onTapGesture {
                    withAnimation {
                        $isExpanded.wrappedValue.toggle()
                    }
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

#Preview {
    ExpandableText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", isExpanded: false)
        .preferredColorScheme(.dark)
}
