//
//  FileShareSheet.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/25/26.
//

import OSLog
import UIKit

/// Opens the system share sheet for a file, the way Photos and Files share one.
///
/// `ShareLink` hands a file to the receiving app as a temporary copy that is deleted as soon as the
/// app's load call returns. Instagram keeps reading a video after that and fails with "Something went
/// wrong", so videos are shared from here instead. The file must stay in place until sharing ends.
@MainActor
enum FileShareSheet {

    static func present(_ url: URL) {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        // Inactive while a banner or Control Center is pulled down, but still on screen.
        let scene = scenes.first { $0.activationState == .foregroundActive }
            ?? scenes.first { $0.activationState == .foregroundInactive }
        guard let window = scene?.keyWindow ?? scene?.windows.first,
              var presenter = window.rootViewController else {
            Logger.general.error("No window to present the share sheet from")
            return
        }
        while let presented = presenter.presentedViewController {
            presenter = presented
        }
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = presenter.view
        presenter.present(controller, animated: true)
    }
}
