//
//  RoutesViewModel.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

@MainActor
class RoutesViewModel: NSObject, ObservableObject {
    @Published var currentLocation: CLLocation?
    @Published var currentRoute: RouteData?
    @Published var isLoading = false
    @Published var error: String?
    @Published var locationError: String?
    @Published var searchResults: [MKLocalSearchCompletion] = []
    
    private let locationManager = CLLocationManager()
    private let searchCompleter = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .pointOfInterest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func searchLocations(_ query: String) {
        searchCompleter.queryFragment = query
    }
    
    var calories: Int {
        guard let route = currentRoute else { return 0 }
        let walkingSegments = route.segments.filter { $0.type == .WALK }
        let totalWalkingDistance = walkingSegments.reduce(0) { $0 + $1.distance }
        // Assuming average walking speed and calories burned per km
        let caloriesPerKm = 60.0 // Average calories burned per km walking
        return Int(totalWalkingDistance / 1000.0 * caloriesPerKm)
    }
    
    var co2Saved: Double {
        guard let route = currentRoute else { return 0 }
        let publicTransportSegments = route.segments.filter { $0.type != .WALK }
        let totalDistance = publicTransportSegments.reduce(0) { $0 + $1.distance }
        // Average CO2 emissions saved per km using public transport vs car
        let co2SavedPerKm = 0.14 // kg of CO2 saved per km
        return (totalDistance / 1000.0) * co2SavedPerKm
    }
    
    func getLocationFromSearch(_ searchResult: MKLocalSearchCompletion) async -> Location? {
        let searchRequest = MKLocalSearch.Request(completion: searchResult)
        let search = MKLocalSearch(request: searchRequest)
        
        do {
            let response = try await search.start()
            if let item = response.mapItems.first {
                return Location(
                    latitude: item.placemark.coordinate.latitude,
                    longitude: item.placemark.coordinate.longitude
                )
            }
        } catch {
            self.error = "Error getting location details"
        }
        return nil
    }
    
    func fetchRoute(from manualLocation: CLLocation?, to destination: Location) async {
        let origin: Location
        if let manual = manualLocation {
            origin = Location(
                latitude: manual.coordinate.latitude,
                longitude: manual.coordinate.longitude
            )
        } else if let current = currentLocation {
            origin = Location(
                latitude: current.coordinate.latitude,
                longitude: current.coordinate.longitude
            )
        } else {
            error = "Current location not available"
            return
        }
        
        await fetchRoute(from: origin, to: destination)
    }
    
    func fetchRoute(from origin: Location, to destination: Location) async {
        isLoading = true
        error = nil
        
        do {
            // Reduce coordinate precision to 6 decimal places
            let request = RouteRequest(
                origin: Location(
                    latitude: Double(String(format: "%.6f", origin.latitude)) ?? origin.latitude,
                    longitude: Double(String(format: "%.6f", origin.longitude)) ?? origin.longitude
                ),
                destination: Location(
                    latitude: Double(String(format: "%.6f", destination.latitude)) ?? destination.latitude,
                    longitude: Double(String(format: "%.6f", destination.longitude)) ?? destination.longitude
                ),
                transportTypes: [.WALK, .METRO, .BUS, .MINIBUS],
                maxWalkingDistance: 500,
                routePreference: .FASTEST
            )
            
            let url = URL(string: "http://localhost:3000/api/mobile/route")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.timeoutInterval = 30
            
            let jsonData = try JSONEncoder().encode(request)
            print("Request JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
            
            // Print coordinates for debugging
            print("Origin: \(request.origin.latitude), \(request.origin.longitude)")
            print("Destination: \(request.destination.latitude), \(request.destination.longitude)")
            
            urlRequest.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            print("Response status code: \(httpResponse.statusCode)")
            print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            
            guard httpResponse.statusCode == 200 else {
                if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorMessage = errorJson["error"] as? String {
                    if errorMessage.contains("No se encontró una ruta") {
                        error = "No route found between these locations. Please try different locations or modify your preferences."
                    } else {
                        error = errorMessage
                    }
                } else {
                    error = "Server error: HTTP \(httpResponse.statusCode)"
                }
                return
            }
            
            let routeResponse = try JSONDecoder().decode(RouteResponse.self, from: data)
            currentRoute = routeResponse.data
        } catch {
            print("Error fetching route: \(error)")
            if let decodingError = error as? DecodingError {
                self.error = "Invalid response format: \(decodingError.localizedDescription)"
            } else {
                self.error = "Error fetching route: \(error.localizedDescription)"
            }
        }
        
        isLoading = false
    }
    
    // Helper function to calculate distance between two locations
    private func calculateDistance(from origin: Location, to destination: Location) -> Double {
        let originCoord = CLLocation(latitude: origin.latitude, longitude: origin.longitude)
        let destCoord = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        return originCoord.distance(from: destCoord)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}

extension RoutesViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error.localizedDescription
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            locationError = "Location access denied"
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}

extension RoutesViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.error = error.localizedDescription
    }
}
