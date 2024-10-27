//
//  KCDBError.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 16/10/24.
//

import Foundation

/// Enum `GAError` para gestionar y describir errores específicos de la aplicación.
/// Implementa el protocolo `CustomStringConvertible` para proporcionar descripciones personalizadas de cada error.
enum GAError: Error, CustomStringConvertible {
    
    // MARK: - Tipos de Error
    
    /// Error cuando la solicitud (request) es nula o inválida.
    case requestWasNil
    
    /// Error recibido desde el servidor con el objeto `Error`.
    case errorFromServer(error: Error)
    
    /// Error recibido desde la API con el código de estado HTTP.
    case errorFromApi(statusCode: Int)
    
    /// Error cuando no se reciben datos del servidor.
    case noDataReceived
    
    /// Error al realizar el parsing de datos.
    case errorParsingData
    
    /// Error cuando falta el token de sesión.
    case sessionTokenMissing
    
    /// Error cuando la URL es inválida.
    case badUrl
    
    /// Error cuando las credenciales son inválidas.
    case invalidCredentials
    
    /// Error al codificar las credenciales.
    case errorEncodingCredentials
    
    /// Error al construir la solicitud.
    case errorBuildingRequest
    
    /// Error cuando no se encuentra el héroe con el ID especificado.
    case heroNotFound(idHero: String)
    
    // MARK: - Descripción del Error
    
    /// Descripción personalizada de cada error.
    var description: String {
        switch self {
        case .requestWasNil:
            return "Error creating request"
        case .errorFromServer(error: let error):
            return "Received error from server \((error as NSError).code)"
        case .errorFromApi(statusCode: let code):
            return "Received error from API with status code \(code)"
        case .noDataReceived:
            return "Data not received from server"
        case .errorParsingData:
            return "There was an error parsing data"
        case .sessionTokenMissing:
            return "Session token is missing"
        case .badUrl:
            return "Bad URL"
        case .invalidCredentials:
            return "Invalid credentials"
        case .errorEncodingCredentials:
            return "Error encoding credentials"
        case .errorBuildingRequest:
            return "Error building request"
        case .heroNotFound(idHero: let idHero):
            return "Hero with ID \(idHero) not found"
        }
    }
}
