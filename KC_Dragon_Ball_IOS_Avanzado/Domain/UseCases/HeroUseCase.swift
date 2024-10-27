//
//  HeroUseCase.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 16/10/24.
//

import Foundation

/// Use case de Heroes que provee información relacionada con héroes
protocol HeroUseCaseProtocol { // Define el protocolo para cargar héroes
    func loadHeros(filter: NSPredicate?, completion: @escaping ((Result<[Hero], GAError>) -> Void)) // Método para cargar héroes con filtro opcional
}

class HeroUseCase: HeroUseCaseProtocol { // Implementación del caso de uso de héroes
    
    private var apiProvider: ApiProviderProtocol // Proveedor de API para obtener datos de héroes
    private var storeDataPRovider: StoreDataProvider // Proveedor de almacenamiento de datos
    
    init(apiProvider: ApiProviderProtocol = ApiProvider(),
         storeDataPRovider: StoreDataProvider = .shared) { // Inicializador con valores por defecto
        self.apiProvider = apiProvider // Asigna el proveedor de API
        self.storeDataPRovider = storeDataPRovider // Asigna el proveedor de almacenamiento
    }
    
    // Carga héroes desde la BD local o la API si no están en la BD
    func loadHeros(filter: NSPredicate? = nil, completion: @escaping ((Result<[Hero], GAError>) -> Void)) { // Método para cargar héroes con filtro opcional
        
        let localHeroes = storeDataPRovider.fetchHeroes(filter: filter) // Obtiene héroes de la BD
        if !localHeroes.isEmpty { // Verifica si hay héroes en la BD
            let heroes = localHeroes.map { Hero(moHero: $0) } // Mapea MOHero a Hero
            completion(.success(heroes)) // Devuelve héroes de la BD
        } else {
            apiProvider.loadHeros(name: filter?.predicateFormat ?? "") { [weak self] result in // Si no hay héroes, llama a la API
                switch result {
                case .success(let apiHeroes):
                    DispatchQueue.main.async {
                        self?.storeDataPRovider.add(heroes: apiHeroes) // Guarda héroes en la BD
                        let bdHeroes = self?.storeDataPRovider.fetchHeroes(filter: filter) ?? [] // Obtiene héroes de la BD
                        let heroes = bdHeroes.map { Hero(moHero: $0) } // Mapea ApiHero a Hero
                        completion(.success(heroes)) // Devuelve los héroes
                    }
                case .failure(let error):
                    completion(.failure(error)) // En caso de error, lo devuelve
                }
            }
        }
    }
}
