//
//  UserViewModel.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var user = User(
        name: "John Doe",
        email: "johndoe@email.com",
        profileImage: "person.circle.fill"
    )
    
    @Published var notificationsEnabled = true
    @Published var locationServicesEnabled = true
    
    @Published var paymentMethods: [PaymentMethod] = [
        PaymentMethod(
            type: .visa,
            lastFourDigits: "4242",
            isSelected: true
        )
    ]
    
    @Published var selectedLanguage: PreferenceType = .english
    
    func addPaymentMethod() {
        // This would typically show a form or payment sheet
        print("Add payment method")
    }
    
    func toggleNotifications() {
        notificationsEnabled.toggle()
    }
    
    func toggleLocationServices() {
        locationServicesEnabled.toggle()
    }
    
    func logout() {
        // Implementation for logout functionality
        print("User logged out")
    }
}
