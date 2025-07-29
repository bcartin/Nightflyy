//
//  SliderPageModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/28/24.
//

import SwiftUI

struct SliderPageModel: Identifiable, Hashable {
    var id: UUID = .init()
    var image: String
    var header: String
    var subheader: String
}
