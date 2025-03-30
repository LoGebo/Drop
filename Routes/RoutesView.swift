//
//  RoutesView.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import SwiftUI

struct RoutesView: View {
    @StateObject private var viewModel = RoutesViewModel()
    @State private var searchText = ""
    @State private var showResults = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
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
                                TextField("Origin", text: .constant("Current Location"))
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(Color(UIColor.tertiarySystemBackground))
                                    .cornerRadius(12)
                                
                                TextField("Destination", text: $searchText)
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(Color(UIColor.tertiarySystemBackground))
                                    .cornerRadius(12)
                            }
                        }
                        
                        Button(action: {
                            Task {
                                await viewModel.fetchRoute(
                                    from: Location(latitude: 25.684533, longitude: -100.306892),
                                    to: Location(latitude: 25.679100, longitude: -100.284000)
                                )
                                withAnimation(.spring()) {
                                    showResults = true
                                }
                            }
                        }) {
                            if viewModel.isLoading {
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
                    
                    if showResults, let route = viewModel.currentRoute {
                        // Route Header Card
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(.green)
                                            .frame(width: 8, height: 8)
                                        Text("Current Location")
                                        Image(systemName: "arrow.right")
                                            .foregroundStyle(.secondary)
                                        Text("Destination")
                                    }
                                }
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Departure")
                                        .foregroundStyle(.secondary)
                                    Text(viewModel.formatTime(route.departureTime))
                                }
                                
                                Image(systemName: "arrow.right")
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal)
                                
                                VStack(alignment: .leading) {
                                    Text("Arrival")
                                        .foregroundStyle(.secondary)
                                    Text(viewModel.formatTime(route.arrivalTime))
                                }
                                
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        
                        // Route Timeline
                        VStack(spacing: 0) {
                            ForEach(Array(route.segments.enumerated()), id: \.element.id) { index, segment in
                                RouteSegmentView(
                                    segment: segment,
                                    isFirst: index == 0,
                                    isLast: index == route.segments.count - 1,
                                    previousType: index > 0 ? route.segments[index - 1].type : nil
                                )
                            }
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        
                        // Journey Achievements
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Journey Achievements")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            HStack(spacing: 20) {
                                AchievementView(
                                    icon: "person.2.fill",
                                    value: "\(route.occupancy)%",
                                    label: "Occupancy",
                                    color: .blue
                                )
                                
                                AchievementView(
                                    icon: "leaf.fill",
                                    value: String(format: "%.1f", route.co2Saved),
                                    label: "kg CO₂ Saved",
                                    color: .green
                                )
                                
                                AchievementView(
                                    icon: "flame.fill",
                                    value: "\(route.calories)",
                                    label: "Calories",
                                    color: .orange
                                )
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .padding(.vertical)
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

struct RouteSegmentView: View {
    let segment: RouteSegment
    let isFirst: Bool
    let isLast: Bool
    let previousType: TransportType?
    
    var body: some View {
        HStack(spacing: 16) {
            // Timeline
            VStack(spacing: 0) {
                Circle()
                    .fill(segmentColor)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: segment.type.iconName)
                            .foregroundStyle(.white)
                    }
                
                if !isLast {
                    Rectangle()
                        .fill(segmentColor)
                        .frame(width: 4)
                        .frame(height: 80)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(segment.description)
                    .font(.body)
                
                if let routeName = segment.routeName {
                    HStack {
                        Circle()
                            .fill(.purple)
                            .frame(width: 8, height: 8)
                        Text(routeName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Text(String(format: "%.0f m", segment.distance))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(segment.time) min")
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.black)
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
        .padding(.vertical, 8)
    }
    
    var segmentColor: Color {
        switch segment.type {
        case .WALK:
            return .green
        case .METRO:
            return .purple
        case .BUS:
            return .blue
        case .MINIBUS:
            return .orange
        }
    }
}

struct AchievementView: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    RoutesView()
}
