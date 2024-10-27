//
//  Hero.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 13/10/24.
//

import Foundation

/// Modelo de dominio `Hero`, utilizado en la capa de presentación
struct Hero: Hashable { // Conformidad con `Hashable` para uso en colecciones de datos
    
    let id: String // Identificador único del héroe
    let name: String // Nombre del héroe
    let info: String // Descripción detallada del héroe
    let photo: String // URL de la foto del héroe
    let favorite: Bool // Indica si el héroe es favorito del usuario
    
    /// Constructor para inicializar `Hero` a partir de un objeto `MOHero` de Core Data
    init(moHero: MOHero) {
        self.id = moHero.id ?? "" // Asigna el id o una cadena vacía si es nulo
        self.name = moHero.name ?? "" // Asigna el nombre o una cadena vacía si es nulo
        self.info = moHero.info ?? "" // Asigna la información o una cadena vacía si es nulo
        self.photo = moHero.photo ?? "" // Asigna la URL de la foto o una cadena vacía si es nulo
        self.favorite = moHero.favorite // Asigna el valor booleano para favorito
    }
}
