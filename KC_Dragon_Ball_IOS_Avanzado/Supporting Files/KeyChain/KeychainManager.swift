//
//  KeychainManager.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 16/10/24.
//

import Foundation
import Security

class KeychainManager {

    // MARK: - Singleton Instance
    static let shared = KeychainManager()

    // MARK: - Inicialización
    // Inicializador privado para evitar que se creen múltiples instancias de `KeychainManager` fuera de la clase
    private init() {}

    // MARK: - Métodos para guardar y recuperar datos

    /// Guarda datos en el Keychain bajo un identificador de cuenta
    /// - Parameters:
    ///   - data: Los datos en forma de String que se desean almacenar.
    ///   - account: El identificador de la cuenta con la que se asocian los datos.
    /// - Returns: Devuelve `true` si los datos se almacenaron exitosamente, de lo contrario `false`.
    func saveData(_ data: String, for account: String) -> Bool {
        // Convierte los datos de String a Data
        guard let dataValue = data.data(using: .utf8) else { return false }

        // Configura los atributos necesarios para almacenar los datos en el Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,  // Indica que es una contraseña genérica
            kSecAttrAccount as String: account,             // La cuenta con la que se asocian los datos
            kSecValueData as String: dataValue              // Los datos convertidos a Data
        ]

        // Elimina cualquier entrada existente en el Keychain con la misma cuenta, para evitar duplicados
        SecItemDelete(query as CFDictionary)
        
        // Añade los nuevos datos al Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // Devuelve `true` si la operación fue exitosa, `false` en caso contrario
        return status == errSecSuccess
    }

    /// Recupera datos almacenados en el Keychain para una cuenta específica
    /// - Parameter account: El identificador de la cuenta.
    /// - Returns: El valor de los datos almacenados como String si se encuentra, o `nil` si no existe.
    func getData(for account: String) -> String? {
        // Define la consulta para buscar los datos en el Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,  // Tipo de dato: contraseña genérica
            kSecAttrAccount as String: account,             // La cuenta con la que se asocian los datos
            kSecReturnData as String: kCFBooleanTrue!,      // Devuelve los datos si los encuentra
            kSecMatchLimit as String: kSecMatchLimitOne     // Limita el resultado a un solo ítem
        ]

        var result: AnyObject?
        
        // Realiza la búsqueda en el Keychain
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        // Si se encuentran los datos, se convierten a String y se devuelven
        guard status == errSecSuccess, let data = result as? Data,
              let stringValue = String(data: data, encoding: .utf8) else {
            return nil  // Devuelve `nil` si no se encuentra o hay un error
        }

        return stringValue  // Devuelve los datos recuperados
    }

    // MARK: - Métodos para actualizar y eliminar datos
    
    /// Actualiza los datos existentes en el Keychain para una cuenta específica
    /// - Parameters:
    ///   - newData: El nuevo valor que reemplazará a los datos actuales.
    ///   - account: El identificador de la cuenta.
    /// - Returns: `true` si los datos fueron actualizados exitosamente, `false` en caso contrario.
    func updateData(_ newData: String, for account: String) -> Bool {
        // Convierte los nuevos datos de String a Data
        guard let dataValue = newData.data(using: .utf8) else { return false }

        // Define la consulta para encontrar los datos existentes
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,  // Tipo de dato: contraseña genérica
            kSecAttrAccount as String: account              // La cuenta con la que se asocian los datos
        ]

        // Los atributos que se van a actualizar (en este caso, el nuevo valor de los datos)
        let attributes: [String: Any] = [
            kSecValueData as String: dataValue  // Los nuevos datos convertidos a Data
        ]

        // Intenta actualizar los datos en el Keychain
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        // Devuelve `true` si la actualización fue exitosa, `false` en caso contrario
        return status == errSecSuccess
    }

    /// Elimina los datos asociados a una cuenta específica del Keychain
    /// - Parameter account: El identificador de la cuenta.
    /// - Returns: `true` si los datos fueron eliminados exitosamente, `false` en caso contrario.
    func deleteData(for account: String) -> Bool {
        // Define la consulta para identificar los datos en el Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,  // Tipo de dato: contraseña genérica
            kSecAttrAccount as String: account              // La cuenta con la que se asocian los datos
        ]

        // Intenta eliminar los datos del Keychain
        let status = SecItemDelete(query as CFDictionary)
        
        // Devuelve `true` si los datos fueron eliminados exitosamente, `false` en caso contrario
        return status == errSecSuccess
    }
}
