//
//  KCDBRequestBuilder.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 16/10/24.
//

import Foundation

/// Clase `GARequestBuilder` para construir y configurar solicitudes HTTP (requests) para la API a partir de un endpoint y parámetros proporcionados.
class GARequestBuilder {
    
    /// Constante que define el host del API.
    private let host = "dragonball.keepcoding.education"
    
    /// Variable `request` que almacena la solicitud en proceso de construcción.
    private var request: URLRequest?
    
    /// Variable opcional que almacena el token de sesión, recuperado del `KeychainManager`.
    var token: String? = KeychainManager.shared.getData(for: "KeepCodingToken")
    
    /// Almacén seguro para manejar el token de sesión y otros datos sensibles.
    private let secureStorage: KeychainManager
    
    /// Inicializador que recibe un `KeychainManager`, con un valor predeterminado de `KeychainManager.shared`.
    init(secureStorage: KeychainManager = KeychainManager.shared) {
        self.secureStorage = secureStorage
    }
    
    // MARK: - Construcción de URL

    /// Genera la URL completa para la solicitud HTTP.
    /// - Parameter endoPoint: `GAEndpoint` que indica el recurso de la API a acceder.
    /// - Returns: URL construida a partir de `URLComponents`.
    /// - Throws: `GAError.badUrl` si no se puede construir la URL.
    private func url(endoPoint: GAEndpoint) throws(GAError) -> URL {
        // Configura los componentes básicos de la URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host
        components.path = endoPoint.path()
        
        // Intenta obtener la URL final
        if let url = components.url {
            return url
        } else {
            // Lanza error si la URL no es válida
            throw GAError.badUrl
        }
    }

    // MARK: - Configuración de Headers

    /// Configura los encabezados de la solicitud HTTP.
    /// - Parameters:
    ///   - params: Diccionario de parámetros que se incluirán en el cuerpo de la solicitud (body).
    ///   - requiredAuthorization: Indica si se requiere autorización (por defecto `true`).
    /// - Throws: `GAError` si hay algún problema en la configuración de los encabezados.
    private func setHeaders(params: [String: String]?, requiredAuthorization: Bool = true) throws(GAError) {
        // Verifica si se necesita autorización
        if requiredAuthorization {
            // Si hay un token, se utiliza el esquema de autorización Bearer
            if let token = self.token {
                print("Usando autenticación Bearer con token")
                // Añade el token en el encabezado "Authorization"
                request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
                // Si existen parámetros, los convierte en JSON y los añade al cuerpo de la solicitud
                if let params = params {
                    request?.httpBody = try? JSONSerialization.data(withJSONObject: params)
                }
            } else {
                // Si falta el token, lanza error indicando que falta el token de sesión
                print("No se encontraron ni token ni credenciales, lanzando GAError.sessionTokenMissing")
                throw GAError.sessionTokenMissing
            }
        } else {
            // Si no se requiere token, intenta usar autenticación básica con usuario y contraseña
            if let params = params, let username = params["username"], let password = params["password"] {
                print("Usando autenticación HTTP Basic con username y password")
                // Genera la cadena de autenticación en formato `username:password`
                let loginString = String(format: "%@:%@", username, password)
                
                // Convierte la cadena a UTF-8 y luego la codifica en Base64
                guard let loginData = loginString.data(using: .utf8) else {
                    throw GAError.invalidCredentials
                }
                let base64LoginString = loginData.base64EncodedString()
                
                // Añade el encabezado de autorización con el token básico
                request?.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            }
        }
        
        // Establece el encabezado "Content-Type" como JSON
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    // MARK: - Construcción de Request
    
    /// Construye la solicitud HTTP (request) a partir de los parámetros proporcionados.
    /// - Parameters:
    ///   - endPoint: `GAEndpoint` que indica el recurso de la API.
    ///   - params: Parámetros que se añadirán al cuerpo de la solicitud.
    /// - Returns: Solicitud `URLRequest` configurada.
    /// - Throws: `GAError` en caso de que falle la construcción de la solicitud.
    func buildRequest(endPoint: GAEndpoint, params: [String: String]) throws(GAError) -> URLRequest {
        do {
            // Genera la URL de la solicitud a partir del endpoint
            let url = try self.url(endoPoint: endPoint)
            
            // Configura la solicitud con la URL y el método HTTP correspondiente
            request = URLRequest(url: url)
            request?.httpMethod = endPoint.httpMethod()
            
            // Si hay parámetros, añade encabezados con autorización y el cuerpo JSON
            if params.count > 0 {
                try setHeaders(params: params)
            }
            
            // Devuelve la solicitud final, si está correctamente configurada
            if let finalRequest = self.request {
                return finalRequest
            }
        } catch {
            // Propaga el error lanzado
            throw error
        }
        
        // Lanza error si la solicitud no se pudo configurar correctamente
        throw GAError.requestWasNil
    }
}
