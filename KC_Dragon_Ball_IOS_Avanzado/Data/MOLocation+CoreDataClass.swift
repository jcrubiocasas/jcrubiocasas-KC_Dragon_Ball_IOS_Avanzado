//
//  MOLocation+CoreDataClass.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 15/10/24.
//
//

import Foundation
import CoreData

@objc(MOLocation)
public class MOLocation: NSManagedObject { // Clase `MOLocation` que representa una ubicación en Core Data como un objeto gestionado
}

extension MOLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOLocation> { // Método para crear una solicitud de consulta específica para `MOLocation`
        return NSFetchRequest<MOLocation>(entityName: "CDLocation") // Consulta a la entidad "CDLocation" en Core Data
    }

    @NSManaged public var id: String? // ID único de la ubicación
    @NSManaged public var longitude: String? // Longitud de la ubicación
    @NSManaged public var latitude: String? // Latitud de la ubicación
    @NSManaged public var date: String? // Fecha asociada a la ubicación
    @NSManaged public var hero: MOHero? // Relación con el héroe asociado a esta ubicación
}

extension MOLocation: Identifiable { // Extensión para permitir que `MOLocation` sea identificable
}
