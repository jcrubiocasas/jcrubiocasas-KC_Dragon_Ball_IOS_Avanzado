//
//  ApiLocation.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 16/10/24.
//

import Foundation

// MARK: - Model
struct ApiLocation: Codable {
    let id: String?                // Identificador único de la localización
    let date: String?              // Fecha en la que se muestra la localización, mapeada desde "dateShow"
    let latitude: String?          // Latitud de la localización, mapeada desde "latitud"
    let longitude: String?         // Longitud de la localización, mapeada desde "longitud"
    let hero: ApiHero?             // Héroe asociado a la localización, de tipo `ApiHero`

    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id                     // Clave para el identificador de localización
        case date = "dateShow"      // Mapea "dateShow" de la API a `date`
        case latitude = "latitud"   // Mapea "latitud" de la API a `latitude`
        case longitude = "longitud" // Mapea "longitud" de la API a `longitude`
        case hero                   // Clave para el héroe asociado
    }
}
