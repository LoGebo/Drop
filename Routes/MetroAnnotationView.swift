import MapKit
import UIKit

// Clase para personalizar la apariencia de las anotaciones del tren en el mapa
class MetroAnnotationView: MKAnnotationView {
    // Identificador para reutilización
    static let identifier = "MetroAnnotationView"
    
    // UI Components
    private let trainImageView = UIImageView()
    private let occupancyIndicator = UIView()
    
    // Animation properties
    private var animator: UIViewPropertyAnimator?
    
    // Metro vehicle data
    private var vehicle: MetroVehicle?
    
    // Propiedades para configuración
    var occupancy: Int = 0 {
        didSet {
            configureOccupancyIndicator()
        }
    }
    
    var lineColor: UIColor = .systemYellow {
        didSet {
            configureTrainImage()
        }
    }
    
    // Constructor
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Configuración de la vista
    
    private func setupView() {
        // Configure annotation view
        frame = CGRect(x: 0, y: 0, width: 44, height: 24) // Ajustado para forma más rectangular como un tren
        centerOffset = CGPoint(x: 0, y: -12) // Centrado ajustado
        canShowCallout = true
        
        // Set up callout button
        let button = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = button
        
        // Add train container (background shape)
        backgroundColor = .systemBlue
        layer.cornerRadius = 8 // Menos redondeado, más como un vagón
        
        // Add train image
        trainImageView.frame = CGRect(x: 4, y: 2, width: 20, height: 20)
        trainImageView.contentMode = .scaleAspectFit
        trainImageView.tintColor = .white
        trainImageView.image = UIImage(systemName: "tram")
        addSubview(trainImageView)
        
        // Add occupancy indicator
        occupancyIndicator.frame = CGRect(x: 28, y: 2, width: 12, height: 12)
        occupancyIndicator.layer.cornerRadius = 6
        occupancyIndicator.backgroundColor = .systemGreen
        addSubview(occupancyIndicator)
        
        // Add drop shadow for 3D effect
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2
        
        // Configurar elementos
        configureTrainImage()
        configureOccupancyIndicator()
        
        // Habilitar interacción del usuario
        isEnabled = true
        
        // Agregar gesto de tap para mostrar la capacidad
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        // Simular un toque en el botón de detalle para mostrar la capacidad
        if let vehicle = self.annotation as? MetroVehicle {
            // Mostrar la capacidad directamente
            let capacityMessage = "Ocupación: \(vehicle.occupancy)% - \(vehicle.occupancyDescription)"
            print(capacityMessage)
            
            // Hacer "bounce" del tren para indicar selección
            UIView.animate(withDuration: 0.15, animations: {
                self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { _ in
                UIView.animate(withDuration: 0.15) {
                    self.transform = CGAffineTransform.identity
                }
            })
            
            // Mostrar el callout
            self.setSelected(true, animated: true)
        }
    }
    
    // Configurar la imagen del tren según la línea
    private func configureTrainImage() {
        // Crear una capa de forma para el tren
        layer.cornerRadius = 8
        layer.masksToBounds = false
        backgroundColor = lineColor
        
        // Usar una imagen de tren moderna
        if let trainImage = UIImage(systemName: "tram") {
            trainImageView.image = trainImage
            trainImageView.tintColor = .white
        }
    }
    
    // Configurar el indicador de ocupación
    private func configureOccupancyIndicator() {
        // Establecer color según nivel de ocupación
        if occupancy < 30 {
            occupancyIndicator.backgroundColor = .systemGreen
        } else if occupancy < 60 {
            occupancyIndicator.backgroundColor = .systemYellow
        } else if occupancy < 85 {
            occupancyIndicator.backgroundColor = .systemOrange
        } else {
            occupancyIndicator.backgroundColor = .systemRed
        }
        
        // Pulsar para indicar que es un vehículo en movimiento
        animateOccupancyIndicator()
    }
    
    // MARK: - Actualización de la anotación
    
    override func prepareForReuse() {
        super.prepareForReuse()
        animator?.stopAnimation(true)
        animator = nil
    }
    
    // Método para actualizar la vista con un vehículo
    func update(with vehicle: MetroVehicle) {
        self.vehicle = vehicle
        
        // Actualizar propiedades visuales
        self.occupancy = vehicle.occupancy
        self.lineColor = vehicle.lineColor
        
        // Actualizar texto informativo
        self.annotation = vehicle
        
        // Actualizar background color based on the line
        backgroundColor = vehicle.lineColor
        
        // Update occupancy indicator
        occupancyIndicator.backgroundColor = vehicle.occupancyColor
        
        // Actualizar texto del callout
        let titleView = UILabel()
        titleView.text = "Metro Line \(vehicle.routeId)"
        titleView.font = UIFont.boldSystemFont(ofSize: 14)
        
        let subtitleView = UILabel()
        subtitleView.text = "Ocupación: \(vehicle.occupancy)% - \(vehicle.occupancyDescription)"
        subtitleView.font = UIFont.systemFont(ofSize: 12)
        subtitleView.textColor = UIColor.darkGray
        
        // Update animation for the occupancy indicator to pulse
        animateOccupancyIndicator()
    }
    
    // Método para animar el movimiento del tren a una nueva posición
    func animateMovement(from startCoordinate: CLLocationCoordinate2D, to endCoordinate: CLLocationCoordinate2D) {
        // Calcular ángulo para orientar el tren en la dirección del movimiento
        let angle = angleForCoordinate(from: startCoordinate, to: endCoordinate)
        
        // Scale effect for movement animation
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).rotated(by: angle)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(rotationAngle: angle)
            }
        })
    }
    
    // Calcular ángulo entre dos coordenadas para orientar el tren
    private func angleForCoordinate(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> CGFloat {
        let deltaLongitude = end.longitude - start.longitude
        let deltaLatitude = end.latitude - start.latitude
        let angle = atan2(deltaLongitude, deltaLatitude)
        
        return CGFloat(angle)
    }
    
    // MARK: - Private Animations
    
    private func animateOccupancyIndicator() {
        // Cancel any existing animation
        animator?.stopAnimation(true)
        
        // Create new animation
        animator = UIViewPropertyAnimator(duration: 2.0, curve: .easeInOut) { [weak self] in
            guard let self = self else { return }
            
            // Pulse animation sequence
            UIView.animateKeyframes(withDuration: 2.0, delay: 0, options: [.repeat], animations: {
                // Fade out
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                    self.occupancyIndicator.alpha = 0.3
                }
                
                // Fade in
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.occupancyIndicator.alpha = 1.0
                }
            })
        }
        
        // Start animation
        animator?.startAnimation()
    }
    
    // Para asegurar que el usuario pueda hacer clic
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Expandir el área de toque para facilitar la interacción
        let hitTestRect = bounds.insetBy(dx: -15, dy: -15)
        if hitTestRect.contains(point) {
            return self
        }
        return super.hitTest(point, with: event)
    }
} 