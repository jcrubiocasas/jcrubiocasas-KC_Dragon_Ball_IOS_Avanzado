//
//  StoreDataProvider.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 16/10/24.
//

import CoreData

enum TypePersistency {
    case disk // Tipo de persistencia en disco
    case inMemory // Tipo de persistencia en memoria, útil para pruebas
}

/// Clase que representa el stack de Core Data
class StoreDataProvider {
    
    static var shared: StoreDataProvider = .init() // Singleton para acceso global a la instancia de Core Data
    
    static var managedModel: NSManagedObjectModel = {
        let bundle = Bundle(for: StoreDataProvider.self) // Bundle para cargar el modelo
        guard let url = bundle.url(forResource: "Model", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Error loading model") // Manejo de error si el modelo no se carga
        }
        return model // Devuelve el modelo cargado
    }()
    
    private let persistentContainer: NSPersistentContainer // Contenedor persistente de Core Data
    private let persistency: TypePersistency // Tipo de persistencia especificado
    
    private var context: NSManagedObjectContext { // Contexto principal de Core Data
        let viewContext = persistentContainer.viewContext
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump // Política de resolución de conflictos
        return viewContext
    }
    
    init(persistency: TypePersistency = .disk) {
        self.persistency = persistency // Configura el tipo de persistencia
        self.persistentContainer = NSPersistentContainer(name: "Model", managedObjectModel: Self.managedModel) // Inicializa el contenedor con el modelo cargado
        if self.persistency == .inMemory { // Configuración en memoria si es el tipo seleccionado
            let persistentStore = persistentContainer.persistentStoreDescriptions.first
            persistentStore?.url = URL(filePath: "/dev/null")
        }
        self.persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Error loading BBDD \(error.localizedDescription)") // Manejo de error de carga de almacén persistente
            }
        }
    }
    
    // Ejecuta una solicitud de consulta de Core Data
    func perform<T: NSFetchRequestResult>(request: NSFetchRequest<T>) throws -> [T] {
        return try context.fetch(request) // Ejecuta la consulta en el contexto
    }
    
    // Guarda el contexto si hay cambios pendientes
    func save() {
        if context.hasChanges { // Verifica si hay cambios pendientes
            do {
                try context.save() // Guarda los cambios en el contexto
            } catch {
                debugPrint("Error saving context \(error.localizedDescription)") // Manejo de error al guardar el contexto
            }
        }
    }
    
    // Borra toda la base de datos
    func clearBBDD() {
        
        let batchDeleteHeroes = NSBatchDeleteRequest(fetchRequest: MOHero.fetchRequest()) // Solicitud de borrado en lote para héroes
        let batchDeleteLocations = NSBatchDeleteRequest(fetchRequest: MOLocation.fetchRequest()) // Solicitud de borrado para localizaciones
        let batchDeleteTransformations = NSBatchDeleteRequest(fetchRequest: MOTransformation.fetchRequest()) // Solicitud de borrado para transformaciones
        
        let deleteTasks = [batchDeleteHeroes, batchDeleteLocations, batchDeleteTransformations] // Tareas de borrado a ejecutar
        
        for task in deleteTasks {
            do {
                try context.execute(task) // Ejecuta cada tarea de borrado
                context.reset() // Restaura el contexto tras cada borrado
            } catch {
                debugPrint("Error clearing BBDD \(error.localizedDescription)") // Manejo de error en el borrado
            }
        }
    }
}

// MARK: - Extensión para operaciones de Core Data
extension StoreDataProvider {
    
    /// Inserta MOHero a partir de un array de ApiHero
    func add(heroes: [ApiHero]) {
        for hero in heroes {
            if let id = hero.id, let name = hero.name {
                let newHero = MOHero(context: context) // Crea nuevo objeto MOHero
                newHero.id = id
                newHero.name = name
                newHero.info = hero.description
                newHero.favorite = hero.favorite
                newHero.photo = hero.photo
            } else {
                debugPrint("Datos incompletos \(hero)") // Log de datos incompletos
            }
        }
        save() // Guarda después de insertar todos los héroes
    }
    
    /// Obtiene los héroes que cumplen con el filtro especificado
    func fetchHeroes(filter: NSPredicate?, sortAscending: Bool = true) -> [MOHero] {
        let request = MOHero.fetchRequest() // Crea una solicitud de consulta para MOHero
        
        if let filter = filter { request.predicate = filter } // Aplica filtro si existe
        
        let sortDescriptor = NSSortDescriptor(keyPath: \MOHero.name, ascending: sortAscending) // Configura el orden
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request) // Ejecuta la consulta y devuelve resultados
        } catch {
            debugPrint("Error loading heroes \(error.localizedDescription)") // Log de error en la consulta
            return []
        }
    }
    
    /// Inserta MOTransformation a partir de un array de ApiTransformation
    func add(transformations: [ApiTransformation]) {
        for transformation in transformations {
            if let id = transformation.id, let name = transformation.name {
                let newTransformation = MOTransformation(context: context) // Crea objeto MOTransformation
                newTransformation.id = id
                newTransformation.name = name
                newTransformation.info = transformation.description
                newTransformation.photo = transformation.photo
                
                if let heroId = transformation.hero?.id { // Relación con el héroe correspondiente
                    let predicate = NSPredicate(format: "id == %@", heroId)
                    if let hero = fetchHeroes(filter: predicate).first, hero.managedObjectContext != nil {
                        newTransformation.hero = hero
                        hero.addToTransformations(newTransformation) // Agrega transformación al héroe
                    } else {
                        print("El héroe ha sido eliminado del contexto o es nulo.") // Log de error en relación
                    }
                }
            } else {
                print("Error: Datos incompletos para la transformación \(transformation)") // Log de error en datos incompletos
            }
        }
        save() // Guarda después de insertar cada transformación
    }
    
    /// Inserta MOLocation a partir de un array de ApiLocation
    func add(locations: [ApiLocation]) {
        for location in locations {
            if let id = location.id, let latitude = location.latitude, let longitude = location.longitude {
                let newLocation = MOLocation(context: context) // Crea objeto MOLocation
                newLocation.id = id
                newLocation.latitude = latitude
                newLocation.longitude = longitude
                newLocation.date = location.date
                
                if let heroId = location.hero?.id { // Relación con el héroe correspondiente
                    let predicate = NSPredicate(format: "id == %@", heroId)
                    if let hero = fetchHeroes(filter: predicate).first {
                        newLocation.hero = hero
                        hero.addToLocations(newLocation) // Agrega localización al héroe
                    }
                }
            } else {
                print("Error: Datos incompletos para la localización \(location)") // Log de error en datos incompletos
            }
        }
        save() // Guarda después de insertar cada localización
    }
    
    /// Obtiene las transformaciones de los héroes que cumplen con el filtro
    func fetchTransformations(filter: NSPredicate?, sortAscending: Bool = true) -> [MOTransformation] {
        let request = MOTransformation.fetchRequest() // Solicitud de consulta para MOTransformation
        request.predicate = filter // Aplica filtro si existe
        let sortDescriptor = NSSortDescriptor(keyPath: \MOTransformation.hero?.id, ascending: sortAscending) // Configura el orden
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request) // Ejecuta la consulta y devuelve resultados
        } catch {
            debugPrint("Error loading transformations \(error.localizedDescription)") // Log de error en la consulta
            return []
        }
    }
}
