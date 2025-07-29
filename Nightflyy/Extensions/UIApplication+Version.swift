//
//  UIApplication+Version.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 7/2/25.
//

import UIKit

extension UIApplication {
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
