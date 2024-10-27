//
//  KCDBApiProvider.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 16/10/24.
//

import Foundation

/// Protocolo para definir los métodos que el `ApiProvider` debe implementar
protocol ApiProviderProtocol {
    /// Carga una lista de héroes que coinciden con el nombre dado
    func loadHeros(name: String, completion: @escaping ((Result<[ApiHero], GAError>) -> Void))
    
    /// Carga las ubicaciones asociadas a un héroe específico
    func loadLocations(id: String, completion: @escaping ((Result<[ApiLocation], GAError>) -> Void))
    
    /// Carga las transformaciones asociadas a un héroe específico
    func loadTransformations(id: String, completion: @escaping ((Result<[ApiTransformation], GAError>) -> Void))
    
    /// Obtiene el token de autenticación usando email y password
    func loadToken(email: String, password: String, completion: @escaping ((Result<String, GAError>) -> Void))
}

/// Clase que implementa la lógica de red para interactuar con la API
class ApiProvider: ApiProviderProtocol {
    
    // MARK: - Properties
    
    /// Sesión de red
    private let session: URLSession
    
    /// Constructor de solicitudes HTTP
    private let requestBuilder: GARequestBuilder
    
    /// Inicializador que permite la inyección de una sesión y un constructor de solicitudes personalizado
    init(session: URLSession = .shared, requestBuilder: GARequestBuilder = GARequestBuilder()) {
        self.session = session
        self.requestBuilder = requestBuilder
    }
    
    // MARK: - ApiProviderProtocol Methods
    
    /// Llama al endpoint para obtener héroes, aplicando un filtro opcional por nombre
    func loadHeros(name: String = "", completion: @escaping ((Result<[ApiHero], GAError>) -> Void)) {
        do {
            // Construimos la solicitud usando el constructor de solicitudes
            let request = try requestBuilder.buildRequest(endPoint: .heroes, params: ["name": name])
            // Realizamos la petición
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Llama al endpoint para obtener las ubicaciones asociadas a un héroe
    func loadLocations(id: String, completion: @escaping ((Result<[ApiLocation], GAError>) -> Void)) {
        do {
            // Construimos la solicitud usando el constructor de solicitudes
            let request = try requestBuilder.buildRequest(endPoint: .locations, params: ["id": id])
            // Realizamos la petición
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Llama al endpoint para obtener las transformaciones de un héroe
    func loadTransformations(id: String, completion: @escaping ((Result<[ApiTransformation], GAError>) -> Void)) {
        do {
            // Construimos la solicitud usando el constructor de solicitudes
            let request = try requestBuilder.buildRequest(endPoint: .transformations, params: ["id": id])
            // Realizamos la petición
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Llama al endpoint de login para obtener un token de autenticación
    func loadToken(email: String, password: String, completion: @escaping ((Result<String, GAError>) -> Void)) {
        // Codificamos las credenciales de email y password en base64
        let credentials = "\(email):\(password)"
        guard let encodedCredentials = credentials.data(using: .utf8)?.base64EncodedString() else {
            completion(.failure(.errorEncodingCredentials))
            return
        }
        
        do {
            // Construimos la solicitud de login
            var request = try requestBuilder.buildRequest(endPoint: .login, params: [:])
            // Añadimos el encabezado de autenticación Basic con las credenciales en base64
            request.addValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
            
            // Realizamos la petición
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(.errorBuildingRequest))
        }
    }
    
    // MARK: - Helper Methods
    
    /// Método genérico que realiza una petición de red, maneja el resultado y decodifica el tipo esperado
    private func makeRequest<T: Decodable>(request: URLRequest, completion: @escaping ((Result<T, GAError>) -> Void)) {
        session.dataTask(with: request) { data, response, error in
            if let error {
                // Si se recibe un error desde el servidor, se llama al bloque de finalización con el error
                completion(.failure(.errorFromServer(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                // Si la respuesta no es válida, se llama al bloque de finalización con un error
                completion(.failure(.noDataReceived))
                return
            }
            
            let statusCode = httpResponse.statusCode
            debugPrint("HTTP Status Code: \(statusCode)")
            // Si el código de estado no es 200, se trata como un error de la API
            if statusCode != 200 {
                completion(.failure(.errorFromApi(statusCode: statusCode)))
                return
            }
            
            if let data {
                debugPrint("JSON Data: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
                do {
                    if T.self == String.self {
                        // Si el tipo esperado es un String, tratamos los datos como una cadena
                        let apiToken = String(data: data, encoding: .utf8)
                        completion(.success(apiToken as! T))
                    } else {
                        // Si no, intentamos decodificar los datos en el tipo esperado
                        let apiInfo = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(apiInfo))
                    }
                } catch {
                    // Si ocurre un error de decodificación, se llama al bloque de finalización con un error
                    completion(.failure(.errorParsingData))
                }
            } else {
                // Si no se recibe ningún dato, se llama al bloque de finalización con un error
                completion(.failure(.noDataReceived))
            }
        }.resume()
    }
}
