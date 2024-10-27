//
//  Transformation.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 13/10/24.
//

// MARK: - Transformation
// Esta estructura representa una transformación de un héroe en la aplicación.
// Conforma el protocolo `Hashable`, permitiendo que instancias de `Transformation` puedan usarse en estructuras de datos como Sets y diccionarios.
struct Transformation: Hashable { // Conformidad con Hashable para uso en colecciones de datos

    let id: String // Identificador único de la transformación
    let name: String // Nombre descriptivo de la transformación
    let info: String // Información detallada de la transformación
    let photo: String // URL o nombre de archivo de la imagen de la transformación
    
    /// Constructor para inicializar `Transformation` desde una instancia de `MOTransformation` de Core Data
    init(moTransformation: MOTransformation) {
        self.id = moTransformation.id ?? "" // Asigna el id o una cadena vacía si es nulo
        self.name = moTransformation.name ?? "" // Asigna el nombre o una cadena vacía si es nulo
        self.info = moTransformation.info ?? "" // Asigna la información o una cadena vacía si es nulo
        self.photo = moTransformation.photo ?? "" // Asigna la URL de la foto o una cadena vacía si es nulo
    }
    
    /// Constructor para inicializar `Transformation` desde una instancia de `ApiTransformation`
    init(apiTransformation: ApiTransformation) {
        self.id = apiTransformation.id ?? "" // Asigna el id desde la API o una cadena vacía si es nulo
        self.name = apiTransformation.name ?? "" // Asigna el nombre desde la API o una cadena vacía si es nulo
        self.info = apiTransformation.description ?? "" // Asigna la descripción desde la API o una cadena vacía si es nulo
        self.photo = apiTransformation.photo ?? "" // Asigna la URL de la foto desde la API o una cadena vacía si es nulo
    }
}
