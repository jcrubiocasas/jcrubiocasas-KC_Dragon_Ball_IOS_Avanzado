import Foundation

/// Caso de uso para el detalle del héroe, se encarga de obtener las localizaciones de un héroe y de sus transformaciones
protocol HeroDetailUseCaseProtocol { // Protocolo que define los métodos de carga para transformaciones y localizaciones
    func loadTransformationsForHeroWithId(id: String, completion: @escaping (Result<[Transformation], GAError>) -> Void) // Método para cargar transformaciones del héroe
    func loadLocationsForHeroWithId(id: String, completion: @escaping (Result<[Location], GAError>) -> Void) // Método para cargar localizaciones del héroe
}

class HeroDetailUseCase: HeroDetailUseCaseProtocol { // Implementación del caso de uso del detalle del héroe
    private var apiProvider: ApiProviderProtocol // Proveedor de API para obtener datos
    private var storeDataProvider: StoreDataProvider // Proveedor de almacenamiento de datos
    
    init(apiProvider: ApiProviderProtocol = ApiProvider(), storeDataProvider: StoreDataProvider = .shared) { // Inicializador con valores por defecto
        self.apiProvider = apiProvider // Asigna el proveedor de API
        self.storeDataProvider = storeDataProvider // Asigna el proveedor de almacenamiento
    }
    
    /// Función que recupera de la BBDD un Hero para un id
    private func getHeroWith(id: String) -> MOHero? { // Función para obtener un héroe de la base de datos
        let predicate = NSPredicate(format: "id == %@", id) // Define el filtro por ID
        let heroes = storeDataProvider.fetchHeroes(filter: predicate) // Obtiene héroes de la BD
        return heroes.first // Devuelve el primer héroe encontrado o nil
    }
    
    func loadTransformationsForHeroWithId(id: String, completion: @escaping (Result<[Transformation], GAError>) -> Void) { // Carga las transformaciones de un héroe desde la BD o API
        
        guard let hero = self.getHeroWith(id: id) else { // Verifica si el héroe existe en la BD
            debugPrint("Hero with id \(id) not found") // Imprime un mensaje si no se encuentra el héroe
            completion(.failure(.heroNotFound(idHero: id))) // Completa con error si no se encuentra
            return
        }
        
        let bdTransformations = hero.transformations ?? [] // Obtiene las transformaciones del héroe de la BD
        
        if !bdTransformations.isEmpty { // Si hay transformaciones en la BD
            let domainTransformations = bdTransformations.map({ Transformation(moTransformation: $0) }) // Mapea MOTransformation a Transformation
                .sorted(by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending }) // Ordena las transformaciones por nombre
            completion(.success(domainTransformations)) // Devuelve las transformaciones de la BD
        } else {
            apiProvider.loadTransformations(id: id) { [weak self] result in // Si no hay transformaciones, llama a la API
                switch result {
                case .success(let transformations):
                    self?.storeDataProvider.add(transformations: transformations) // Guarda las transformaciones en la BD
                    
                    let bdTransformations = hero.transformations ?? [] // Obtiene las transformaciones de la BD
                    let domainTransformations = bdTransformations.map({ Transformation(moTransformation: $0) }) // Mapea y ordena las transformaciones
                        .sorted(by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending })
                    
                    completion(.success(domainTransformations)) // Devuelve las transformaciones
                case .failure(let error):
                    completion(.failure(error)) // En caso de error, lo devuelve
                }
            }
        }
    }
    
    func loadLocationsForHeroWithId(id: String, completion: @escaping (Result<[Location], GAError>) -> Void) { // Carga las localizaciones de un héroe desde la BD o API
        guard let hero = self.getHeroWith(id: id) else { // Verifica si el héroe existe en la BD
            debugPrint("Hero with id \(id) not found") // Imprime un mensaje si no se encuentra el héroe
            completion(.failure(.heroNotFound(idHero: id))) // Completa con error si no se encuentra
            return
        }
        
        let bdLocations = hero.locations ?? [] // Obtiene las localizaciones del héroe de la BD
        
        if !bdLocations.isEmpty { // Si hay localizaciones en la BD
            let domainLocations = bdLocations.map({Location(moLocation: $0)}) // Mapea MOLocation a Location
            completion(.success(domainLocations)) // Devuelve las localizaciones de la BD
        } else {
            apiProvider.loadLocations(id: id) { [weak self] result in // Si no hay localizaciones, llama a la API
                switch result {
                case .success(let locations):
                    self?.storeDataProvider.add(locations: locations) // Guarda las localizaciones en la BD
                    let bdLocations = hero.locations ?? [] // Obtiene las localizaciones de la BD
                    let domainLocations = bdLocations.map({Location(moLocation: $0)}) // Mapea y devuelve las localizaciones
                    completion(.success(domainLocations))
                case .failure(let error):
                    completion(.failure(error)) // En caso de error, lo devuelve
                }
            }
        }
    }
}
