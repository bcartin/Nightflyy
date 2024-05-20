//
//  UserImageSmall.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import SwiftUI

struct UserImageSmall: View {
    
    var account: Account?
    var size: CGFloat
    
    var body: some View {
        if let url = account?.profileImageUrl {
            AsyncImage(url: URL(string: url)) { image in
                image.image?.resizable()
            }
            .frame(width: size, height: size)
            .padding(.leading)
        }
        else {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: size, height: size)
                .padding(.leading)
        }
    }
}
