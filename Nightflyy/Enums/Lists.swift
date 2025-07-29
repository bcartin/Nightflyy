//
//  Constants.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation

enum VenuesType: String, CaseIterable {
    
    static var allValues: [String] {
        return allCases.map { $0.rawValue.capitalized }
    }
    
    case Bar
    case Lounge
    case Brewery
    case Club
    case StripClub = "Strip Club"
    case Other
    
}

enum MusicGenre: String, CaseIterable {
    
    static var allValues: [String] {
        return allCases.map { $0.rawValue.capitalized }
    }
    
    case Top40 = "Top 40"
    case HipHop = "Hip-Hop"
    case RNB = "R&B"
    case EDM = "EDM"
    case Rock
    case Metal
    case Latin
    case LiveMusic = "Live Music"
    case Reggaeton
    case Afrobeats
    case Reggae
    case Dancehall
    case Soca
    case Jazz
    case Blues
    case FunkSoul = "Funk/Soul"
    case Country
    case Classical
    case Amapiano
    case House
}

enum ClienteleType: String, CaseIterable {
    
    static var allValues: [String] {
        return allCases.map { $0.rawValue.capitalized }
    }
    
    case YoungProfessional = "Young Professional"
    case College
    case Urban
    case Upscale
    case Mature
    case Hipster
    case QueerLGBTQ =  "Queer/LGBTQ"
    
}
