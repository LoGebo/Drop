//
//  EmergencyView.swift
//  Drop
//
//  Created by Dario on 30/03/25.
//

import SwiftUI

struct EmergencyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedEmergencyType: EmergencyType?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color.red)
                        .clipShape(Circle())
                        .padding(.top, 16)
                    
                    VStack(spacing: 8) {
                        Text("Emergency Assistance")
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                        
                        Text("Select the type of emergency")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal)
                
                // Emergency Options
                VStack(spacing: 16) {
                    EmergencyOptionButton(
                        title: "Medical Emergency",
                        subtitle: "Need immediate medical assistance",
                        icon: "cross.case.fill",
                        isSelected: selectedEmergencyType == .medical
                    ) {
                        selectedEmergencyType = .medical
                    }
                    
                    EmergencyOptionButton(
                        title: "Security Threat",
                        subtitle: "Dangerous situation or person",
                        icon: "shield.fill",
                        isSelected: selectedEmergencyType == .security
                    ) {
                        selectedEmergencyType = .security
                    }
                    
                    EmergencyOptionButton(
                        title: "Fire",
                        subtitle: "Fire or smoke detected",
                        icon: "flame.fill",
                        isSelected: selectedEmergencyType == .fire
                    ) {
                        selectedEmergencyType = .fire
                    }
                    
                    EmergencyOptionButton(
                        title: "Vehicle Accident",
                        subtitle: "Collision or derailment",
                        icon: "car.fill",
                        isSelected: selectedEmergencyType == .vehicle
                    ) {
                        selectedEmergencyType = .vehicle
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 32)
                
                // Bottom Actions
                VStack(spacing: 16) {
                    NavigationLink(destination: ReportView()) {
                        Text("Report Non-Emergency Issue")
                            .font(.body.weight(.medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(UIColor.secondarySystemBackground))
                            .foregroundColor(.primary)
                            .cornerRadius(15)
                    }
                    
                    if selectedEmergencyType != nil {
                        Button(action: {}) {
                            Text("Contact Emergency Services")
                                .font(.body.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .imageScale(.large)
                }
            }
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0)
        }
    }
}

struct EmergencyOptionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 32)
                    .foregroundColor(isSelected ? .red : .primary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body.weight(.semibold))
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.red)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.red.opacity(0.1) : Color(UIColor.secondarySystemBackground))
            .foregroundColor(isSelected ? .primary : .primary)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.red : Color.clear, lineWidth: 1)
            )
        }
    }
}

enum EmergencyType {
    case medical
    case security
    case fire
    case vehicle
}

#Preview {
    NavigationStack {
        EmergencyView()
    }
}
