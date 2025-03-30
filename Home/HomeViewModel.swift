import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var nearbyStations: [Station] = [
        Station(name: "Central Station", distance: 0.3, lines: [
            TransitLine(name: "Red", color: .red),
            TransitLine(name: "Blue", color: .blue)
        ]),
        Station(name: "Market Square", distance: 0.5, lines: [
            TransitLine(name: "Green", color: .green)
        ]),
        Station(name: "Riverside", distance: 0.7, lines: [
            TransitLine(name: "Yellow", color: .yellow),
            TransitLine(name: "Blue", color: .blue)
        ]),
        Station(name: "Tech District", distance: 0.9, lines: [
            TransitLine(name: "Red", color: .red)
        ])
    ]
    
    @Published var favoriteRoutes: [Route] = [
        Route(from: "Home", to: "Work", time: "8:15 AM", occupancy: 65),
        Route(from: "Work", to: "Home", time: "5:30 PM", occupancy: 85)
    ]
    
    @Published var currentTrip: Trip? = Trip(
        route: "Home → Work",
        departure: "8:15 AM",
        eta: "8:40 AM",
        stops: [
            TripStop(name: "Current Location", status: .current, detail: "On Central Avenue"),
            TripStop(name: "Tech District Station", status: .upcoming, detail: "Arriving in 12 min"),
            TripStop(name: "Work", status: .upcoming, detail: "Final destination")
        ],
        vehicleOccupancy: 65,
        busNumber: "42",
        co2Saved: 0.8
    )
    
    @Published var fromLocation: String = "Home"
    @Published var toLocation: String = ""
}
