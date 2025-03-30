//
//  RoutesView.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import SwiftUI

struct RoutesView: View {
    @StateObject private var viewModel = RoutesViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Search Form
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            VStack(spacing: 0) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 8, height: 8)
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 2, height: 30)
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 8, height: 8)
                            }
                            
                            VStack(spacing: 12) {
                                TextField("Current Location", text: $viewModel.currentLocation)
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(Color(UIColor.tertiarySystemBackground))
                                    .cornerRadius(12)
                                
                                TextField("Where to?", text: $viewModel.destination)
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(Color(UIColor.tertiarySystemBackground))
                                    .cornerRadius(12)
                            }
                        }
                        
                        Button(action: { viewModel.findRoutes() }) {
                            if viewModel.isSearching {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.black)
                            } else {
                                Label("Find Routes", systemImage: "magnifyingglass")
                            }
                        }
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .buttonStyle(.scale)
                    }
                    .padding(16)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(20)
                    
                    if viewModel.showingResults {
                        // Route Results
                        ForEach(viewModel.routes) { route in
                            RouteCard(route: route)
                                .transition(.scale)
                        }
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Routes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }
}

struct RouteCard: View {
    let route: TransitRoute
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(route.from) → \(route.to)")
                        .font(.headline)
                    Text("\(route.totalTime) min • $\(String(format: "%.2f", route.price))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if let tag = route.tag {
                    Text(tag.rawValue)
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(tagColor(for: tag).opacity(0.2))
                        .foregroundColor(tagColor(for: tag))
                        .clipShape(Capsule())
                }
            }
            
            // Route Segments
            VStack(spacing: 12) {
                ForEach(route.segments) { segment in
                    HStack(spacing: 12) {
                        Image(systemName: segment.type.iconName)
                            .foregroundStyle(.green)
                        
                        Text(segment.type.description)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        if let occupancy = segment.occupancy {
                            Text("\(occupancy)%")
                                .font(.caption.weight(.medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(occupancyColor(occupancy).opacity(0.2))
                                .foregroundColor(occupancyColor(occupancy))
                                .clipShape(Capsule())
                        }
                        
                        Text("\(segment.time) min")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.green)
                Text("\(String(format: "%.1f", route.co2Saved)) kg CO₂ saved")
                    .font(.caption)
                    .foregroundStyle(.green)
                
                Spacer()
                
                Button(action: {}) {
                    Text("Select")
                        .font(.subheadline.weight(.medium))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
                .buttonStyle(.scale)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    private func tagColor(for tag: RouteTag) -> Color {
        switch tag {
        case .fastest: return .green
        case .cheapest: return .blue
        case .accessible: return .orange
        case .recommended: return .purple
        }
    }
    
    private func occupancyColor(_ value: Int) -> Color {
        switch value {
        case 0...50: return .green
        case 51...80: return .orange
        default: return .red
        }
    }
}

#Preview {
    MainTabView()
}
