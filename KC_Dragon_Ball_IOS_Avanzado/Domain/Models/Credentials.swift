//
//  Credentials.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 13/10/24.
//

// MARK: - Credentials
// Esta estructura representa las credenciales de un usuario, que contienen un nombre de usuario (`username`) y una contraseña (`password`).
// Se utiliza comúnmente en solicitudes de autenticación, como parte del cuerpo o las cabeceras de una solicitud HTTP.
struct Credentials { // Estructura para almacenar las credenciales de inicio de sesión de un usuario
    
    let username: String // El nombre de usuario proporcionado por el usuario
    let password: String // La contraseña proporcionada por el usuario
}
