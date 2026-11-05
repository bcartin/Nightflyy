//
//  Lists.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation

enum VenuesType: String, CaseIterable {

    static var allValues: [String] {
        return allCases.map { $0.rawValue }
    }

    case bar = "Bar"
    case lounge = "Lounge"
    case brewery = "Brewery"
    case club = "Club"
    case stripClub = "Strip Club"
    case other = "Other"
    case liveMusic = "Live Music"

}

enum MusicGenre: String, CaseIterable {

    static var allValues: [String] {
        return allCases.map { $0.rawValue }
    }

    case top40 = "Top 40"
    case hipHop = "Hip-Hop"
    case RNB = "R&B"
    case EDM = "EDM"
    case rock = "Rock"
    case metal = "Metal"
    case latin = "Latin"
    case liveMusic = "Live Music"
    case reggaeton = "Reggaeton"
    case afrobeats = "Afrobeats"
    case reggae = "Reggae"
    case dancehall = "Dancehall"
    case soca = "Soca"
    case jazz = "Jazz"
    case blues = "Blues"
    case funkSoul = "Funk/Soul"
    case country = "Country"
    case classical = "Classical"
    case amapiano = "Amapiano"
    case house = "House"
    case kompa = "Kompa"
    case dembow = "Dembow"
    case throwbacks = "Throwbacks"
    case disco = "Disco"
    case bollywood = "Bollywood"
}

enum ClienteleType: String, CaseIterable {

    static var allValues: [String] {
        return allCases.map { $0.rawValue }
    }

    case youngProfessional = "Young Professional"
    case college = "College"
    case urban = "Urban"
    case upscale = "Upscale"
    case mature = "Mature"
    case hipster = "Hipster"
    case queerLGBTQ = "Queer/LGBTQ"

}
