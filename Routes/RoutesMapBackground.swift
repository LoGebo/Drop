import SwiftUI
import MapKit

// MARK: - Map Background
struct RoutesMapBackgroundView: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var metroViewModel = MetroMapViewModel()
    @State private var selectedVehicleId: String?
    @State private var showOccupancyChart = false
    
    // Coordenadas línea 1
    private let metroLine1Coordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.6790443, longitude: -100.2414310),
        CLLocationCoordinate2D(latitude: 25.6792699, longitude: -100.2433402),
        CLLocationCoordinate2D(latitude: 25.6795043, longitude: -100.2454920),
        CLLocationCoordinate2D(latitude: 25.6797233, longitude: -100.2473393),
        CLLocationCoordinate2D(latitude: 25.6798275, longitude: -100.2480310),
        CLLocationCoordinate2D(latitude: 25.6832309, longitude: -100.2794460),
        CLLocationCoordinate2D(latitude: 25.6839868, longitude: -100.2969920),
        CLLocationCoordinate2D(latitude: 25.6861218, longitude: -100.3169480),
        CLLocationCoordinate2D(latitude: 25.6875702, longitude: -100.3394937),
        CLLocationCoordinate2D(latitude: 25.6893801, longitude: -100.3436221),
        CLLocationCoordinate2D(latitude: 25.6987474, longitude: -100.3431880),
        CLLocationCoordinate2D(latitude: 25.7059242, longitude: -100.3424003),
        CLLocationCoordinate2D(latitude: 25.7233152, longitude: -100.3425450),
        CLLocationCoordinate2D(latitude: 25.7321485, longitude: -100.3472600),
        CLLocationCoordinate2D(latitude: 25.7418717, longitude: -100.3549080),
        CLLocationCoordinate2D(latitude: 25.7483890, longitude: -100.3616380),
        CLLocationCoordinate2D(latitude: 25.7544675, longitude: -100.3655645)
    ]

    // Coordenadas línea 2
    private let metroLine2Coordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.7687766, longitude: -100.2928846),
        CLLocationCoordinate2D(latitude: 25.7607641, longitude: -100.2951015),
        CLLocationCoordinate2D(latitude: 25.7532513, longitude: -100.2978342),
        CLLocationCoordinate2D(latitude: 25.7463032, longitude: -100.3003184),
        CLLocationCoordinate2D(latitude: 25.7426889, longitude: -100.3016192),
        CLLocationCoordinate2D(latitude: 25.7322149, longitude: -100.3054117),
        CLLocationCoordinate2D(latitude: 25.7170160, longitude: -100.3108590),
        CLLocationCoordinate2D(latitude: 25.7052711, longitude: -100.3150973),
        CLLocationCoordinate2D(latitude: 25.6986997, longitude: -100.3168353),
        CLLocationCoordinate2D(latitude: 25.6901726, longitude: -100.3167621),
        CLLocationCoordinate2D(latitude: 25.6818769, longitude: -100.3174807),
        CLLocationCoordinate2D(latitude: 25.6741416, longitude: -100.3185592),
        CLLocationCoordinate2D(latitude: 25.6677517, longitude: -100.3102020)
    ]

    // Coordenadas línea 3
    private let metroLine3Coordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.7147319, longitude: -100.2721709),
        CLLocationCoordinate2D(latitude: 25.7081248, longitude: -100.2817140),
        CLLocationCoordinate2D(latitude: 25.7032038, longitude: -100.2887021),
        CLLocationCoordinate2D(latitude: 25.6946223, longitude: -100.2952712),
        CLLocationCoordinate2D(latitude: 25.6882480, longitude: -100.2962444),
        CLLocationCoordinate2D(latitude: 25.6778869, longitude: -100.2976580),
        CLLocationCoordinate2D(latitude: 25.6696848, longitude: -100.2987837),
        CLLocationCoordinate2D(latitude: 25.6683398, longitude: -100.2996454),
        CLLocationCoordinate2D(latitude: 25.6669596, longitude: -100.3021769),
        CLLocationCoordinate2D(latitude: 25.6667067, longitude: -100.3048954),
        CLLocationCoordinate2D(latitude: 25.6677517, longitude: -100.3102020)
    ]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = false
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = true
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsBuildings = false
        mapView.showsTraffic = false
        mapView.delegate = context.coordinator
        
        // Centrar en Monterrey con un zoom más cercano para mejor visualización
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.6866, longitude: -100.3161),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Zoom más cercano
        )
        mapView.setRegion(region, animated: false)
        
        // Estilo de mapa según el tema
        configureMapStyle(mapView)
        
        // Agregar las líneas del metro
        addMetroLines(to: mapView)
        
        // Conectar al servicio en tiempo real
        context.coordinator.metroViewModel = metroViewModel
        metroViewModel.connect()
        metroViewModel.subscribeToVehicle() // Suscribirse al vehículo por defecto
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        configureMapStyle(uiView)
        
        // Actualizar anotaciones de vehículos
        context.coordinator.updateVehicleAnnotations(in: uiView)
    }
    
    private func configureMapStyle(_ mapView: MKMapView) {
        if #available(iOS 16.0, *) {
            // Usar un estilo más sutil dependiendo del tema
            mapView.preferredConfiguration = colorScheme == .dark
                ? MKStandardMapConfiguration(elevationStyle: .flat, emphasisStyle: .muted)
                : MKStandardMapConfiguration(elevationStyle: .flat, emphasisStyle: .muted)
        }
    }
    
    private func addMetroLines(to mapView: MKMapView) {
        // Agregar estaciones
        addMetroStations(to: mapView)
        
        // Línea 1 (Amarilla)
        let line1 = MKPolyline(coordinates: metroLine1Coordinates, count: metroLine1Coordinates.count)
        line1.title = "Line1"
        mapView.addOverlay(line1, level: .aboveRoads)
        
        // Línea 2 (Verde)
        let line2 = MKPolyline(coordinates: metroLine2Coordinates, count: metroLine2Coordinates.count)
        line2.title = "Line2"
        mapView.addOverlay(line2, level: .aboveRoads)
        
        // Línea 3 (Naranja)
        let line3 = MKPolyline(coordinates: metroLine3Coordinates, count: metroLine3Coordinates.count)
        line3.title = "Line3"
        mapView.addOverlay(line3, level: .aboveRoads)
    }
    
    private func addMetroStations(to mapView: MKMapView) {
        // Estaciones principales (puntos clave)
        let stations: [(name: String, coordinate: CLLocationCoordinate2D, line: String)] = [
            ("Talleres", CLLocationCoordinate2D(latitude: 25.75389, longitude: -100.36528), "Line1"),
            ("Cuauhtémoc", CLLocationCoordinate2D(latitude: 25.68611, longitude: -100.31694), "Line1"),
            ("Exposición", CLLocationCoordinate2D(latitude: 25.67944, longitude: -100.24556), "Line1"),
            ("Sendero", CLLocationCoordinate2D(latitude: 25.768777, longitude: -100.292885), "Line2"),
            ("Zaragoza", CLLocationCoordinate2D(latitude: 25.667752, longitude: -100.310202), "Line2"),
            ("Hospital Metropolitano", CLLocationCoordinate2D(latitude: 25.713763, longitude: -100.273595), "Line3"),
            ("Zaragoza", CLLocationCoordinate2D(latitude: 25.667752, longitude: -100.310202), "Line3")
        ]
        
        for station in stations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = station.coordinate
            annotation.title = station.name
            annotation.subtitle = station.line
            mapView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(colorScheme: colorScheme, parent: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        let colorScheme: ColorScheme
        var parent: RoutesMapBackgroundView
        var metroViewModel: MetroMapViewModel?
        var currentVehicle: MetroVehicle?
        
        init(colorScheme: ColorScheme, parent: RoutesMapBackgroundView) {
            self.colorScheme = colorScheme
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                
                // Color según la línea (ajustado para mayor contraste según el tema)
                if polyline.title == "Line1" {
                    renderer.strokeColor = colorScheme == .dark ? .yellow : .systemYellow
                } else if polyline.title == "Line2" {
                    renderer.strokeColor = colorScheme == .dark ? .green : .systemGreen
                } else if polyline.title == "Line3" {
                    renderer.strokeColor = colorScheme == .dark ? .orange : .systemOrange
                } else {
                    renderer.strokeColor = .blue
                }
                
                renderer.lineWidth = 5.0
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Metro vehicle annotation
            if let vehicle = annotation as? MetroVehicle {
                let identifier = MetroAnnotationView.identifier
                var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MetroAnnotationView
                
                if view == nil {
                    view = MetroAnnotationView(annotation: vehicle, reuseIdentifier: identifier)
                    view?.canShowCallout = true
                } else {
                    view?.annotation = vehicle
                }
                
                // Configurar la vista con los datos del vehículo
                view?.update(with: vehicle)
                
                return view
            }
            
            // Estaciones del metro
            let identifier = "stationMarker"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
            } else {
                view?.annotation = annotation
            }
            
            // Color según la línea
            if let subtitle = annotation.subtitle {
                if subtitle == "Line1" {
                    view?.markerTintColor = colorScheme == .dark ? .yellow : .systemYellow
                } else if subtitle == "Line2" {
                    view?.markerTintColor = colorScheme == .dark ? .green : .systemGreen
                } else if subtitle == "Line3" {
                    view?.markerTintColor = colorScheme == .dark ? .orange : .systemOrange
                }
            }
            
            view?.glyphImage = UIImage(systemName: "tram.fill")
            return view
        }
        
        // Gestionar toque en la callout
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let vehicle = view.annotation as? MetroVehicle {
                // Seleccionar vehículo y mostrar gráfica de ocupación
                metroViewModel?.selectVehicle(vehicle)
                parent.selectedVehicleId = vehicle.id
                parent.showOccupancyChart = true
            }
        }
        
        // Actualizar anotaciones de vehículos
        func updateVehicleAnnotations(in mapView: MKMapView) {
            guard let metroViewModel = metroViewModel else { return }
            
            // Obtener el vehículo actual (asumimos que solo hay uno)
            guard let (id, vehicle) = metroViewModel.vehicles.first else {
                // Si no hay vehículos, nos aseguramos de limpiar cualquier anotación anterior
                let vehicleAnnotations = mapView.annotations.compactMap { $0 as? MetroVehicle }
                if !vehicleAnnotations.isEmpty {
                    mapView.removeAnnotations(vehicleAnnotations)
                }
                return
            }
            
            // Buscar si ya tenemos una anotación para este vehículo
            let existingVehicleAnnotations = mapView.annotations.compactMap { $0 as? MetroVehicle }
            
            if let existingAnnotation = existingVehicleAnnotations.first {
                // Ya existe una anotación, actualizarla
                if existingAnnotation.coordinate.latitude != vehicle.latitude ||
                   existingAnnotation.coordinate.longitude != vehicle.longitude {
                    
                    if let annotationView = mapView.view(for: existingAnnotation) as? MetroAnnotationView,
                       let previousCoordinate = vehicle.previousCoordinate {
                        // Animar el movimiento
                        animateVehicleMovement(
                            annotation: existingAnnotation,
                            from: previousCoordinate,
                            to: vehicle.coordinate,
                            in: mapView,
                            with: annotationView
                        )
                    } else {
                        // Actualizar sin animación
                        UIView.animate(withDuration: 0.3) {
                            if let vehicleAnnotation = existingAnnotation as? MetroVehicle {
                                vehicleAnnotation.updatePosition(to: CLLocationCoordinate2D(
                                    latitude: vehicle.latitude,
                                    longitude: vehicle.longitude
                                ))
                            }
                        }
                    }
                    
                    // También actualizar otras propiedades como ocupación
                    if let annotationView = mapView.view(for: existingAnnotation) as? MetroAnnotationView {
                        annotationView.update(with: vehicle)
                    }
                }
            } else {
                // No hay anotación, añadirla
                mapView.addAnnotation(vehicle)
            }
            
            // Limpiar anotaciones que ya no corresponden al vehículo actual
            let outdatedAnnotations = existingVehicleAnnotations.filter { $0.id != id }
            if !outdatedAnnotations.isEmpty {
                mapView.removeAnnotations(outdatedAnnotations)
            }
        }
        
        // Método para animar el movimiento del vehículo
        func animateVehicleMovement(annotation: MKAnnotation, from startCoordinate: CLLocationCoordinate2D, to endCoordinate: CLLocationCoordinate2D, in mapView: MKMapView, with annotationView: MetroAnnotationView) {
            // Animación para la actualización de la posición
            if let vehicle = annotation as? MetroVehicle {
                UIView.animate(withDuration: 1.0) {
                    vehicle.updatePosition(to: endCoordinate)
                }
                
                // Animación visual adicional
                annotationView.animateMovement(from: startCoordinate, to: endCoordinate)
            }
        }
    }
} 
