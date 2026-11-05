//
//  StoredNamesTests.swift
//  NightflyyTests
//

import Foundation
import Testing
@testable import Nightflyy

/// These types are read and written by Firestore, Remote Config and Sendgrid.
/// Swift names can change freely; the stored keys and values checked here must not,
/// or existing data and server code stop matching.
struct StoredNamesTests {

    // MARK: - Firestore models

    @Test func notificationDataReadsAndWritesSnakeCaseKeys() throws {
        let stored = """
        {"event_flyer_url": "flyer", "event_id": "event", "event_name": "name", "event_status": "status",
         "start_reminder": "reminder", "created_by": "creator", "profile_image_url": "image",
         "username": "user", "rating": "5", "topic_id": "topic", "topic_name": "topic name"}
        """
        let data = try JSONDecoder().decode(NotificationData.self, from: Data(stored.utf8))

        #expect(data.eventFlyerUrl == "flyer")
        #expect(data.eventId == "event")
        #expect(data.eventName == "name")
        #expect(data.eventStatus == "status")
        #expect(data.startReminder == "reminder")
        #expect(data.createdBy == "creator")
        #expect(data.profileImageUrl == "image")
        #expect(data.username == "user")
        #expect(data.rating == "5")
        #expect(data.topicId == "topic")
        #expect(data.topicName == "topic name")

        #expect(try encodedKeys(data) == [
            "event_flyer_url", "event_id", "event_name", "event_status", "start_reminder", "created_by",
            "profile_image_url", "username", "rating", "topic_id", "topic_name"
        ])
    }

    @Test func messageDataReadsAndWritesSnakeCaseKeys() throws {
        let stored = """
        {"message": "hi", "event_name": "name", "event_id": "event", "event_flyer_url": "flyer",
         "username": "user", "uid": "uid", "profile_image_url": "image"}
        """
        let data = try JSONDecoder().decode(MessageData.self, from: Data(stored.utf8))

        #expect(data.message == "hi")
        #expect(data.eventName == "name")
        #expect(data.eventId == "event")
        #expect(data.eventFlyerUrl == "flyer")
        #expect(data.username == "user")
        #expect(data.uid == "uid")
        #expect(data.profileImageUrl == "image")

        #expect(try encodedKeys(data) == [
            "message", "event_name", "event_id", "event_flyer_url", "username", "uid", "profile_image_url"
        ])
    }

    @Test func notificationTypesKeepStoredValues() {
        let expected: [(AppNotificationType, String)] = [
            (.followRequest, "follow_request"),
            (.followAccepted, "follow_accepted"),
            (.followStart, "follow_start"),
            (.eventAssigned, "event_assigned"),
            (.inviteToEvent, "invite_to_event"),
            (.eventGoing, "event_going"),
            (.eventComment, "event_comment"),
            (.reviewSubmitted, "review_submitted"),
            (.eventCreated, "event_created"),
            (.eventAlert, "event_alert"),
            (.eventInterested, "event_interested")
        ]
        for (type, value) in expected {
            #expect(type.rawValue == value)
            #expect(AppNotificationType(rawValue: value) == type)
        }
    }

    @Test func accountAndMessageTypesKeepStoredValues() {
        #expect(AccountType.personal.rawValue == "personal")
        #expect(AccountType.venue.rawValue == "venue")
        #expect(MessageType.text.rawValue == "text")
        #expect(MessageType.event.rawValue == "event")
        #expect(MessageType.account.rawValue == "account")
    }

    @Test func firestoreFieldNamesAreUnchanged() {
        #expect(FirestoreCollections.Accounts.plusMember == "plus_member")
        #expect(FirestoreCollections.Events.assignedTo == "assigned_to")
    }

    // MARK: - Lists stored on accounts and events

    @Test func venueTypesKeepStoredValues() {
        #expect(VenuesType.allValues == ["Bar", "Lounge", "Brewery", "Club", "Strip Club", "Other", "Live Music"])
    }

    @Test func musicGenresKeepStoredValues() {
        #expect(MusicGenre.allValues == [
            "Top 40", "Hip-Hop", "R&B", "EDM", "Rock", "Metal", "Latin", "Live Music", "Reggaeton", "Afrobeats",
            "Reggae", "Dancehall", "Soca", "Jazz", "Blues", "Funk/Soul", "Country", "Classical", "Amapiano",
            "House", "Kompa", "Dembow", "Throwbacks", "Disco", "Bollywood"
        ])
    }

    @Test func clienteleTypesKeepStoredValues() {
        #expect(ClienteleType.allValues == [
            "Young Professional", "College", "Urban", "Upscale", "Mature", "Hipster", "Queer/LGBTQ"
        ])
    }

    // MARK: - Remote Config

    @Test func remoteConfigKeysAreUnchanged() {
        #expect(RemoteConfigParameter.forceUpdate.rawValue == "force_update")
        #expect(RemoteConfigParameter.latestAppVersion.rawValue == "latest_app_version")
    }

    // MARK: - Sendgrid API

    @Test func sendgridRequestUsesApiKeys() throws {
        let contact = Contact(email: "a@b.c",
                              externalId: "uid",
                              firstName: "Name",
                              customFields: CustomFields(username: "user", dob: "01/02/2000"))
        let body = ContactRequestBody(listIds: ["list"], contacts: [contact])

        #expect(try encodedKeys(body) == ["list_ids", "contacts"])
        #expect(try encodedKeys(contact) == ["email", "external_id", "first_name", "custom_fields"])
    }

    @Test func sendgridResponseReadsJobId() throws {
        let response = try JSONDecoder().decode(ContactResponse.self, from: Data(#"{"job_id": "job"}"#.utf8))
        #expect(response.jobId == "job")
    }

    // MARK: - Helpers

    /// Top-level keys of `value` once encoded, as Firestore and Sendgrid would see them.
    private func encodedKeys<T: Encodable>(_ value: T) throws -> Set<String> {
        let json = try JSONSerialization.jsonObject(with: JSONEncoder().encode(value))
        let object = try #require(json as? [String: Any])
        return Set(object.keys)
    }
}
