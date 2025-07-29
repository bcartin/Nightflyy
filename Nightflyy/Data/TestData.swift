//
//  TestData.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/24.
//

import Foundation

class TestData {
    
    static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
        return formatter
    }()
    
    static var events: [Event] = [
        Event(id: "1",
              createdBy: "034y9d1YbbhaVIupxbJZ3CJxanO2",
              endDate: formatter.date(from: "2025-12-23T18:25:43+01:00"),
              eventFlyerUrl: "https://d1csarkz8obe9u.cloudfront.net/themedlandingpages/tlp_hero_event-flyer-272b07826d110a9fbf155e44c09cd95b.png",
              eventName: "Test Event",
              eventVenue: "Pulse",
              eventVenueType: "Bar",
              startDate: formatter.date(from: "2025-12-23T18:25:43+01:00")),
        
        Event(id: "1",
              createdBy: "034y9d1YbbhaVIupxbJZ3CJxanO2",
              endDate: formatter.date(from: "2025-12-24T18:25:43+01:00"),
              eventFlyerUrl: "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/main-event-flyer-design-template-c2595c7e6f40fff8b98eba6486b62329_screen.jpg",
              eventName: "Test Event 2",
              eventVenue: "Pulse",
              eventVenueType: "Bar",
              startDate: formatter.date(from: "2025-12-24T18:25:43+01:00"))
    ]

    
    static var account: Account = Account(id: "1",
                                          bio: "This is a test bio that should be a few lines long so that it can be properly tested.",
                                          name: "Test Account",
                                          profileImageUrl: "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
                                          username: "Username")
    
    static var chat: Chat = Chat(id: "1",
                                 lastMessage: "Yay!!!",
                                 lastUpdated: Date(),
                                 isNew: true,
                                 lastMessageSender: "zEk78U4a9YcW05JPWpkZ5QjI3pc2",
                                 members: ["zEk78U4a9YcW05JPWpkZ5QjI3pc2",
                                           "PIaezqBAzrRRO41MbfJjZeTviGo1"])
}
