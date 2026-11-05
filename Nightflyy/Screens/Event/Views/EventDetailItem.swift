//
//  EventDetailItem.swift
//  Nightflyy
//

import SwiftUI

/// A labeled detail on the event screen (type, time, venue, address...). Tapping the value runs `action`, if any.
struct EventDetailItem: View {

    let header: String
    let value: String
    var itemColor: Color = .white
    var underline = false
    var action: ButtonAction?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(header.uppercased())
                .foregroundStyle(.gray)
                .font(.system(size: 13))
            Text(value)
                .foregroundStyle(itemColor)
                .underline(underline)
                .onTapGesture {
                    action?()
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}
