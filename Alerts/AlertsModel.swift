//
//  AlertsModel.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import Foundation

enum AlertType {
    case warning
    case error
    case info
    case success
}

struct Alert: Identifiable {
    let id = UUID()
    let type: AlertType
    let title: String
    let message: String
    let timeAgo: String
}
