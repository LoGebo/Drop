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

enum TransportType: String, Codable {
    case WALK = "WALK"
    case BUS = "BUS"
    case METRO = "METRO"
    case MINIBUS = "MINIBUS"
    
    var iconName: String {
        switch self {
        case .WALK:
            return "figure.walk"
        case .BUS:
            return "bus"
        case .METRO:
            return "tram"
        case .MINIBUS:
            return "bus"
        }
    }
    
    var description: String {
        switch self {
        case .WALK:
            return "Walking"
        case .BUS:
            return "Bus"
        case .METRO:
            return "Metro"
        case .MINIBUS:
            return "Minibus"
        }
    }
}

enum RoutePreference: String, Codable {
    case FASTEST = "FASTEST"
    case LESS_TRANSFERS = "LESS_TRANSFERS"
    case LESS_WALKING = "LESS_WALKING"
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
    var departureTime: Date
    var arrivalTime: Date
    var occupancy: Int
    
    enum CodingKeys: String, CodingKey {
        case totalTime, totalDistance, totalCost, transfers, segments
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalTime = try container.decode(Int.self, forKey: .totalTime)
        totalDistance = try container.decode(Double.self, forKey: .totalDistance)
        totalCost = try container.decode(Double.self, forKey: .totalCost)
        transfers = try container.decode(Int.self, forKey: .transfers)
        segments = try container.decode([RouteSegment].self, forKey: .segments)
        
        // Set calculated properties
        departureTime = Date()
        arrivalTime = departureTime.addingTimeInterval(TimeInterval(totalTime * 60))
        occupancy = Int.random(in: 60...85) // Simulated occupancy
    }
}

struct RouteSegment: Codable, Identifiable {
    let id = UUID()
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
    
    enum CodingKeys: String, CodingKey {
        case from, to, type, time, cost, distance, waitTime, fromName, toName, path, description, routeId, routeName, vehicleId
    }
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
