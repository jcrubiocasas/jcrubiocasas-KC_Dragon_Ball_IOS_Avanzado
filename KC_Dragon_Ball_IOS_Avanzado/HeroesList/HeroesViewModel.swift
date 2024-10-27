//
//  HeroesViewModel.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 24/10/24.
//

import UIKit

// Enum que representa los posibles estados de actualización de los datos de héroes
enum StatusHeroes {
    case dataUpdated                   // Los datos se han actualizado correctamente
    case error(msg: String)            // Ocurrió un error con el mensaje correspondiente
    case none                          // Estado inicial sin cambios
}

/// ViewModel para gestionar y actualizar la lista de héroes en la vista
class HeroesViewModel {
    
    // MARK: - Properties
    
    let useCase: HeroUseCaseProtocol   // Protocolo de caso de uso que gestiona la lógica de obtención de héroes
    
    /// Variable observable para hacer el binding con la vista y actualizarla según el estado de los datos
    var statusHeroes: GAObservable<StatusHeroes> = GAObservable(.none)
    
    /// Array que almacena los héroes obtenidos
    var heroes: [Hero] = []
    
    // MARK: - Initializer
    
    /// Inicializador de `HeroesViewModel` que asigna un caso de uso
    /// - Parameter useCase: Caso de uso que implementa el protocolo `HeroUseCaseProtocol`
    init(useCase: HeroUseCaseProtocol = HeroUseCase()) {
        self.useCase = useCase
    }
    
    // MARK: - Data Loading Methods
    
    /// Carga datos de héroes aplicando un filtro opcional basado en el nombre
    /// - Parameter filter: Filtro opcional que aplica coincidencia de nombre, si es `nil` se carga toda la lista
    func loadData(filter: String?) {
        var predicate: NSPredicate?
        
        // Configuración del filtro usando el formato CONTAINS con opciones de case insensitive y sin acentos
        if let filter {
            predicate = NSPredicate(format: "name CONTAINS[cd] %@", filter)
        }
        
        // Llama al caso de uso para obtener héroes con el filtro, luego actualiza el estado según el resultado
        useCase.loadHeros(filter: predicate) { [weak self] result in
            switch result {
            case .success(let heros):
                self?.heroes = heros
                self?.statusHeroes.value = .dataUpdated
            case .failure(let error):
                self?.statusHeroes.value = .error(msg: error.description)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Devuelve el héroe en el índice especificado
    /// - Parameter index: Índice del héroe en el array `heroes`
    /// - Returns: Objeto `Hero` correspondiente al índice, o `nil` si el índice es inválido
    func heroAt(index: Int) -> Hero? {
        guard index < heroes.count else {
            return nil
        }
        return heroes[index]
    }
    
}
