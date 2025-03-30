//
//  UserModel.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import Foundation

struct User {
    let name: String
    let email: String
    let profileImage: String
}

struct PaymentMethod: Identifiable {
    let id = UUID()
    let type: PaymentType
    let lastFourDigits: String
    let isSelected: Bool
}

enum PaymentType {
    case visa
    case mastercard
    case applePay
    case paypal
}

enum PreferenceType: String, CaseIterable, Identifiable {
    case english = "English"
    case spanish = "Spanish"
    case french = "French"
    
    var id: String { self.rawValue }
}
