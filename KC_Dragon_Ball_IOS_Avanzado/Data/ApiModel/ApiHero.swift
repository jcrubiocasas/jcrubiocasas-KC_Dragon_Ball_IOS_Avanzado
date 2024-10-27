//
//  ApiHero.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 16/10/24.
//

/// Modelo que representa un Héroe tal como se recibe desde la API, conforma al protocolo `Codable` para facilitar la codificación y decodificación JSON.
struct ApiHero: Codable {
    let id: String?                // Identificador único del héroe
    let name: String?              // Nombre del héroe
    let description: String?       // Descripción del héroe
    let photo: String?             // URL de la imagen del héroe en formato de cadena
    var favorite: Bool = false     // Indica si el héroe está marcado como favorito por el usuario
}
