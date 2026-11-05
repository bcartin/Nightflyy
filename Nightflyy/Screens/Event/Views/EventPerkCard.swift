//
//  EventPerkCard.swift
//  Nightflyy
//

import SwiftUI

/// Tappable Nightflyy+ perk summary shown on events that offer one.
struct EventPerkCard: View {

    let name: String
    let details: String
    let action: ButtonAction

    var body: some View {
        Button(action: action) {
            HStack {
                Image("plus_badge")
                    .resizable()
                    .frame(width: 30, height: 30)

                VStack(alignment: .leading) {
                    Text("Nightflyy+ Perk")
                        .font(.system(size: 12))
                        .foregroundStyle(.onlineBlue)

                    Text(name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)

                    Text(details)
                        .font(.system(size: 10))
                        .foregroundStyle(.white)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.onlineBlue)
            }
            .padding(8)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.onlineBlue, lineWidth: 1)
            }
            .padding(12)
        }
    }
}
