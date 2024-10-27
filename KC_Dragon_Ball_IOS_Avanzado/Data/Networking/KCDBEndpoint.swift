//
//  KCDBEndpoint.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 16/10/24.
//

import Foundation

/// Enum que representa los distintos endpoints de la API de la aplicación.
enum GAEndpoint {
    
    /// Endpoint para la autenticación del usuario.
    case login
    
    /// Endpoint para obtener la lista de héroes.
    case heroes
    
    /// Endpoint para obtener las ubicaciones de los héroes.
    case locations
    
    /// Endpoint para obtener las transformaciones de los héroes.
    case transformations

    // MARK: - Obtención de Path

    /// Genera el path asociado a cada endpoint.
    /// - Returns: String que representa el path específico del endpoint.
    func path() -> String {
        switch self {
        case .login:
            // Path para el endpoint de login.
            return "/api/auth/login"
        case .heroes:
            // Path para obtener todos los héroes.
            return "/api/heros/all"
        case .locations:
            // Path para obtener las ubicaciones de los héroes.
            return "/api/heros/locations"
        case .transformations:
            // Path para obtener las transformaciones de los héroes.
            return "/api/heros/tranformations"
        }
    }

    // MARK: - Método HTTP

    /// Proporciona el método HTTP necesario para cada endpoint.
    /// - Returns: String que representa el método HTTP a usar.
    func httpMethod() -> String {
        switch self {
        case .login, .heroes, .locations, .transformations:
            // Todos los endpoints utilizan el método HTTP POST.
            return "POST"
        }
    }
}
