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
            VStack(spacing: 0) {
                // Route Finder
                VStack(spacing: 12) {
                    HStack(spacing: 10) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                        RouteTextField(text: viewModel.fromLocation, placeholder: "Home")
                    }
                    
                    HStack(spacing: 10) {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 12, height: 12)
                        RouteTextField(text: viewModel.toLocation, placeholder: "Where to?")
                    }
                    
                    Button(action: {}) {
                        Text("Find Routes")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Current Trip
                        if let trip = viewModel.currentTrip {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Current Trip")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                    HStack(spacing: 5) {
                                        Image(systemName: "square.and.arrow.up")
                                            .foregroundColor(.green)
                                        Text("Share")
                                            .foregroundColor(.green)
                                    }
                                }
                                
                                CurrentTripView(trip: trip)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Favorite Routes
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Favorite Routes")
                                .font(.title2)
                                .bold()
                            
                            HStack(spacing: 15) {
                                ForEach(viewModel.favoriteRoutes) { route in
                                    FavoriteRouteCard(route: route)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
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
                            
                            // Emergency Button
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "shield.fill")
                                    Text("Emergency Button")
                                        .font(.headline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .padding(.top, 10)
                            
                            Text("Tap in case of emergency to alert authorities and driver")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 20)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
                }
                
            }
            .navigationTitle("TransitGo")
            .navigationBarItems(trailing: Button(action: {}) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 36, height: 36)
                    .shadow(radius: 1)
            })
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .preferredColorScheme(.dark)
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
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)
                .padding(.top, 15)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(station.name)
                    .font(.headline)
                Text("\(String(format: "%.1f", station.distance)) mi away")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            HStack {
                ForEach(station.lines) { line in
                    Text(line.name)
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(lineColor(for: line.color))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(Color(UIColor.systemGray6))
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
        VStack(alignment: .leading, spacing: 8) {
            Text("\(route.from) → \(route.to)")
                .font(.headline)
            
            HStack {
                Image(systemName: "clock")
                Text(route.time)
                    .font(.subheadline)
            }
            .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Occupancy")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    ProgressView(value: Double(route.occupancy) / 100.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .accentColor(occupancyColor(route.occupancy))
                    
                    Text("\(route.occupancy)%")
                        .font(.caption)
                        .foregroundColor(occupancyColor(route.occupancy))
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
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
                Text("\(trip.route)")
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
                    .frame(width: 16, height: 16)
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 40)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stop.name)
                    .font(.subheadline)
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
    HomeView()
}
