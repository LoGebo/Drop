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
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header with Clear All button
                    HStack {
                        Text("Alerts")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.clearAllAlerts()
                        }) {
                            Text("Clear All")
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
                    
                    // Alert List
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.alerts) { alert in
                                AlertCardView(alert: alert)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
        .navigationBarHidden(true)
    }
}

struct AlertCardView: View {
    let alert: Alert
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Alert Icon
            alertIcon
                .foregroundColor(alertColor)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(alert.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(alert.timeAgo)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Text(alert.message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemGray6))
        )
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
    AlertsView()
}
