//
//  AlertsViewModel.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import Foundation
import SwiftUI

class AlertsViewModel: ObservableObject {
    @Published var alerts: [Alert] = [
        Alert(
            type: .warning,
            title: "Route Change",
            message: "The driver changed its path due to road maintenance.",
            timeAgo: "5 min ago"
        ),
        Alert(
            type: .error,
            title: "Station Problem",
            message: "Problem detected in the next station, consider taking another route.",
            timeAgo: "12 min ago"
        ),
        Alert(
            type: .info,
            title: "Schedule Update",
            message: "The schedule for Route #42 has been updated for the weekend.",
            timeAgo: "30 min ago"
        ),
        Alert(
            type: .success,
            title: "Service Update",
            message: "All services are running on schedule.",
            timeAgo: "1 hour ago"
        )
    ]
    
    func clearAllAlerts() {
        alerts.removeAll()
    }
}
