//
//  MOTransformation+CoreDataClass.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 15/10/24.
//
//

import Foundation
import CoreData

/// Clase `MOTransformation` generada por Xcode para representar una transformación en Core Data como un objeto gestionado.
@objc(MOTransformation)
public class MOTransformation: NSManagedObject { // Clase Core Data que permite la manipulación de transformaciones de héroes.
}

extension MOTransformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOTransformation> { // Método para crear una solicitud de consulta específica para `MOTransformation`
        return NSFetchRequest<MOTransformation>(entityName: "CDTransformation") // Consulta la entidad "CDTransformation" en Core Data
    }

    @NSManaged public var id: String? // ID único de la transformación
    @NSManaged public var name: String? // Nombre de la transformación
    @NSManaged public var info: String? // Descripción detallada de la transformación
    @NSManaged public var photo: String? // URL o ruta de la imagen de la transformación
    @NSManaged public var hero: MOHero? // Relación con el héroe asociado a esta transformación
}

extension MOTransformation: Identifiable { // Extensión para permitir que `MOTransformation` sea identificable
}
