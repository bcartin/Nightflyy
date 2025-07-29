//
//  TagView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

//import SwiftUI
//
//struct TagView: View {
//    
//    var tag: String
//    var color: Color
//    var icon: String
//    @State var isSelected: Bool
//    
//    var body: some View {
//        HStack(spacing: 10) {
//            Text(tag)
//                .font(.callout)
//                .fontWeight(.semibold)
//            
//            Image(systemName: icon)
//        }
//        .frame(height: 35)
//        .foregroundStyle(.white)
//        .padding(.horizontal, 15)
//        .background{
//            Capsule()
//                .fill(isSelected ? color.gradient : Color.red.gradient)
//        }
//        
//    }
//}
//
//#Preview {
//    TagView(tag: "Reggae", color: .mainPurple, icon: "music.note", isSelected: false)
//}
