//
//  AlertsView.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import SwiftUI

struct AlertsView: View {
    @StateObject private var viewModel = AlertsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.alerts) { alert in
                        AlertCardView(alert: alert)
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Alerts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.clearAllAlerts() }) {
                        Text("Clear All")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.green)
                    }
                }
            }
        }
    }
}

struct AlertCardView: View {
    let alert: Alert
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Alert Icon
            alertIcon
                .foregroundColor(alertColor)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(alert.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text(alert.timeAgo)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Text(alert.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    @ViewBuilder
    private var alertIcon: some View {
        switch alert.type {
        case .warning:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
        case .error:
            Image(systemName: "exclamationmark.circle.fill")
                .font(.title2)
        case .info:
            Image(systemName: "info.circle.fill")
                .font(.title2)
        case .success:
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
        }
    }
    
    private var alertColor: Color {
        switch alert.type {
        case .warning:
            return Color.orange
        case .error:
            return Color.red
        case .info:
            return Color.blue
        case .success:
            return Color.green
        }
    }
}

#Preview {
    MainTabView()
}
