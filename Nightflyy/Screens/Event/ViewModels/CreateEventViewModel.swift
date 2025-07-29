//
//  CreateEventViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/24/25.
//

import Foundation
import SwiftUI

@Observable
class CreateEventViewModel: NSObject {
    
    var flyerImage: Image?
    var isLoading: Bool = false
    var event: Event
    var goToScreen: Bool = false
    var selectedGoToScreen: NavigateTo?
    var isShowingOptions: Bool = false
    var error: Error?
    var uiImage: UIImage?
    
    init(event: Event) {
        self.event = event
    }
    
    var eventName: String {
        get { event.eventName ?? "" }
        set { event.eventName = newValue }
    }
    
    var eventDetails: String {
        get { event.eventDetails ?? "" }
        set { event.eventDetails = newValue }
    }
    
    var eventVenue: String {
        get { event.eventVenue ?? "" }
        set { event.eventVenue = newValue }
    }
    
    var eventAddress: String {
        get { event.eventAddress ?? "" }
        set { event.eventAddress = newValue }
    }
    
    var startDate: Date {
        get { event.startDate ?? Date() }
        set { event.startDate = newValue}
    }
    
    var endDate: Date {
        get { event.endDate ?? Date() }
        set { event.endDate = newValue }
    }
    
    var guestsCanInvite: Bool {
        get { event.guestsCanInvite ?? false }
        set { event.guestsCanInvite = newValue }
    }
    
    var eventIsPrivate: Bool {
        get { event.eventIsPrivate ?? false }
        set { event.eventIsPrivate = newValue }
    }
    
    var venueType: String {
        get { event.eventVenueType ?? "" }
        set { event.eventVenueType = newValue }
    }
    
    var eventMusic: [String] {
        get { event.eventMusic ?? [] }
        set { event.eventMusic = newValue }
    }
    
    var eventMusicString: String {
        get { eventMusic.joined(separator: ", ") }
        set {  }
    }
    
    var eventCrowds: [String] {
        get { event.eventCrowds ?? [] }
        set { event.eventCrowds = newValue }
    }
    
    var eventCrowdsString: String {
        get { eventCrowds.joined(separator: ", ") }
        set {  }
    }
    
    var minPrice: String {
        get { String(event.minPrice ?? 0) }
        set { event.minPrice = Int(newValue) }
    }
    
    var maxPrice: String {
        get { String(event.maxPrice ?? 0) }
        set { event.maxPrice = Int(newValue) }
    }
    
    var eventIsFree: Bool {
        get { event.eventIsFree ?? false }
        set {
            event.eventIsFree = newValue
            event.minPrice = 0
            event.maxPrice = 0
        }
    }
    
    var ticketingUrl: String {
        get { event.ticketingUrl ?? "" }
        set { event.ticketingUrl = newValue }
    }
    
    var selectedVenue: Account? {
        didSet {
            eventAddress = selectedVenue?.address ?? ""
            venueType = selectedVenue?.venueType ?? ""
            eventMusic = selectedVenue?.music ?? []
            eventCrowds = selectedVenue?.clientele ?? []
            event.eventVenueId = selectedVenue?.id
        }
    }
    
    //MARK: FUNCTIONS
    
    func setEventIsFree() {
        self.eventIsFree.toggle()
        self.minPrice = eventIsFree ? "0" : ""
        self.maxPrice = eventIsFree ? "0" : ""
    }
    
    func isValid() -> Bool {
        if event.eventName == nil || event.eventName!.isEmpty {
            error = EventError.missingRequiredFields
            return false
        }
        if event.eventDetails == nil || event.eventDetails!.isEmpty {
            error = EventError.missingRequiredFields
            return false
        }
        if event.eventVenue == nil || event.eventVenue!.isEmpty {
            error = EventError.missingRequiredFields
            return false
        }
        return true
    }
    
    func saveEvent() {
        guard isValid() else { return }
        Task {
            self.isLoading = true
            do {
                await updateEventImage()
                await setAdditionalEventVaues()
                try event.save()
                event.updateCache()
                EventsManager.shared.updateEventLists(with: event)
                updateSearchIndex()
                try? await Task.sleep(for: .seconds(2))
                isLoading = false
                General.showSavedMessage()
            }
            catch {
                self.error = error
            }
        }
    }
    
    func setAdditionalEventVaues() async {
        event.createdBy = AccountManager.shared.account?.uid ?? ""
        if let location = await MapsManager.getLocation(from: event.eventAddress ?? "") {
            event.latitude = location.coordinate.latitude
            event.longitude = location.coordinate.longitude
            //TODO: Set event status
        }
    }
    
    func setImage(data: Data) {
        if let image = UIImage(data: data) {
            self.uiImage = image
            self.flyerImage = Image(uiImage: image)
        }
    }
    
    func updateEventImage() async {
        if let image = uiImage {
            do {
                let storageManager = StorageManager()
                if let oldImageUrl = event.eventFlyerUrl {
                    try await storageManager.deletePhoto(url: oldImageUrl)
                }
                let imageUrl = try await storageManager.saveEventPhoto(photo: image)
                event.eventFlyerUrl = imageUrl
            }
            catch {
                self.error = error
            }
        }
    }
    
    func updateSearchIndex() {
        try? SearchManager.shared.updateSearchIndex(objectID: event.uid, objectType: .event, name: event.eventName, username: nil, venue: event.eventVenue)
    }
}

extension CreateEventViewModel {
    
    enum NavigateTo {
        case details
        case venue
        case address
        case venueType
        case eventMusic
        case eventCrowds
    }
    
    func goToScreen(_ navigateTo: NavigateTo) {
        goToScreen = true
        selectedGoToScreen = navigateTo
    }
}
