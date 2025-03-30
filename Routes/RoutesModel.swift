//
//  RoutesModel.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import Foundation

struct TransitRoute: Identifiable {
    let id = UUID()
    let from: String
    let to: String
    let totalTime: Int
    let price: Double
    let co2Saved: Double
    let segments: [RouteSegment]
    let tag: RouteTag?
}

struct RouteSegment: Identifiable {
    let id = UUID()
    let type: TransportType
    let time: Int
    let occupancy: Int?
}

enum TransportType {
    case express
    case bus
    case subway
    case walk
    case bike
    
    var icon: String {
        switch self {
        case .express: return "tram.fill"
        case .bus: return "bus.fill"
        case .subway: return "subway.fill"
        case .walk: return "figure.walk"
        case .bike: return "bicycle"
        }
    }
    
    var color: String {
        switch self {
        case .express: return "blue"
        case .bus: return "green"
        case .subway: return "red"
        case .walk: return "brown"
        case .bike: return "orange"
        }
    }
    
    var name: String {
        switch self {
        case .express: return "Express"
        case .bus: return "Bus"
        case .subway: return "Subway"
        case .walk: return "Walk"
        case .bike: return "Bike"
        }
    }
}

enum RouteTag: String {
    case fastest = "Fastest"
    case cheapest = "Cheapest"
    case accessible = "Accessible"
    case recommended = "Recommended"
}
