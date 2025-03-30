import Foundation
import Combine
import MapKit
import SwiftUI

class MetroMapViewModel: ObservableObject {
    private let service = RealTimeMetroService()
    private var cancellables = Set<AnyCancellable>()
    
    // Estado de los vehículos
    @Published var vehicles: [String: MetroVehicle] = [:]
    @Published var selectedVehicle: MetroVehicle?
    @Published var showOccupancyChart = false
    @Published var connectionStatus: RealTimeMetroService.ConnectionStatus = .disconnected
    @Published var connectionError: Error?
    
    init() {
        setupSubscriptions()
        
        // En entorno de desarrollo, iniciar simulación de datos
        #if DEBUG
        service.simulateVehicleUpdates()
        #endif
    }
    
    private func setupSubscriptions() {
        // Suscripción a actualizaciones de vehículos
        service.vehicleUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] vehicle in
                self?.handleVehicleUpdate(vehicle)
            }
            .store(in: &cancellables)
        
        // Suscripción a cambios de estado de conexión
        service.connectionStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.connectionStatus = status
            }
            .store(in: &cancellables)
        
        // Suscripción a errores de conexión
        service.connectionErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.connectionError = error
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Métodos públicos
    
    func connect() {
        service.connect()
    }
    
    func disconnect() {
        service.disconnect()
    }
    
    func subscribeToVehicle(id: String? = nil) {
        service.subscribeTo(vehicleId: id)
    }
    
    func unsubscribeFromVehicle(id: String? = nil) {
        service.unsubscribeFrom(vehicleId: id)
    }
    
    func subscribeToLine(id: String) {
        service.subscribeTo(lineId: id)
    }
    
    func selectVehicle(_ vehicle: MetroVehicle) {
        selectedVehicle = vehicle
        showOccupancyChart = true
        
        // Mostrar un mensaje en consola para verificar
        print("Vehículo seleccionado: \(vehicle.id) - Ocupación: \(vehicle.occupancy)%")
        
        // Notificar a otras vistas que un vehículo ha sido seleccionado
        NotificationCenter.default.post(
            name: .metroVehicleSelected,
            object: vehicle
        )
    }
    
    func toggleOccupancyChart() {
        showOccupancyChart.toggle()
    }
    
    // MARK: - Métodos privados
    
    private func handleVehicleUpdate(_ vehicle: MetroVehicle) {
        // Limpiar vehículos antiguos antes de agregar el nuevo
        // Esto asegura que solo tengamos un vehículo en el mapa
        vehicles.removeAll()
        
        // Añadir o actualizar el vehículo actual
        vehicles[vehicle.id] = vehicle
        
        // Si este vehículo está seleccionado actualmente, actualizar el selectedVehicle
        if let selectedVehicle = selectedVehicle, selectedVehicle.id == vehicle.id {
            self.selectedVehicle = vehicle
        }
    }
}

// MARK: - OccupancyChartView
struct OccupancyChartView: View {
    let vehicle: MetroVehicle
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Train Occupancy Status")
                .font(.headline)
                .padding(.top)
            
            HStack(spacing: 40) {
                // Circular progress indicator
                ZStack {
                    Circle()
                        .stroke(
                            Color.gray.opacity(0.2),
                            lineWidth: 15
                        )
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(vehicle.occupancy) / 100.0)
                        .stroke(
                            Color(uiColor: vehicle.occupancyColor),
                            style: StrokeStyle(
                                lineWidth: 15,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut, value: vehicle.occupancy)
                    
                    VStack {
                        Text("\(vehicle.occupancy)%")
                            .font(.system(size: 28, weight: .bold))
                        Text(vehicle.occupancyDescription)
                            .font(.system(size: 15))
                            .foregroundColor(Color(uiColor: vehicle.occupancyColor))
                    }
                }
                .frame(width: 130, height: 130)
                
                // Vehicle information
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(label: "Train ID:", value: vehicle.id)
                    InfoRow(label: "Route:", value: "Line \(vehicle.routeId)")
                    InfoRow(label: "Status:", value: vehicle.occupancyDescription)
                    InfoRow(label: "Updated:", value: timeAgoSince(vehicle.updateTime))
                }
                .padding(.leading)
            }
            .padding(.vertical)
            
            Text("The occupancy level indicates how crowded this train is in real-time. Consider waiting for a less crowded train if the occupancy is high.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
    
    // Helper function to format time ago
    func timeAgoSince(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day)d ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)h ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)m ago"
        } else if let second = components.second, second > 0 {
            return "\(second)s ago"
        } else {
            return "Just now"
        }
    }
}

// MARK: - InfoRow
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .font(.system(size: 14))
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
        }
    }
} 