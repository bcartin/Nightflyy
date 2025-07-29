//
//  SearchResult.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/7/25.
//

import Foundation

struct SearchResult: Identifiable {
    
    let type: SearchObjectType
    let account: Account?
    let event: Event?
    let id: String
    
}
