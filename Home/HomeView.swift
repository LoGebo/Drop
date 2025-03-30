//
//  HomeView.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Route Finder
                VStack(spacing: 12) {
                    RouteTextField(text: viewModel.fromLocation, placeholder: "From")
                    RouteTextField(text: viewModel.toLocation, placeholder: "Where to?")
                    
                    Button(action: {}) {
                        Text("Find Routes")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(15)
                
                // Current Trip
                if let trip = viewModel.currentTrip {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Current Trip")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.green)
                                Text("Share")
                                    .foregroundColor(.green)
                            }
                        }
                        
                        CurrentTripView(trip: trip)
                    }
                }
                
                // Favorite Routes
                VStack(alignment: .leading, spacing: 15) {
                    Text("Favorite Routes")
                        .font(.title2)
                        .bold()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.favoriteRoutes) { route in
                                FavoriteRouteCard(route: route)
                            }
                        }
                    }
                }
                
                // Nearby Stations
                VStack(alignment: .leading, spacing: 15) {
                    Text("Nearby Stations")
                        .font(.title2)
                        .bold()
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        ForEach(viewModel.nearbyStations) { station in
                            StationCard(station: station)
                        }
                    }
                }
                
                // Emergency Button
                Button(action: {}) {
                    HStack {
                        Image(systemName: "shield.fill")
                        Text("Emergency Button")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Spacer()
                
                // Tab Bar
                CustomTabBar()
            }
            .padding()
            .navigationTitle("TransitGo")
            .navigationBarItems(trailing: Button(action: {}) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.gray)
            })
        }
    }
}

// Supporting Views
struct RouteTextField: View {
    let text: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: .constant(text))
            .padding()
            .background(Color(UIColor.systemGray5))
            .cornerRadius(10)
    }
}

struct StationCard: View {
    let station: Station
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)
            
            Text(station.name)
                .font(.headline)
            Text("\(String(format: "%.1f", station.distance)) mi away")
                .foregroundColor(.gray)
            
            HStack {
                ForEach(station.lines) { line in
                    Text(line.name)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(lineColor(for: line.color))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
    }
    
    private func lineColor(for color: LineColor) -> Color {
        switch color {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .yellow: return .yellow
        }
    }
}

struct FavoriteRouteCard: View {
    let route: Route
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(route.from) → \(route.to)")
                .font(.headline)
            HStack {
                Image(systemName: "clock")
                Text(route.time)
            }
            .foregroundColor(.gray)
            
            VStack(alignment: .leading) {
                Text("Occupancy")
                    .foregroundColor(.gray)
                ProgressView(value: Double(route.occupancy) / 100.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(route.occupancy > 80 ? .red : .orange)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .frame(width: 200)
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
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            
            Text("Departure: \(trip.departure) • ETA: \(trip.eta)")
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(Array(trip.stops.enumerated()), id: \.element.name) { index, stop in
                    TripStopView(stop: stop, isLast: index == trip.stops.count - 1)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Vehicle Occupancy")
                    .foregroundColor(.gray)
                HStack {
                    ProgressView(value: Double(trip.vehicleOccupancy) / 100.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .accentColor(.orange)
                    Text("\(trip.vehicleOccupancy)%")
                        .foregroundColor(.orange)
                }
            }
            
            HStack {
                Label("\(String(format: "%.1f", trip.co2Saved)) kg saved", systemImage: "leaf.fill")
                    .foregroundColor(.green)
                Spacer()
                Text("Bus #\(trip.busNumber)")
                    .foregroundColor(.blue)
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
                    .frame(width: 12, height: 12)
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 30)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stop.name)
                    .font(.subheadline)
                    .foregroundColor(stop.status == .current ? .primary : .gray)
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
        case .upcoming: return .gray.opacity(0.3)
        }
    }
}

struct CustomTabBar: View {
    var body: some View {
        HStack(spacing: 0) {
            ForEach(["house.fill", "map", "bell", "person"], id: \.self) { icon in
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: icon)
                        .foregroundColor(icon == "house.fill" ? .black : .gray)
                    Text(tabName(for: icon))
                        .font(.caption)
                        .foregroundColor(icon == "house.fill" ? .black : .gray)
                }
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground))
    }
    
    private func tabName(for icon: String) -> String {
        switch icon {
        case "house.fill": return "Home"
        case "map": return "Routes"
        case "bell": return "Alerts"
        case "person": return "Profile"
        default: return ""
        }
    }
}

#Preview {
    HomeView()
}
