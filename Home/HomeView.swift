//
//  HomeView.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    routeFinderCard
                    
                    if let trip = viewModel.currentTrip {
                        currentTripSection(trip: trip)
                    }
                    
                    favoriteRoutesSection
                    nearbyStationsSection
                    emergencyButtonSection
                }
                .padding(.vertical)
            }
            .background(Color(UIColor.systemBackground))
            .navigationTitle("TransitGo")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "bell.badge")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                            .imageScale(.large)
                    }
                }
            }
        }
    }
    
    private var routeFinderCard: some View {
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
                    RouteTextField(text: viewModel.fromLocation, placeholder: "Home")
                        .textContentType(.location)
                    
                    RouteTextField(text: viewModel.toLocation, placeholder: "Where to?")
                        .textContentType(.location)
                }
            }
            
            Button(action: {}) {
                Label("Find Routes", systemImage: "magnifyingglass")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.green)
                    .foregroundColor(.black)
                    .cornerRadius(15)
            }
            .buttonStyle(.scale)
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    private func currentTripSection(trip: Trip) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Current Trip")
                    .font(.title3.weight(.bold))
                Spacer()
                ShareLink(item: "Sharing my current trip on TransitGo!") {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.green)
                }
            }
            
            CurrentTripView(trip: trip)
        }
        .padding(.horizontal)
    }
    
    private var favoriteRoutesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Favorite Routes")
                    .font(.title3.weight(.bold))
                Spacer()
                Button(action: {}) {
                    Label("See All", systemImage: "chevron.right")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.green)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.favoriteRoutes) { route in
                        FavoriteRouteCard(route: route)
                            .containerRelativeFrame(.horizontal, count: 2, spacing: 16)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
        .padding(.horizontal)
    }
    
    private var nearbyStationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Nearby Stations")
                    .font(.title3.weight(.bold))
                Spacer()
                Button(action: {}) {
                    Label("Map View", systemImage: "map")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.green)
                }
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(viewModel.nearbyStations) { station in
                    StationCard(station: station)
                        .transition(.scale)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var emergencyButtonSection: some View {
        VStack(spacing: 12) {
            Button(action: {}) {
                Label("Emergency Button", systemImage: "shield.fill")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .buttonStyle(.scale)
            
            Text("Tap in case of emergency to alert authorities and driver")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
}

// MARK: - Supporting Views
struct RouteTextField: View {
    let text: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: .constant(text))
            .font(.body)
            .textFieldStyle(.plain)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color(UIColor.tertiarySystemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

struct StationCard: View {
    let station: Station
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "tram.fill")
                    .font(.title3)
                    .foregroundStyle(.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(station.name)
                        .font(.body.weight(.semibold))
                    Text("\(String(format: "%.1f", station.distance)) mi")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(station.lines) { line in
                        Text(line.name)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(lineColor(for: line.color))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    private func lineColor(for color: LineColor) -> Color {
        switch color {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .yellow: return Color(red: 0.9, green: 0.8, blue: 0.0)
        }
    }
}

struct FavoriteRouteCard: View {
    let route: Route
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(route.from) → \(route.to)")
                .font(.body.weight(.semibold))
                .lineLimit(1)
            
            HStack {
                Image(systemName: "clock")
                Text(route.time)
                    .font(.subheadline)
            }
            .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Occupancy")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack {
                    Gauge(value: Double(route.occupancy) / 100.0) {
                        EmptyView()
                    }
                    .tint(occupancyColor(route.occupancy))
                    
                    Text("\(route.occupancy)%")
                        .font(.caption.weight(.medium))
                        .foregroundColor(occupancyColor(route.occupancy))
                }
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    private func occupancyColor(_ value: Int) -> Color {
        value >= 80 ? .red : .orange
    }
}

struct CurrentTripView: View {
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(trip.route)
                    .font(.headline)
                Spacer()
                Text("On Time")
                    .font(.caption)
                    .bold()
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            
            HStack {
                Image(systemName: "clock")
                Text("Departure: \(trip.departure) • ETA: \(trip.eta)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(Array(trip.stops.enumerated()), id: \.element.name) { index, stop in
                    TripStopView(stop: stop, isLast: index == trip.stops.count - 1)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Vehicle Occupancy")
                    .foregroundColor(.gray)
                    .font(.caption)
                HStack {
                    ProgressView(value: Double(trip.vehicleOccupancy) / 100.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .accentColor(.orange)
                    Text("\(trip.vehicleOccupancy)%")
                        .foregroundColor(.orange)
                        .font(.caption)
                }
            }
            
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.green)
                    Text("CO₂: \(String(format: "%.1f", trip.co2Saved)) kg saved")
                        .foregroundColor(.green)
                        .font(.caption)
                }
                
                Spacer()
                
                Text("Bus #\(trip.busNumber)")
                    .foregroundColor(.blue)
                    .font(.caption)
                    .bold()
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
    }
}

struct TripStopView: View {
    let stop: TripStop
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(spacing: 0) {
                Circle()
                    .fill(stopColor)
                    .frame(width: 8, height: 8)
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 40)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stop.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(stop.status == .current ? .white : .gray)
                Text(stop.detail)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var stopColor: Color {
        switch stop.status {
        case .completed: return .gray
        case .current: return .green
        case .upcoming: return .gray.opacity(0.5)
        }
    }
}

#Preview {
    MainTabView()
}
