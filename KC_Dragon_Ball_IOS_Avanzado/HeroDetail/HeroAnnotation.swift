//
//  HeroAnnotation.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 25/10/24.
//

import MapKit

/// Clase `HeroAnnotation` para representar ubicaciones de héroes en el mapa.
/// Hereda de `NSObject` e implementa el protocolo `MKAnnotation` para integrarse con `MapKit`.
class HeroAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Propiedades
    
    /// Título que describe la anotación. Generalmente el nombre del héroe o una descripción de la ubicación.
    var title: String?
    
    /// Coordenadas de la ubicación en el mapa.
    var coordinate: CLLocationCoordinate2D
    
    // MARK: - Inicializador
    
    /// Inicializa una nueva instancia de `HeroAnnotation` con un título y coordenadas específicas.
    /// - Parameters:
    ///   - title: El título descriptivo de la anotación (opcional).
    ///   - coordinate: La ubicación en el mapa donde se mostrará la anotación.
    init(title: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
