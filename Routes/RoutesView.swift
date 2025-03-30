//
//  RoutesView.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import SwiftUI
import MapKit

struct RoutesView: View {
    @StateObject private var viewModel = RoutesViewModel()
    @State private var searchText = ""
    @State private var showResults = false
    @State private var showSearchResults = false
    @State private var selectedDestination: MKLocalSearchCompletion?
    @State private var showLocationPicker = false
    @State private var showDestinationPicker = false
    @State private var manualLocation: CLLocation?
    @State private var destinationLocation: CLLocation?
    @State private var isShowingSheet = false
    @State private var isShowingDirections = false
    @State private var showOccupancyChart = false
    @State private var selectedVehicle: MetroVehicle?
    
    private var hasValidLocations: Bool {
        return (manualLocation != nil || viewModel.currentLocation != nil) && destinationLocation != nil
    }
    
    private func fetchRouteIfNeeded() {
        guard hasValidLocations else { return }
        Task {
            if let destination = destinationLocation {
                let location = Location(
                    latitude: destination.coordinate.latitude,
                    longitude: destination.coordinate.longitude
                )
                await viewModel.fetchRoute(from: manualLocation, to: location)
                withAnimation(.spring()) {
                    showResults = viewModel.currentRoute != nil
                    showSearchResults = false
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // BACKGROUND MAP
                RoutesMapBackgroundView()
                    .environmentObject(viewModel)
                    .ignoresSafeArea()
                
                // Fondo para la tab bar - REPOSICIONADO DEBAJO DE TODO
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color(UIColor.systemBackground)) // Usar systemBackground para adaptarse al modo oscuro
                        .frame(height: 120)
                        .offset(y: 30)
                }
                .ignoresSafeArea()
                
                // CONTENT OVER MAP
                VStack(spacing: 0) {
                    // Search Form en la parte superior
                    searchFormView
                        .padding(.horizontal)
                        .padding(.top, 0)
                        .padding(.bottom, 16)
                    
                    Spacer(minLength: 0)
                    
                    // Panel de resultados si es necesario
                    if showResults, let route = viewModel.currentRoute {
                        ScrollView {
                            VStack(spacing: 12) {
                                // Errores si existen
                                if let error = viewModel.locationError {
                                    Text(error)
                                        .foregroundColor(.red)
                                        .padding()
                                }
                                
                                if let error = viewModel.error {
                                    Text(error)
                                        .foregroundColor(.red)
                                        .padding()
                                        .background(Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(12)
                                }
                                
                                // Información de la ruta
                                routeHeaderView(route: route)
                                routeTimelineView(route: route)
                                achievementsView(route: route)
                                
                                // Espacio adicional para evitar que el contenido quede bajo el TabBar
                                Spacer()
                                    .frame(height: 50)
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(UIColor.systemBackground).opacity(0.95))
                        )
                        .transition(.move(edge: .bottom))
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal)
                .padding(.bottom, isShowingSheet ? 0 : 10)
            }
            .navigationBarTitleDisplayMode(.inline)
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
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerView(
                    selectedLocation: $manualLocation,
                    initialLocation: manualLocation ?? viewModel.currentLocation
                )
            }
            .sheet(isPresented: $showDestinationPicker) {
                LocationPickerView(
                    selectedLocation: $destinationLocation,
                    initialLocation: destinationLocation
                )
            }
            .sheet(isPresented: $isShowingSheet) {
                // ... existing code ...
            }
            .sheet(isPresented: $showOccupancyChart, onDismiss: {
                selectedVehicle = nil
            }) {
                if let vehicle = selectedVehicle {
                    metroOccupancySheet(vehicle: vehicle)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
            }
            .onChange(of: manualLocation, initial: false) { oldValue, newValue in
                fetchRouteIfNeeded()
            }
            .onChange(of: destinationLocation, initial: false) { oldValue, newValue in
                fetchRouteIfNeeded()
            }
            .onReceive(NotificationCenter.default.publisher(for: .metroVehicleSelected)) { notification in
                if let vehicle = notification.object as? MetroVehicle {
                    selectedVehicle = vehicle
                    showOccupancyChart = true
                }
            }
        }
        .accentColor(.primary)
        .background(.white)
        .ignoresSafeArea(edges: .bottom)
    }
    
    // MARK: - Componentes de UI
    
    private var searchFormView: some View {
        VStack(spacing: 12) {
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
                
                VStack(spacing: 8) {
                    Button(action: {
                        showLocationPicker = true
                    }) {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.green)
                            if let location = manualLocation ?? viewModel.currentLocation {
                                Text("Selected Location")
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(String(format: "%.4f, %.4f",
                                          location.coordinate.latitude,
                                          location.coordinate.longitude))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            } else {
                                Text("Set Current Location")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(12)
                    .onAppear {
                        viewModel.requestLocationPermission()
                    }
                    
                    Button(action: {
                        showDestinationPicker = true
                    }) {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.gray)
                            if let location = destinationLocation {
                                Text("Selected Destination")
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(String(format: "%.4f, %.4f",
                                          location.coordinate.latitude,
                                          location.coordinate.longitude))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            } else {
                                Text("Set Destination")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(12)
                }
            }
            
            Button(action: {
                fetchRouteIfNeeded()
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
            .padding(.vertical, 14)
            .background(Color.green)
            .foregroundColor(.black)
            .cornerRadius(15)
            .buttonStyle(.scale)
            .disabled(!hasValidLocations)
        }
        .padding(12)
        .background(Color(UIColor.secondarySystemBackground).opacity(0.95))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func routeHeaderView(route: RouteData) -> some View {
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
                        Text(selectedDestination?.title ?? "Destination")
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
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    private func routeTimelineView(route: RouteData) -> some View {
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
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    private func achievementsView(route: RouteData) -> some View {
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
                    value: String(format: "%.1f", viewModel.co2Saved),
                    label: "kg CO₂ Saved",
                    color: .green
                )
                
                AchievementView(
                    icon: "flame.fill",
                    value: "\(viewModel.calories)",
                    label: "Calories",
                    color: .orange
                )
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

// MARK: - Metro Occupancy Chart Sheet
extension RoutesView {
    @ViewBuilder
    func metroOccupancySheet(vehicle: MetroVehicle) -> some View {
        OccupancyChartView(vehicle: vehicle)
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

// MARK: - Notification
extension Notification.Name {
    static let metroVehicleSelected = Notification.Name("metroVehicleSelected")
}

#Preview {
    RoutesView()
}
