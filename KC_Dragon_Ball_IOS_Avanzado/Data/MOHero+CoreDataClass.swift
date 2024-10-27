//
//  MOHero+CoreDataClass.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 15/10/24.
//
//

import Foundation
import CoreData

@objc(MOHero)
public class MOHero: NSManagedObject {

}

extension MOHero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOHero> {
        return NSFetchRequest<MOHero>(entityName: "CDHero")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var info: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var photo: String?
    @NSManaged public var locations: Set<MOLocation>? //NSSet?
    @NSManaged public var transformations: Set<MOTransformation>? //NSSet?
}

// MARK: Generated accessors for locations
extension MOHero {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: MOLocation)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: MOLocation)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: Set<MOLocation>)
    //@NSManaged public func addToLocations(_ values: NSSet)
    
    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: Set<MOLocation>)
    //@NSManaged public func removeFromLocations(_ values: NSSet)
}

// MARK: Generated accessors for transformations
extension MOHero {

    @objc(addTransformationsObject:)
    @NSManaged public func addToTransformations(_ value: MOTransformation)

    @objc(removeTransformationsObject:)
    @NSManaged public func removeFromTransformations(_ value: MOTransformation)

    @objc(addTransformations:)
    @NSManaged public func addToTransformations(_ values: Set<MOTransformation>)
    //@NSManaged public func addToTransformations(_ values: NSSet)

    @objc(removeTransformations:)
    @NSManaged public func removeFromTransformations(_ values: Set<MOTransformation>)
    //@NSManaged public func removeFromTransformations(_ values: NSSet)
}

extension MOHero : Identifiable {

}

