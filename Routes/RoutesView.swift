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
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header with title
                    HStack {
                        Text("Routes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        // Search button (or Clear All for results)
                        Button(action: {
                            viewModel.showingResults = false
                        }) {
                            Text(viewModel.showingResults ? "Clear" : "Search")
                                .foregroundColor(.black)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(
                                    Capsule()
                                        .fill(Color.white)
                                )
                        }
                        .padding(.trailing)
                        .padding(.top)
                    }
                    .padding(.bottom, 20)
                    
                    if !viewModel.showingResults {
                        // Search Form
                        searchFormView
                    } else {
                        // Route Results
                        routeResultsView
                    }
                    
                    Spacer()
                    

                }
            }
            .preferredColorScheme(.dark)
        }
        .navigationBarHidden(true)
    }
    
    // Search Form View
    private var searchFormView: some View {
        VStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(UIColor.systemGray6))
                    .frame(height: 200)
                
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        ZStack {
                            VStack(spacing: 0) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 12, height: 12)
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 2, height: 40)
                                
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 12, height: 12)
                            }
                        }
                        .padding(.leading, 8)
                        
                        VStack(spacing: 20) {
                            TextField("", text: $viewModel.currentLocation)
                                .placeholder(when: viewModel.currentLocation.isEmpty) {
                                    Text("Current location")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(UIColor.systemGray5))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            
                            TextField("", text: $viewModel.destination)
                                .placeholder(when: viewModel.destination.isEmpty) {
                                    Text("Enter destination")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(UIColor.systemGray5))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            viewModel.findRoutes()
                        }) {
                            Text("Find Routes")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            viewModel.goToMap()
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "location")
                                        .foregroundColor(.black)
                                )
                        }
                    }
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
    
    // Route Results View
    private var routeResultsView: some View {
        VStack(spacing: 20) {
            // Header for results
            HStack {
                Text("Route Options")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    viewModel.compareRoutes()
                }) {
                    HStack {
                        Image(systemName: "square.grid.2x2")
                        Text("Compare")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.green)
                }
            }
            .padding(.horizontal)
            
            // Route list
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.routes) { route in
                        RouteCard(route: route, onSelect: {
                            viewModel.selectRoute(route)
                        })
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct RouteCard: View {
    let route: TransitRoute
    let onSelect: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemGray6))
            
            VStack(spacing: 15) {
                // Route header
                HStack {
                    Text("\(route.from) → \(route.to)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Tag (Fastest, Accessible, etc.)
                    if let tag = route.tag {
                        Text(tag.rawValue)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            .background(tagColor(for: tag))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
                
                // Trip details
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text("\(route.totalTime) min total")
                            .foregroundColor(.gray)
                    }
                    
                    Text("•")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 4)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign")
                            .foregroundColor(.gray)
                        Text("$\(String(format: "%.2f", route.price))")
                            .foregroundColor(.gray)
                    }
                }
                .font(.subheadline)
                
                // Segments visualization
                HStack(alignment: .bottom, spacing: 20) {
                    ForEach(route.segments) { segment in
                        VStack(spacing: 0) {
                            // Occupancy indicator (only for transit modes)
                            if let occupancy = segment.occupancy, segment.type != .walk && segment.type != .bike {
                                HStack {
                                    Spacer()
                                    Text("\(occupancy)%")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Image(systemName: "eye")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.red.opacity(0.3))
                                )
                                .padding(.bottom, 8)
                            }
                            
                            // Mode Icon
                            ZStack {
                                Circle()
                                    .fill(getSegmentColor(segment.type))
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: getSegmentIcon(segment.type))
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                            
                            // Occupancy percentage below icon for transit modes (except top display)
                            if segment.type != .walk && segment.type != .bike && segment.occupancy != nil {
                                Text("\(segment.occupancy!)%")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.top, 4)
                            }
                            
                            // Mode name
                            Text(getSegmentName(segment.type))
                                .font(.subheadline)
                                .foregroundColor(getSegmentColor(segment.type))
                                .padding(.top, 2)
                            
                            // Time
                            Text("\(segment.time) min")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 2)
                        }
                        .frame(width: 70)
                    }
                }
                .padding(.vertical, 5)
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.vertical, 5)
                
                // CO2 and Select button
                HStack {
                    HStack(spacing: 5) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                        Text("CO₂: \(String(format: "%.1f", route.co2Saved)) kg saved")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: onSelect) {
                        Capsule()
                            .fill(Color.white)
                            .frame(width: 80, height: 40)
                    }
                }
            }
            .padding()
        }
    }
    
    private func tagColor(for tag: RouteTag) -> Color {
        switch tag {
        case .fastest: return Color.green
        case .cheapest: return Color.blue
        case .accessible: return Color.orange
        case .recommended: return Color.purple
        }
    }
    
    private func getSegmentIcon(_ type: TransportType) -> String {
        return type.icon
    }
    
    private func getSegmentColor(_ type: TransportType) -> Color {
        switch type.color {
        case "blue": return .blue
        case "green": return .green
        case "red": return .red
        case "brown": return Color(red: 0.6, green: 0.4, blue: 0.2)
        case "orange": return .orange
        default: return .gray
        }
    }
    
    private func getSegmentName(_ type: TransportType) -> String {
        return type.name
    }
}


// Helper extension for placeholder text
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    RoutesView()
}
