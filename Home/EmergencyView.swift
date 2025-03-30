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
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .frame(width: 64, height: 64)
                    .background(Color.red)
                    .clipShape(Circle())
                
                Text("Emergency Assistance")
                    .font(.title2.bold())
                
                Text("Select the type of emergency")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            // Emergency Options
            VStack(spacing: 12) {
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
            .padding(.vertical)
            
            Spacer()
            
            // Report Non-Emergency Button
            Button(action: { dismiss() }) {
                Text("Report Non-Emergency Issue")
                    .font(.subheadline.weight(.medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(UIColor.secondarySystemBackground))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
            }
        }
        .padding()
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body.weight(.semibold))
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.red.opacity(0.1) : Color(UIColor.secondarySystemBackground))
            .foregroundColor(isSelected ? .red : .primary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
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
