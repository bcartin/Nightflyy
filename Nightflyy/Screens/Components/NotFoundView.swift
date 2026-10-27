//
//  NotFoundView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 9/21/26.
//

import SwiftUI

/// A generic view displayed when the content the user is looking for could not be found.
struct NotFoundView: View {

    /// The type of content that could not be found, used to tailor the icon and messaging.
    enum ContentType {
        case event
        case profile
        case venue
        case chat
        case notification
        case generic

        var icon: String {
            switch self {
            case .event: "calendar.badge.exclamationmark"
            case .profile: "person.crop.circle.badge.questionmark"
            case .venue: "mappin.slash"
            case .chat: "bubble.left.and.exclamationmark.bubble.right"
            case .notification: "bell.slash"
            case .generic: "magnifyingglass"
            }
        }

        var title: String {
            switch self {
            case .event: "Event Not Found"
            case .profile: "Profile Not Found"
            case .venue: "Venue Not Found"
            case .chat: "Chat Not Found"
            case .notification: "Notification Not Found"
            case .generic: "Content Not Found"
            }
        }

        var message: String {
            switch self {
            case .event: "This event may have ended, been removed, or is no longer available."
            case .profile: "This profile may have been deactivated or no longer exists."
            case .venue: "This venue may have been removed or is no longer available."
            case .chat: "This conversation may have been deleted or is no longer available."
            case .notification: "This notification refers to content that is no longer available."
            case .generic: "The content you're looking for may have been removed or is no longer available."
            }
        }
    }

    var contentType: ContentType = .generic

    /// An optional custom message that overrides the content type's default message.
    var message: String?

    /// An optional action to perform when the user taps the button, such as dismissing the screen.
    var action: (() -> Void)?
    var actionTitle: String = "Go Back"

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: contentType.icon)
                .font(.system(size: 56))
                .foregroundStyle(LinearGradient(colors: [.mainPurple, .onlineBlue], startPoint: .topLeading, endPoint: .bottomTrailing))

            Text(contentType.title)
                .font(.title2)
                .bold()
                .foregroundStyle(.white)

            Text(message ?? contentType.message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if let action {
                Button(actionTitle, action: action)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(.mainPurple)
                    .clipShape(.capsule)
                    .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundBlack)
    }
}

#Preview("Event") {
    NotFoundView(contentType: .event, action: {})
}

#Preview("Profile") {
    NotFoundView(contentType: .profile)
}

#Preview("Generic") {
    NotFoundView()
}
