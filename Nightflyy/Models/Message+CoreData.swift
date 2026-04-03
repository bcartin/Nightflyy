//
//  Message+CoreData.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/3/26.
//

import CoreData

extension Message {

    /// Creates a `Message` from a `CachedMessage` Core Data entity.
    static func from(_ cached: CachedMessage) -> Message? {
        guard let id = cached.id,
              let sender = cached.sender,
              let recipient = cached.recipient,
              let typeRaw = cached.messageType,
              let type = MessageType(rawValue: typeRaw) else {
            return nil
        }
        var message = Message(
            sender: sender,
            recipient: recipient,
            date: cached.date,
            type: type,
            messageData: MessageData(
                message: cached.message,
                event_name: cached.eventName,
                event_id: cached.eventId,
                event_flyer_url: cached.eventFlyerUrl,
                username: cached.username,
                uid: cached.uid,
                profile_image_url: cached.profileImageUrl
            )
        )
        message.id = id
        return message
    }

    /// Populates a `CachedMessage` entity with values from this struct.
    /// Note: `chatId` must be set separately by the caller.
    func populate(_ cached: CachedMessage) {
        cached.id = id
        cached.sender = sender
        cached.recipient = recipient
        cached.date = date
        cached.messageType = type.rawValue
        cached.message = messageData.message
        cached.eventName = messageData.event_name
        cached.eventId = messageData.event_id
        cached.eventFlyerUrl = messageData.event_flyer_url
        cached.username = messageData.username
        cached.uid = messageData.uid
        cached.profileImageUrl = messageData.profile_image_url
    }
}
