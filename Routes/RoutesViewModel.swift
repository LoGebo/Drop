//
//  RoutesViewModel.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import Foundation
import SwiftUI

@MainActor
class RoutesViewModel: ObservableObject {
    @Published var currentRoute: RouteViewModel?
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiUrl = "http://localhost:3000/api/mobile/route"
    
    func fetchRoute(from originCoords: Location, to destinationCoords: Location) async {
        isLoading = true
        error = nil
        
        let request = RouteRequest(
            origin: originCoords,
            destination: destinationCoords,
            transportTypes: [.WALK, .BUS, .METRO],
            maxWalkingDistance: 800,
            routePreference: .FASTEST
        )
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            // Print the request JSON for debugging
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request JSON: \(jsonString)")
            }
            
            var urlRequest = URLRequest(url: URL(string: apiUrl)!)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
            let (data, httpResponse) = try await URLSession.shared.data(for: urlRequest)
            
            // Print response details for debugging
            if let httpResponse = httpResponse as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response data: \(responseString)")
            }
            
            let routeResponse = try JSONDecoder().decode(RouteResponse.self, from: data)
            
            if routeResponse.success {
                let now = Date()
                let arrivalTime = now.addingTimeInterval(TimeInterval(routeResponse.data.totalTime * 60))
                
                currentRoute = RouteViewModel(
                    origin: routeResponse.data.segments.first?.fromName ?? "Origin",
                    destination: routeResponse.data.segments.last?.toName ?? "Destination",
                    departureTime: now,
                    arrivalTime: arrivalTime,
                    segments: routeResponse.data.segments,
                    totalTime: routeResponse.data.totalTime,
                    totalDistance: routeResponse.data.totalDistance,
                    totalCost: routeResponse.data.totalCost,
                    transfers: routeResponse.data.transfers
                )
            } else {
                error = "Failed to get route"
            }
        } catch {
            print("Error details: \(error)")
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // Helper function to format time
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Helper function to format distance
    func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return String(format: "%.2f m", distance)
        } else {
            return String(format: "%.2f km", distance / 1000)
        }
    }
    
    // Helper function to format duration
    func formatDuration(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours)h \(remainingMinutes)min"
        }
    }
}
