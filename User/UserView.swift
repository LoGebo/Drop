//
//  UserView.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import SwiftUI

struct UserView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                    
                    Text("John Doe")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("john.doe@example.com")
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Settings Section
                VStack(spacing: 8) {
                    Text("Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Dark Mode Toggle
                    HStack {
                        Label("Dark Mode", systemImage: "moon.fill")
                        Spacer()
                        Toggle("", isOn: $isDarkMode)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    
                    // Notifications
                    Button(action: {}) {
                        HStack {
                            Label("Notifications", systemImage: "bell.fill")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    
                    // Privacy
                    Button(action: {}) {
                        HStack {
                            Label("Privacy", systemImage: "lock.fill")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    
                    // Help & Support
                    Button(action: {}) {
                        HStack {
                            Label("Help & Support", systemImage: "questionmark.circle.fill")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Version Info
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    MainTabView()
}
