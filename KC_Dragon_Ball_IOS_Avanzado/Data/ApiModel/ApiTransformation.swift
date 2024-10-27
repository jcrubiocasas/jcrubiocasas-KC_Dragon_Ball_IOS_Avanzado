//
//  ApiTransformation.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 16/10/24.
//

import Foundation

/// Modelo que representa una Transformación recibida desde la API
struct ApiTransformation: Codable {
    let id: String?                // Identificador único de la transformación
    let name: String?              // Nombre de la transformación
    let description: String?       // Descripción de la transformación
    let photo: String?             // URL de la imagen de la transformación
    let hero: ApiHeroT?            // Héroe asociado a la transformación, utilizando una estructura reducida `ApiHeroT`
}

/// Modelo simplificado del Héroe usado dentro de ApiTransformation
struct ApiHeroT: Codable {
    let id: String?                // Identificador único del héroe simplificado
}
