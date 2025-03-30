//
//  RoutesModel.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import Foundation

// MARK: - API Models
struct RouteRequest: Codable {
    let origin: Location
    let destination: Location
    let transportTypes: [TransportType]
    let maxWalkingDistance: Int
    let routePreference: RoutePreference
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

enum TransportType: String, Codable, CaseIterable {
    case WALK = "WALK"
    case BUS = "BUS"
    case METRO = "METRO"
    case MINIBUS = "MINIBUS"
    
    var iconName: String {
        switch self {
        case .WALK: return "figure.walk"
        case .BUS: return "bus.fill"
        case .METRO: return "tram.fill"
        case .MINIBUS: return "van.fill"
        }
    }
    
    var description: String {
        switch self {
        case .WALK: return "Walk"
        case .BUS: return "Bus"
        case .METRO: return "Metro"
        case .MINIBUS: return "Minibus"
        }
    }
}

enum RoutePreference: String, Codable {
    case FASTEST
    case CHEAPEST
    case LEAST_OCCUPIED
}

// MARK: - Response Models
struct RouteResponse: Codable {
    let success: Bool
    let data: RouteData
}

struct RouteData: Codable {
    let totalTime: Int
    let totalDistance: Double
    let totalCost: Double
    let transfers: Int
    let segments: [RouteSegment]
}

struct RouteSegment: Codable, Identifiable {
    var id: UUID { UUID() } // Computed property since we can't decode it
    let from: String
    let to: String
    let type: TransportType
    let time: Int
    let cost: Double
    let distance: Double
    let waitTime: Int
    let fromName: String
    let toName: String
    let path: [Location]
    let description: String
    let routeId: String?
    let routeName: String?
    let vehicleId: String?
}

// MARK: - View Models
struct RouteViewModel {
    let origin: String
    let destination: String
    let departureTime: Date
    let arrivalTime: Date
    let segments: [RouteSegment]
    let totalTime: Int
    let totalDistance: Double
    let totalCost: Double
    let transfers: Int
    
    // Mock data for additional metrics
    var occupancy: Int = Int.random(in: 30...90)
    var co2Saved: Double {
        // Mock calculation based on distance and occupancy
        return (totalDistance * Double(occupancy)) / 1000
    }
    var calories: Int {
        // Mock calculation based on walking segments
        let walkingSegments = segments.filter { $0.type == .WALK }
        return walkingSegments.reduce(0) { $0 + Int($1.distance * 0.3) }
    }
}
