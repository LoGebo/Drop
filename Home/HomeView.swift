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
        ZStack {
            // Mapa de fondo con las líneas del metro
            HomeMapBackgroundView()
                .ignoresSafeArea()
            
            // Contenido principal
            NavigationStack {
                backgroundScrollView
                    .navigationTitle("Drop")
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
    
    private func currentTripSection(trip: HomeModel.Trip) -> some View {
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
            NavigationLink(destination: EmergencyView()) {
                Label {
                    Text("Emergency Assistance")
                        .font(.body.weight(.semibold))
                } icon: {
                    Image(systemName: "bell.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            .buttonStyle(.scale)
            
            NavigationLink(destination: ReportView()) {
                Label {
                    Text("Report an Issue")
                        .font(.body.weight(.semibold))
                } icon: {
                    Image(systemName: "exclamationmark.bubble.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(UIColor.secondarySystemBackground))
                .foregroundColor(.primary)
                .cornerRadius(15)
            }
            .buttonStyle(.scale)
            
            Text("Tap in case of emergency to alert authorities")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
    
    var backgroundScrollView: some View {
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
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(UIColor.systemBackground).opacity(0.92))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
                .ignoresSafeArea()
        )
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
    let station: HomeModel.Station
    
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
                            .background(line.color)
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
}

struct FavoriteRouteCard: View {
    let route: HomeModel.Route
    
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
    let trip: HomeModel.Trip
    
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
    let stop: HomeModel.TripStop
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

// MARK: - Map Background
struct HomeMapBackgroundView: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    
    // Coordenadas línea 1
    private let metroLine1Coordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.6790443, longitude: -100.2414310),
        CLLocationCoordinate2D(latitude: 25.6792699, longitude: -100.2433402),
        CLLocationCoordinate2D(latitude: 25.6795043, longitude: -100.2454920),
        CLLocationCoordinate2D(latitude: 25.6797233, longitude: -100.2473393),
        CLLocationCoordinate2D(latitude: 25.6798275, longitude: -100.2480310),
        CLLocationCoordinate2D(latitude: 25.6832309, longitude: -100.2794460),
        CLLocationCoordinate2D(latitude: 25.6839868, longitude: -100.2969920),
        CLLocationCoordinate2D(latitude: 25.6861218, longitude: -100.3169480),
        CLLocationCoordinate2D(latitude: 25.6875702, longitude: -100.3394937),
        CLLocationCoordinate2D(latitude: 25.6893801, longitude: -100.3436221),
        CLLocationCoordinate2D(latitude: 25.6987474, longitude: -100.3431880),
        CLLocationCoordinate2D(latitude: 25.7059242, longitude: -100.3424003),
        CLLocationCoordinate2D(latitude: 25.7233152, longitude: -100.3425450),
        CLLocationCoordinate2D(latitude: 25.7321485, longitude: -100.3472600),
        CLLocationCoordinate2D(latitude: 25.7418717, longitude: -100.3549080),
        CLLocationCoordinate2D(latitude: 25.7483890, longitude: -100.3616380),
        CLLocationCoordinate2D(latitude: 25.7544675, longitude: -100.3655645)
    ]

    // Coordenadas línea 2
    private let metroLine2Coordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.7687766, longitude: -100.2928846),
        CLLocationCoordinate2D(latitude: 25.7607641, longitude: -100.2951015),
        CLLocationCoordinate2D(latitude: 25.7532513, longitude: -100.2978342),
        CLLocationCoordinate2D(latitude: 25.7463032, longitude: -100.3003184),
        CLLocationCoordinate2D(latitude: 25.7426889, longitude: -100.3016192),
        CLLocationCoordinate2D(latitude: 25.7322149, longitude: -100.3054117),
        CLLocationCoordinate2D(latitude: 25.7170160, longitude: -100.3108590),
        CLLocationCoordinate2D(latitude: 25.7052711, longitude: -100.3150973),
        CLLocationCoordinate2D(latitude: 25.6986997, longitude: -100.3168353),
        CLLocationCoordinate2D(latitude: 25.6901726, longitude: -100.3167621),
        CLLocationCoordinate2D(latitude: 25.6818769, longitude: -100.3174807),
        CLLocationCoordinate2D(latitude: 25.6741416, longitude: -100.3185592),
        CLLocationCoordinate2D(latitude: 25.6677517, longitude: -100.3102020)
    ]

    // Coordenadas línea 3
    private let metroLine3Coordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.7147319, longitude: -100.2721709),
        CLLocationCoordinate2D(latitude: 25.7081248, longitude: -100.2817140),
        CLLocationCoordinate2D(latitude: 25.7032038, longitude: -100.2887021),
        CLLocationCoordinate2D(latitude: 25.6946223, longitude: -100.2952712),
        CLLocationCoordinate2D(latitude: 25.6882480, longitude: -100.2962444),
        CLLocationCoordinate2D(latitude: 25.6778869, longitude: -100.2976580),
        CLLocationCoordinate2D(latitude: 25.6696848, longitude: -100.2987837),
        CLLocationCoordinate2D(latitude: 25.6683398, longitude: -100.2996454),
        CLLocationCoordinate2D(latitude: 25.6669596, longitude: -100.3021769),
        CLLocationCoordinate2D(latitude: 25.6667067, longitude: -100.3048954),
        CLLocationCoordinate2D(latitude: 25.6677517, longitude: -100.3102020)
    ]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = false
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsBuildings = false
        mapView.showsTraffic = false
        mapView.delegate = context.coordinator
        
        // Centrar en Monterrey
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.6866, longitude: -100.3161),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        mapView.setRegion(region, animated: false)
        
        // Estilo de mapa según el tema
        configureMapStyle(mapView)
        
        // Agregar las líneas del metro
        addMetroLines(to: mapView)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        configureMapStyle(uiView)
    }
    
    private func configureMapStyle(_ mapView: MKMapView) {
        if #available(iOS 16.0, *) {
            // Usar un estilo más sutil dependiendo del tema
            mapView.preferredConfiguration = colorScheme == .dark 
                ? MKStandardMapConfiguration(elevationStyle: .flat, emphasisStyle: .muted)
                : MKStandardMapConfiguration(elevationStyle: .flat, emphasisStyle: .muted)
        }
    }
    
    private func addMetroLines(to mapView: MKMapView) {
        // Línea 1 (Amarilla)
        let line1 = MKPolyline(coordinates: metroLine1Coordinates, count: metroLine1Coordinates.count)
        line1.title = "Line1"
        mapView.addOverlay(line1, level: .aboveRoads)
        
        // Línea 2 (Verde)
        let line2 = MKPolyline(coordinates: metroLine2Coordinates, count: metroLine2Coordinates.count)
        line2.title = "Line2"
        mapView.addOverlay(line2, level: .aboveRoads)
        
        // Línea 3 (Naranja)
        let line3 = MKPolyline(coordinates: metroLine3Coordinates, count: metroLine3Coordinates.count)
        line3.title = "Line3"
        mapView.addOverlay(line3, level: .aboveRoads)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(colorScheme: colorScheme)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        let colorScheme: ColorScheme
        
        init(colorScheme: ColorScheme) {
            self.colorScheme = colorScheme
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                
                // Color según la línea (ajustado para mayor contraste según el tema)
                if polyline.title == "Line1" {
                    renderer.strokeColor = colorScheme == .dark ? .yellow : .systemYellow
                } else if polyline.title == "Line2" {
                    renderer.strokeColor = colorScheme == .dark ? .green : .systemGreen
                } else if polyline.title == "Line3" {
                    renderer.strokeColor = colorScheme == .dark ? .orange : .systemOrange
                } else {
                    renderer.strokeColor = .blue
                }
                
                renderer.lineWidth = 5.0
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

#Preview {
    MainTabView()
}
