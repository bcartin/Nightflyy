//
//  AccountEnums.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/16/25.
//

//FOLLOWING STATUS
enum FollowingStatus {
    
    case following
    case notFollowing
    case requested
    
}

//ACCOUNT TYPE
enum AccountType: String, CaseIterable, Codable {
    
    case personal = "personal"
    case venue = "venue"
}

// GENDER
enum Gender: String, CaseIterable {
    
    case male = "Male"
    case female = "Female"
    case nonBinary = "Non-binary"
    case undefined = "Undefined"
    
    init?(x: Int?) {
        guard let x = x else { return nil }
        if !Gender.allCases.indices.contains(x) {
            return nil
        }
        self = Gender.allCases[x]
    }
    
    var intValue: Int {
        return Gender.allCases.firstIndex(of: self)!
    }
}
