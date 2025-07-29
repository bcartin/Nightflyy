//
//  ReportViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/16/25.
//

import SwiftUI

@Observable
class ReportViewModel {
    
    var reportReasons: [String] = ["Offensive Language",
                                   "Rude/Obscene Photos",
                                   "Inappropriate Messages",
                                   "Other"]
    
    var selectedReason: String?
    var objectId: String
    var notes: String = ""
    
    init(objectId: String) {
        self.objectId = objectId
    }
    
    var hasSelectedReason: Bool {
        selectedReason != nil
    }
    
    func submitReport() {
        guard let reason = selectedReason else { return }
        guard let uid = AccountManager.shared.account?.uid else { return }
        let report = Report(reason: reason, accountReported: objectId, reportedBy: uid, notes: notes, date: Date())
        try? ReportsClient.submitReport(report: report)
        General.showSuccessMessage(message: "Report Sent", imageName: "checkmark.circle.fill")
    }
    
    
}
