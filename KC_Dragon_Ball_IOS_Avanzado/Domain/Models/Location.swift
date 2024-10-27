//
//  Location.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 19/10/24.
//

import MapKit // Importa el framework MapKit para utilizar coordenadas geográficas

// MARK: - Location
struct Location { // Estructura para representar una ubicación con id, fecha, latitud y longitud
    let id: String // Identificador único de la ubicación
    let date: String // Fecha de la ubicación en formato de texto
    let latitude: String // Coordenada de latitud como cadena de texto
    let longitude: String // Coordenada de longitud como cadena de texto
    
    /// Inicializador para mapear una instancia de `MOLocation` a `Location`
    init(moLocation: MOLocation) {
        self.id = moLocation.id ?? "" // Asigna el id de la ubicación o una cadena vacía si es nulo
        self.date = moLocation.date ?? "" // Asigna la fecha de la ubicación o una cadena vacía si es nulo
        self.latitude = moLocation.latitude ?? "" // Asigna la latitud de la ubicación o una cadena vacía si es nulo
        self.longitude = moLocation.longitude ?? "" // Asigna la longitud de la ubicación o una cadena vacía si es nulo
    }
}

// MARK: - Extension
extension Location {
    var coordinate: CLLocationCoordinate2D? { // Calcula la coordenada de CLLocationCoordinate2D
        guard let latitude = Double(self.latitude), // Convierte latitud a Double
              let longitude = Double(self.longitude), // Convierte longitud a Double
              abs(latitude) <= 90, // Verifica si la latitud es válida entre -90 y 90
              abs(longitude) <= 180 else { // Verifica si la longitud es válida entre -180 y 180
            return nil // Devuelve nil si alguna verificación falla
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude) // Devuelve la coordenada
    }
}
