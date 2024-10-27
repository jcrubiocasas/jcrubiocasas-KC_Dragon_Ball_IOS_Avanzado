import Foundation

/// Use case para Transformations que provee información relacionada con transformaciones de héroes
protocol TransformationUseCaseProtocol {
    // Define el método para cargar transformaciones con un filtro opcional y un ID de héroe
    func loadTransformations_(filter: NSPredicate?, id: String?, completion: @escaping ((Result<[Transformation], GAError>) -> Void)) // Método de carga de transformaciones
}

class TransformationUseCase: TransformationUseCaseProtocol {
    
    private var apiProvider: ApiProviderProtocol // Proveedor de API para obtener datos de transformaciones
    private var storeDataProvider: StoreDataProvider // Proveedor de almacenamiento local
    
    // Inicializador con dependencias inyectadas (ApiProvider y StoreDataProvider)
    init(apiProvider: ApiProviderProtocol = ApiProvider(), storeDataProvider: StoreDataProvider = .shared) { // Asignación de dependencias por defecto
        self.apiProvider = apiProvider // Asigna el proveedor de API
        self.storeDataProvider = storeDataProvider // Asigna el proveedor de almacenamiento local
    }
    
    // Implementación del método que carga las transformaciones
    func loadTransformations_(filter: NSPredicate? = nil, id: String? = "", completion: @escaping ((Result<[Transformation], GAError>) -> Void)) { // Método para cargar transformaciones desde la BD o API
        let localTransformations = storeDataProvider.fetchTransformations(filter: filter) // Obtiene transformaciones de la BD usando el filtro
        
        if !localTransformations.isEmpty { // Si hay transformaciones en la BD
            let transformation = localTransformations.map { Transformation(moTransformation: $0) } // Mapea de MOTransformation a Transformation
            completion(.success(transformation)) // Devuelve las transformaciones desde la BD
        } else {
            // Si no hay transformaciones en la BD, se llama a la API con el ID del héroe
            apiProvider.loadTransformations(id: id ?? "") { [weak self] result in // Carga transformaciones desde la API usando el ID
                switch result {
                case .success(let apiTransformations):
                    // Guardamos las transformaciones obtenidas de la API en la base de datos local
                    self?.storeDataProvider.add(transformations: apiTransformations) // Añade transformaciones a la BD
                    let transformations = apiTransformations.map { Transformation(apiTransformation: $0) } // Mapea de ApiTransformation a Transformation
                    completion(.success(transformations)) // Devuelve las transformaciones obtenidas de la API
                case .failure(let error):
                    completion(.failure(error)) // En caso de error, lo devuelve en el completion
                }
            }
        }
    }
}
