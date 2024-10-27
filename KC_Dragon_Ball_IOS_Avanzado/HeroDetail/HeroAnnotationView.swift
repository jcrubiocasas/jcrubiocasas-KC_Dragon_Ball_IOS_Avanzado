//
//  HeroAnnotationView.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 25/10/24.
//

import MapKit

/// Clase `HeroAnnotationView` que representa una vista personalizada para una anotación de héroe en el mapa.
class HeroAnnotationView: MKAnnotationView {
    
    // MARK: - Identificador
    
    /// Identificador reutilizable para `HeroAnnotationView`, utilizado para la reutilización en `MKMapView`.
    static var identifier: String {
        return String(describing: HeroAnnotationView.self)
    }
    
    // MARK: - Inicializadores
    
    /// Inicializa una instancia de `HeroAnnotationView` con una anotación y un identificador reutilizable.
    /// - Parameters:
    ///   - annotation: Anotación que se mostrará en el mapa.
    ///   - reuseIdentifier: Identificador para reutilización de la vista.
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // Configuración del tamaño de la vista
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        // Centra la vista en el punto de la coordenada
        self.centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        // Permite que se muestre el Callout con información adicional
        self.canShowCallout = true
        
        // Configuración de la vista personalizada
        self.setupView()
    }
    
    /// Inicializador requerido para el caso de uso con Storyboard o XIB.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuración de la Vista
    
    /// Configura los elementos visuales de la vista de anotación.
    func setupView() {
        // Fondo transparente
        backgroundColor = .clear
        
        // Agrega una imagen personalizada para la anotación (bola de dragón)
        let view = UIImageView(image: UIImage(resource: .bolaDragon))
        addSubview(view)
        view.frame = self.frame
        
        // Agrega un botón de información al lado derecho del Callout
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
}
