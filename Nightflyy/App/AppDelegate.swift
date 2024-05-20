//
//  AppDelegate.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/23/24.
//

import Foundation
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let fileName: String = try! Configuration.value(for: "FB_FILEPATH_NAME")
        let filePath = Bundle.main.path(forResource: fileName, ofType: "plist")
        let qonversionKey: String = try! Configuration.value(for: "QONVERSION_KEY")
        
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!) else {
            assert(false, "Couldn't load config file")
            return true
        }
        FirebaseApp.configure(options: fileopts)

        return true
    }
}
