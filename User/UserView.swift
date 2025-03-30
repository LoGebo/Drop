//
//  UserView.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import SwiftUI

struct UserView: View {
    @StateObject private var viewModel = UserViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // User Profile Card
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            Circle()
                                .fill(Color(UIColor.secondarySystemBackground))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.primary)
                                )
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(viewModel.user.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(viewModel.user.email)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                        }
                        
                        // Settings Toggles
                        VStack(spacing: 15) {
                            Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: .green))
                            
                            Toggle("Location Services", isOn: $viewModel.locationServicesEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: .green))
                            
                            Toggle("Dark Mode", isOn: $isDarkMode)
                                .toggleStyle(SwitchToggleStyle(tint: .green))
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                    
                    // Payment Methods
                    VStack(spacing: 15) {
                        Text("Payment Methods")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(viewModel.paymentMethods) { payment in
                            HStack {
                                Image(systemName: "creditcard")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(paymentTypeString(payment.type))
                                        .font(.headline)
                                    
                                    Text("Ending in \(payment.lastFourDigits)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                if payment.isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(15)
                        }
                        
                        // Add Payment Button
                        Button(action: {
                            viewModel.addPaymentMethod()
                        }) {
                            Label("Add Payment Method", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.black)
                                .cornerRadius(15)
                        }
                        .buttonStyle(.scale)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                    
                    // Preferences
                    VStack(spacing: 15) {
                        Text("Preferences")
                            .font(.title3)
                            .fontWeight(.bold)
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
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(15)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Button(action: {
                        viewModel.logout()
                    }) {
                        Text("Log Out")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.red)
                            }
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.scale)
                    .padding(.bottom, 50)
                }
                .padding()
            }
            .background(Color(UIColor.systemBackground))
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 120)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
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

#Preview {
    MainTabView()
}
