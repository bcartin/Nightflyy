//
//  SavableProtocoll.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import Foundation

protocol Savable {
    
    static var collection: String { get set }
    
    func save() throws
}
