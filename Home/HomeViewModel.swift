import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var nearbyStations: [HomeModel.Station] = [
        HomeModel.Station(name: "Central Station", distance: 0.3, lines: [
            HomeModel.TransitLine(name: "Red", color: .red),
            HomeModel.TransitLine(name: "Blue", color: .blue)
        ]),
        HomeModel.Station(name: "Market Square", distance: 0.5, lines: [
            HomeModel.TransitLine(name: "Green", color: .green)
        ]),
        HomeModel.Station(name: "Riverside", distance: 0.7, lines: [
            HomeModel.TransitLine(name: "Yellow", color: .yellow),
            HomeModel.TransitLine(name: "Blue", color: .blue)
        ]),
        HomeModel.Station(name: "Tech District", distance: 0.9, lines: [
            HomeModel.TransitLine(name: "Red", color: .red)
        ])
    ]
    
    @Published var favoriteRoutes: [HomeModel.Route] = [
        HomeModel.Route(from: "Home", to: "Work", time: "8:15 AM", occupancy: 65),
        HomeModel.Route(from: "Work", to: "Home", time: "5:30 PM", occupancy: 85)
    ]
    
    @Published var currentTrip: HomeModel.Trip? = HomeModel.Trip(
        route: "Home → Work",
        departure: "8:15 AM",
        eta: "8:40 AM",
        stops: [
            HomeModel.TripStop(name: "Current Location", status: .current, detail: "On Central Avenue"),
            HomeModel.TripStop(name: "Tech District Station", status: .upcoming, detail: "Arriving in 12 min"),
            HomeModel.TripStop(name: "Work", status: .upcoming, detail: "Final destination")
        ],
        vehicleOccupancy: 65,
        busNumber: "42",
        co2Saved: 0.8
    )
    
    @Published var fromLocation: String = "Home"
    @Published var toLocation: String = ""
}
