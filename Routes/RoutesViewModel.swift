//
//  RoutesViewModel.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import Foundation
import SwiftUI

class RoutesViewModel: ObservableObject {
    @Published var currentLocation: String = "Current location"
    @Published var destination: String = ""
    @Published var isSearching: Bool = false
    @Published var showingResults: Bool = false
    
    @Published var routes: [TransitRoute] = []
    
    init() {
        // Sample routes for demo
        generateSampleRoutes()
    }
    
    func findRoutes() {
        isSearching = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isSearching = false
            self.showingResults = true
        }
    }
    
    func generateSampleRoutes() {
        routes = [
            TransitRoute(
                from: "Downtown",
                to: "Uptown",
                totalTime: 35,
                price: 4.50,
                co2Saved: 0.5,
                segments: [
                    RouteSegment(type: .express, time: 40, occupancy: 85),
                    RouteSegment(type: .walk, time: 10, occupancy: nil)
                ],
                tag: .fastest
            ),
            TransitRoute(
                from: "Downtown",
                to: "Uptown",
                totalTime: 55,
                price: 4.00,
                co2Saved: 0.7,
                segments: [
                    RouteSegment(type: .bus, time: 30, occupancy: 65),
                    RouteSegment(type: .bus, time: 15, occupancy: 45),
                    RouteSegment(type: .walk, time: 10, occupancy: nil)
                ],
                tag: .accessible
            )
        ]
    }
    
    func selectRoute(_ route: TransitRoute) {
        // Handle route selection
        print("Selected route: \(route.from) to \(route.to)")
    }
    
    func compareRoutes() {
        // Handle route comparison
        print("Compare routes")
    }
    
    func goToMap() {
        // Handle map navigation
        print("Navigate to map")
    }
}
