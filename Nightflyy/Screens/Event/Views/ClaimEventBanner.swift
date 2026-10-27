//
//  ClaimEventBanner.swift
//  Nightflyy
//

import SwiftUI

/// Banner shown to a venue that has been assigned an unclaimed event, with Accept and Decline buttons.
struct ClaimEventBanner: View {

    let onAccept: ButtonAction
    let onDecline: ButtonAction

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.mainPurple)
                .frame(height: 100)

            VStack {
                Text("You have been invited to claim this event")
                    .foregroundStyle(.white)

                HStack(spacing: 12) {
                    Button("Accept", action: onAccept)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .foregroundStyle(.mainPurple)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Button("Decline", action: onDecline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .foregroundStyle(.mainPurple)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}
