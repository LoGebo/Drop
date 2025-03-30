//
//  HomeModel.swift
//  Drop
//
//  Created by Dario on 29/03/25.
//

import SwiftUI
import Foundation

struct Station: Identifiable {
    let id = UUID()
    let name: String
    let distance: Double
    let lines: [TransitLine]
}

struct TransitLine: Identifiable {
    let id = UUID()
    let name: String
    let color: LineColor
}

enum LineColor {
    case red, blue, green, yellow
}

struct Route: Identifiable {
    let id = UUID()
    let from: String
    let to: String
    let time: String
    let occupancy: Int
}

struct Trip {
    let route: String
    let departure: String
    let eta: String
    let stops: [TripStop]
    let vehicleOccupancy: Int
    let busNumber: String
    let co2Saved: Double
}

struct TripStop {
    let name: String
    let status: StopStatus
    let detail: String
}

enum StopStatus {
    case completed
    case current
    case upcoming
}

struct HomeModel: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HomeModel()
}
