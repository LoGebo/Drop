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
        frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        centerOffset = CGPoint(x: 0, y: -20) // Offset to center the bottom of the pin
        canShowCallout = true
        
        // Set up callout button
        let button = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = button
        
        // Add train image
        trainImageView.frame = CGRect(x: 8, y: 8, width: 24, height: 24)
        trainImageView.contentMode = .scaleAspectFit
        trainImageView.tintColor = .white
        trainImageView.image = UIImage(systemName: "tram.fill")
        addSubview(trainImageView)
        
        // Add occupancy indicator
        occupancyIndicator.frame = CGRect(x: 30, y: 0, width: 10, height: 10)
        occupancyIndicator.layer.cornerRadius = 5
        occupancyIndicator.backgroundColor = .systemGreen
        addSubview(occupancyIndicator)
        
        // Set up the background shape
        backgroundColor = .systemBlue
        layer.cornerRadius = 20
        
        // Add drop shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2
        
        // Configurar elementos
        configureTrainImage()
        configureOccupancyIndicator()
    }
    
    // Configurar la imagen del tren según la línea
    private func configureTrainImage() {
        // Usar una imagen de tren
        if let trainImage = UIImage(systemName: "tram.fill") {
            // Renderizar la imagen con el color de la línea
            let colorizedImage = trainImage.withTintColor(lineColor, renderingMode: .alwaysOriginal)
            trainImageView.image = colorizedImage
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
        
        // Update animation for the occupancy indicator to pulse
        animateOccupancyIndicator()
    }
    
    // Método para animar el movimiento del tren a una nueva posición
    func animateMovement(from startCoordinate: CLLocationCoordinate2D, to endCoordinate: CLLocationCoordinate2D) {
        // Scale effect for movement animation
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        })
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
} 