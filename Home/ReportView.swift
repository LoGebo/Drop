//
//  ReportView.swift
//  Drop
//
//  Created by Dario on 30/03/25.
//

import SwiftUI

struct ReportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedIssueType: IssueType?
    @State private var location = ""
    @State private var selectedSeverity: Severity = .low
    @State private var description = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Help us improve your transit experience")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 16)
                
                // Issue Type Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Issue Type")
                        .font(.headline)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        IssueTypeButton(
                            title: "Cleanliness",
                            icon: "trash.fill",
                            isSelected: selectedIssueType == .cleanliness
                        ) {
                            selectedIssueType = .cleanliness
                        }
                        
                        IssueTypeButton(
                            title: "Security",
                            icon: "shield.fill",
                            isSelected: selectedIssueType == .security
                        ) {
                            selectedIssueType = .security
                        }
                        
                        IssueTypeButton(
                            title: "Maintenance",
                            icon: "wrench.fill",
                            isSelected: selectedIssueType == .maintenance
                        ) {
                            selectedIssueType = .maintenance
                        }
                        
                        IssueTypeButton(
                            title: "Service",
                            icon: "headphones",
                            isSelected: selectedIssueType == .service
                        ) {
                            selectedIssueType = .service
                        }
                        
                        IssueTypeButton(
                            title: "Accessibility",
                            icon: "figure.roll",
                            isSelected: selectedIssueType == .accessibility
                        ) {
                            selectedIssueType = .accessibility
                        }
                        
                        IssueTypeButton(
                            title: "Other",
                            icon: "ellipsis.circle.fill",
                            isSelected: selectedIssueType == .other
                        ) {
                            selectedIssueType = .other
                        }
                    }
                }
                
                // Rest of the form
                VStack(spacing: 24) {
                    // Location Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location")
                            .font(.headline)
                        
                        HStack {
                            TextField("Enter location or station", text: $location)
                                .textFieldStyle(.plain)
                            
                            Button(action: {}) {
                                Image(systemName: "location.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                    
                    // Severity Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Severity")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            ForEach(Severity.allCases, id: \.self) { severity in
                                Button(action: { selectedSeverity = severity }) {
                                    Text(severity.rawValue)
                                        .font(.subheadline.weight(.medium))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(selectedSeverity == severity ? Color.green : Color(UIColor.secondarySystemBackground))
                                        .foregroundColor(selectedSeverity == severity ? .white : .primary)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                    
                    // Description Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        TextEditor(text: $description)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                
                Spacer()
                
                // Submit Button
                Button(action: {}) {
                    Text("Submit Report")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Report an Issue")
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

struct IssueTypeButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.green.opacity(0.1) : Color(UIColor.secondarySystemBackground))
            .foregroundColor(isSelected ? .green : .primary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 1)
            )
        }
    }
}

enum IssueType {
    case cleanliness
    case security
    case maintenance
    case service
    case accessibility
    case other
}

enum Severity: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

#Preview {
    NavigationStack {
        ReportView()
    }
}
