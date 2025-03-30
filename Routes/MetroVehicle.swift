import Foundation
import MapKit
import SwiftUI

class MetroVehicle: NSObject, MKAnnotation, Identifiable, Codable {
    let id: String
    var location: Location
    var occupancy: Int
    let routeId: String
    let lastUpdate: Int64
    var previousCoordinate: CLLocationCoordinate2D?
    
    struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }
    
    init(id: String, location: Location, occupancy: Int, routeId: String, lastUpdate: Int64) {
        self.id = id
        self.location = location
        self.occupancy = occupancy
        self.routeId = routeId
        self.lastUpdate = lastUpdate
        super.init()
    }
    
    // Conformidad con MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
    var title: String? {
        return "Train \(id)"
    }
    
    var subtitle: String? {
        return "Line \(routeId)"
    }
    
    // MARK: - Accesors útiles
    var latitude: Double {
        return location.latitude
    }
    
    var longitude: Double {
        return location.longitude
    }
    
    // Convertir timestamp a Date
    var updateTime: Date {
        return Date(timeIntervalSince1970: Double(lastUpdate) / 1000.0)
    }
    
    // Obtener descripción de la ocupación
    var occupancyDescription: String {
        switch occupancy {
        case 0..<30:
            return "Low"
        case 30..<60:
            return "Medium"
        case 60..<85:
            return "High"
        default:
            return "Very High"
        }
    }
    
    // Obtener color según la ocupación
    var occupancyColor: UIColor {
        switch occupancy {
        case 0..<30:
            return .systemGreen
        case 30..<60:
            return .systemYellow
        case 60..<85:
            return .systemOrange
        default:
            return .systemRed
        }
    }
    
    // Obtener color según la línea del metro
    var lineColor: UIColor {
        switch routeId {
        case "L1":
            return .systemYellow
        case "L2":
            return .systemGreen
        case "L3":
            return .systemOrange
        default:
            return .systemBlue
        }
    }
    
    // MARK: - Conformidad con Codable
    enum CodingKeys: String, CodingKey {
        case id, location, occupancy, routeId, lastUpdate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        location = try container.decode(Location.self, forKey: .location)
        occupancy = try container.decode(Int.self, forKey: .occupancy)
        routeId = try container.decode(String.self, forKey: .routeId)
        lastUpdate = try container.decode(Int64.self, forKey: .lastUpdate)
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(location, forKey: .location)
        try container.encode(occupancy, forKey: .occupancy)
        try container.encode(routeId, forKey: .routeId)
        try container.encode(lastUpdate, forKey: .lastUpdate)
    }
    
    // Actualizar posición directamente
    func updatePosition(to newCoordinate: CLLocationCoordinate2D) {
        previousCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        location = Location(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
    }
    
    // MARK: - Actualización
    func update(with newVehicle: MetroVehicle) {
        // Guardar la coordenada anterior antes de actualizar
        previousCoordinate = self.coordinate
        
        // Actualizar propiedades
        self.location = newVehicle.location
        self.occupancy = newVehicle.occupancy
        // No actualizamos routeId ya que es fijo
        // No actualizamos id ya que es fijo
    }
} 