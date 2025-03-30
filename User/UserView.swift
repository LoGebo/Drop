//
//  UserView.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import SwiftUI

struct UserView: View {
    @StateObject private var viewModel = UserViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header with Logout button
                    HStack {
                        Text("Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.logout()
                        }) {
                            Text("Log Out")
                                .foregroundColor(.black)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(
                                    Capsule()
                                        .fill(Color.white)
                                )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 20)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // User Profile Card
                            VStack(spacing: 20) {
                                HStack(spacing: 15) {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 80, height: 80)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(viewModel.user.name)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Text(viewModel.user.email)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                }
                                
                                // Settings Toggles
                                VStack(spacing: 15) {
                                    Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                                        .toggleStyle(SwitchToggleStyle(tint: .white))
                                    
                                    Toggle("Location Services", isOn: $viewModel.locationServicesEnabled)
                                        .toggleStyle(SwitchToggleStyle(tint: .white))
                                    
                                    Toggle("Dark Mode", isOn: $viewModel.darkModeEnabled)
                                        .toggleStyle(SwitchToggleStyle(tint: .white))
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(15)
                            
                            // Payment Methods
                            VStack(spacing: 15) {
                                Text("Payment Methods")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ForEach(viewModel.paymentMethods) { payment in
                                    HStack {
                                        Image(systemName: "creditcard")
                                            .font(.title2)
                                            .foregroundColor(.gray)
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(paymentTypeString(payment.type))
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            
                                            Text("Ending in \(payment.lastFourDigits)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white)
                                            .frame(width: 30, height: 30)
                                    }
                                    .padding()
                                    .background(Color(UIColor.systemGray5))
                                    .cornerRadius(15)
                                }
                                
                                // Add Payment Button
                                Button(action: {
                                    viewModel.addPaymentMethod()
                                }) {
                                    Text("Add Payment Method")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(15)
                            
                            // Preferences
                            VStack(spacing: 15) {
                                Text("Preferences")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Menu {
                                    ForEach(PreferenceType.allCases) { language in
                                        Button(language.rawValue) {
                                            viewModel.selectedLanguage = language
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(viewModel.selectedLanguage.rawValue)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)
                    }
                }
                
            }
            .preferredColorScheme(.dark)
        }
        .navigationBarHidden(true)
    }
    
    private func paymentTypeString(_ type: PaymentType) -> String {
        switch type {
        case .visa: return "Visa"
        case .mastercard: return "Mastercard"
        case .applePay: return "Apple Pay"
        case .paypal: return "PayPal"
        }
    }
}

struct CustomTabBar: View {
    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(icon: "house.fill", label: "Home", isSelected: false)
            TabBarItem(icon: "map", label: "Routes", isSelected: false)
            TabBarItem(icon: "bell", label: "Alerts", isSelected: false)
            TabBarItem(icon: "person", label: "Profile", isSelected: true)
        }
        .padding(.vertical, 8)
        .background(Color(UIColor.systemGray6))
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(isSelected ? .primary : .gray)
            Text(label)
                .font(.caption)
                .foregroundColor(isSelected ? .primary : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    UserView()
}
