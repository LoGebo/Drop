import Foundation
import Combine
import CoreLocation

// Simulación local de Socket.IO para evitar dependencias externas
class SocketManager {
    let socketURL: URL
    let config: [String: Any]
    
    init(socketURL: URL, config: [String: Any]) {
        self.socketURL = socketURL
        self.config = config
    }
    
    var defaultSocket: SocketIOClient {
        return SocketIOClient(manager: self)
    }
}

class SocketIOClient {
    let manager: SocketManager
    private var eventHandlers: [String: [(Any, SocketAckEmitter) -> Void]] = [:]
    private var clientEventHandlers: [String: [(Any, SocketAckEmitter) -> Void]] = [:]
    private var isConnected = false
    private var timer: Timer?
    
    init(manager: SocketManager) {
        self.manager = manager
    }
    
    enum ClientEvent: String {
        case connect
        case disconnect
        case error
        case reconnect
    }
    
    func on(_ event: String, callback: @escaping (Any, SocketAckEmitter) -> Void) {
        if eventHandlers[event] == nil {
            eventHandlers[event] = []
        }
        eventHandlers[event]?.append(callback)
    }
    
    func on(clientEvent: ClientEvent, callback: @escaping ([Any], SocketAckEmitter) -> Void) {
        let event = clientEvent.rawValue
        if clientEventHandlers[event] == nil {
            clientEventHandlers[event] = []
        }
        clientEventHandlers[event]?.append { data, ack in
            callback([data], ack)
        }
    }
    
    func emit(_ event: String, _ items: Any...) {
        print("📡 Emitiendo evento: \(event) con datos: \(items)")
        // En una simulación real, aquí enviaríamos datos al servidor
    }
    
    func connect() {
        // Simulación de conexión exitosa después de un breve retraso
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.isConnected = true
            // Notificar a los handlers de conexión
            let emitter = SocketAckEmitter(socket: self, ackNum: 0)
            self.clientEventHandlers[ClientEvent.connect.rawValue]?.forEach { handler in
                handler("Connected", emitter)
            }
            
            // Comenzar a generar actualizaciones periódicas
            self.startPeriodicUpdates()
        }
    }
    
    func disconnect() {
        // Detener actualizaciones periódicas
        timer?.invalidate()
        timer = nil
        
        // Simular desconexión
        isConnected = false
        let emitter = SocketAckEmitter(socket: self, ackNum: 0)
        clientEventHandlers[ClientEvent.disconnect.rawValue]?.forEach { handler in
            handler("Disconnected", emitter)
        }
    }
    
    private func startPeriodicUpdates() {
        // Índice para rastrear la posición a lo largo de la línea 1
        var segmentIndex = 0
        var progress = 0.0
        
        // Coordenadas de la línea 1 para la simulación
        let line1Coordinates: [CLLocationCoordinate2D] = [
            // Talleres a San Bernabé
            CLLocationCoordinate2D(latitude: 25.7544675, longitude: -100.3655645),
            CLLocationCoordinate2D(latitude: 25.7483890, longitude: -100.3616380),
            // San Bernabé a Unidad Modelo
            CLLocationCoordinate2D(latitude: 25.7418717, longitude: -100.3549080),
            CLLocationCoordinate2D(latitude: 25.7321485, longitude: -100.3472600),
            // Unidad Modelo a Aztlán
            CLLocationCoordinate2D(latitude: 25.7233152, longitude: -100.3425450),
            CLLocationCoordinate2D(latitude: 25.7059242, longitude: -100.3424003),
            // Aztlán a Penitenciaría
            CLLocationCoordinate2D(latitude: 25.6987474, longitude: -100.3431880),
            CLLocationCoordinate2D(latitude: 25.6893801, longitude: -100.3436221),
            // Penitenciaría a Parque Fundidora
            CLLocationCoordinate2D(latitude: 25.6875702, longitude: -100.3394937),
            CLLocationCoordinate2D(latitude: 25.6861218, longitude: -100.3169480),
            // Parque Fundidora a Cuauhtémoc
            CLLocationCoordinate2D(latitude: 25.6839868, longitude: -100.2969920),
            CLLocationCoordinate2D(latitude: 25.6832309, longitude: -100.2794460),
            // Cuauhtémoc a Y Griega
            CLLocationCoordinate2D(latitude: 25.6798275, longitude: -100.2480310),
            CLLocationCoordinate2D(latitude: 25.6797233, longitude: -100.2473393),
            // Y Griega a Exposición
            CLLocationCoordinate2D(latitude: 25.6795043, longitude: -100.2454920),
            CLLocationCoordinate2D(latitude: 25.6792699, longitude: -100.2433402),
            CLLocationCoordinate2D(latitude: 25.6790443, longitude: -100.2414310)
        ]
        
        // Generar actualizaciones periódicas de vehículos (simulación)
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self, self.isConnected else { return }
            
            // Crear algunos datos simulados para "vehicleUpdate"
            if let handlers = self.eventHandlers["vehicleUpdate"] {
                let emitter = SocketAckEmitter(socket: self, ackNum: 0)
                
                // Crear ID y línea fijos para mantener un solo vehículo
                let lineId = "L1"
                let vehicleId = "metro_L1_5"
                
                // Calcular la siguiente posición interpolando entre puntos
                var latitude: Double = 0
                var longitude: Double = 0
                
                // Si no hemos llegado al final de la línea
                if segmentIndex < line1Coordinates.count - 1 {
                    // Puntos actuales del segmento
                    let startPoint = line1Coordinates[segmentIndex]
                    let endPoint = line1Coordinates[segmentIndex + 1]
                    
                    // Interpolar entre los puntos según el progreso
                    latitude = startPoint.latitude + (endPoint.latitude - startPoint.latitude) * progress
                    longitude = startPoint.longitude + (endPoint.longitude - startPoint.longitude) * progress
                    
                    // Incrementar el progreso
                    progress += 0.05
                    
                    // Si hemos completado este segmento, pasar al siguiente
                    if progress >= 1.0 {
                        segmentIndex += 1
                        progress = 0.0
                        
                        // Si llegamos al final, regresar al inicio
                        if segmentIndex >= line1Coordinates.count - 1 {
                            segmentIndex = 0
                        }
                    }
                } else {
                    // Reiniciar al principio
                    segmentIndex = 0
                    progress = 0.0
                    
                    // Usar la primera coordenada
                    latitude = line1Coordinates[0].latitude
                    longitude = line1Coordinates[0].longitude
                }
                
                // Simular actualización de vehículo con el formato especificado
                let vehicleData: [String: Any] = [
                    "id": vehicleId,
                    "location": [
                        "latitude": latitude,
                        "longitude": longitude
                    ],
                    "occupancy": Int.random(in: 10...90),
                    "routeId": lineId,
                    "lastUpdate": Int64(Date().timeIntervalSince1970 * 1000)
                ]
                
                // Llamar a todos los handlers registrados
                handlers.forEach { handler in
                    handler(vehicleData, emitter)
                }
            }
        }
    }
}

class SocketAckEmitter {
    let socket: SocketIOClient
    let ackNum: Int
    
    init(socket: SocketIOClient, ackNum: Int) {
        self.socket = socket
        self.ackNum = ackNum
    }
    
    func with(_ items: Any...) {
        // Simulación de respuesta a un ack
        print("📡 Recibido ack: \(ackNum) con datos: \(items)")
    }
}

class RealTimeMetroService {
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    // Publicadores para actualizar la interfaz
    let vehicleUpdatePublisher = PassthroughSubject<MetroVehicle, Never>()
    let connectionStatusPublisher = PassthroughSubject<ConnectionStatus, Never>()
    let connectionErrorPublisher = PassthroughSubject<Error, Never>()
    
    // Estado de conexión
    enum ConnectionStatus {
        case connecting
        case connected
        case disconnected
    }
    
    // Inicialización del servicio
    init() {
        setupSocket()
    }
    
    private func setupSocket() {
        // Configurar el gestor de Socket.IO con la URL correcta
        let serverURL = URL(string: "http://localhost:3000/api/mobile/socket-info")!
        manager = SocketManager(socketURL: serverURL, config: ["log": true, "forceWebsockets": true])
        
        // Configurar el socket
        socket = manager?.defaultSocket
        
        // Configurar los listeners para eventos del socket
        setupEventHandlers()
    }
    
    private func setupEventHandlers() {
        guard let socket = socket else { return }
        
        // Evento cuando el socket se conecta
        socket.on(clientEvent: .connect) { [weak self] _, _ in
            print("⚡️ Socket.IO conectado")
            self?.connectionStatusPublisher.send(.connected)
        }
        
        // Evento cuando el socket se desconecta
        socket.on(clientEvent: .disconnect) { [weak self] _, _ in
            print("⚡️ Socket.IO desconectado")
            self?.connectionStatusPublisher.send(.disconnected)
        }
        
        // Evento cuando ocurre un error de conexión
        socket.on(clientEvent: .error) { [weak self] data, _ in
            print("⚡️ Socket.IO error: \(data)")
            
            // Crear un error simulado
            struct SimulatedError: Error, LocalizedError {
                let message: String
                var errorDescription: String? { message }
            }
            
            let error = SimulatedError(message: "Simulated error: \(data)")
            self?.connectionErrorPublisher.send(error)
        }
        
        // Evento de posición de vehículo actualizada
        socket.on("vehicleUpdate") { [weak self] data, _ in
            guard let self = self else { return }
            
            if let dataDict = data as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: dataDict)
                    let vehicle = try JSONDecoder().decode(MetroVehicle.self, from: jsonData)
                    self.vehicleUpdatePublisher.send(vehicle)
                } catch {
                    print("⚡️ Error al decodificar actualización de vehículo: \(error)")
                }
            }
        }
    }
    
    // MARK: - Métodos Públicos
    
    func connect() {
        guard let socket = socket else { return }
        connectionStatusPublisher.send(.connecting)
        socket.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func subscribeTo(vehicleId: String? = nil, lineId: String? = nil) {
        guard let socket = socket else { return }
        
        var eventData: [String: String] = [:]
        
        if let vehicleId = vehicleId {
            eventData["vehicleId"] = vehicleId
        }
        
        if let lineId = lineId {
            eventData["lineId"] = lineId
        }
        
        socket.emit("subscribeToVehicles", eventData)
    }
    
    func unsubscribeFrom(vehicleId: String? = nil, lineId: String? = nil) {
        guard let socket = socket else { return }
        
        var eventData: [String: String] = [:]
        
        if let vehicleId = vehicleId {
            eventData["vehicleId"] = vehicleId
        }
        
        if let lineId = lineId {
            eventData["lineId"] = lineId
        }
        
        socket.emit("unsubscribeFromVehicles", eventData)
    }
    
    // Para pruebas: simular actualizaciones de vehículos adicionales
    func simulateVehicleUpdates() {
        // Ya no necesitamos esta implementación ya que nuestra simulación de Socket.IO
        // ya genera actualizaciones de vehículos automáticamente
    }
} 
