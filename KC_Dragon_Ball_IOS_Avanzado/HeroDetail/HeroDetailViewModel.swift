//
//  HeroDetailViewModel.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 25/10/24.
//

import Foundation

// MARK: - StatusHeroDetail Enum
/// Enum que define los posibles estados del detalle del héroe.
enum StatusHeroDetail {
    case locationUpdated          // Indica que las ubicaciones han sido actualizadas.
    case transformationsUpdated    // Indica que las transformaciones han sido actualizadas.
    case error(msg: String)        // Indica que ocurrió un error, con un mensaje asociado.
    case none                      // Estado inicial sin cambios.
}

// MARK: - HeroDetailViewModel Class
/// ViewModel encargado de gestionar el detalle de un héroe, incluyendo sus ubicaciones y transformaciones.
class HeroDetailViewModel {
    
    // MARK: - Properties
    
    private let hero: Hero
    var heroTransformations: [Transformation] = []
    var heroLocations: [Location] = []
    private let useCase: HeroDetailUseCaseProtocol
    
    // Anotaciones para el mapa
    var annotations: [HeroAnnotation] = []
    
    // Estado observable para la vista
    var statusHeroDetail: GAObservable<StatusHeroDetail> = GAObservable(.none)
    
    // MARK: - Initializers
    
    /// Inicializa el ViewModel con un héroe y un caso de uso.
    /// - Parameters:
    ///   - hero: El héroe para el cual se obtendrán detalles.
    ///   - useCase: Caso de uso para obtener datos del héroe.
    init(hero: Hero, useCase: HeroDetailUseCaseProtocol = HeroDetailUseCase()) {
        self.hero = hero
        self.useCase = useCase
        self.loadData(id: hero.id)
    }
    
    // MARK: - Data Loading
    
    /// Carga las transformaciones y ubicaciones del héroe.
    /// - Parameter id: ID del héroe.
    func loadData(id: String?) {
        loadTransformations(id: id)
        loadLocations(id: id)
    }
    
    /// Carga las transformaciones del héroe desde el caso de uso.
    /// - Parameter id: ID del héroe.
    private func loadTransformations(id: String?) {
        DispatchQueue.main.async {
            self.useCase.loadTransformationsForHeroWithId(id: id ?? "") { [weak self] result in
                switch result {
                case .success(let transformations):
                    self?.heroTransformations = transformations
                    debugPrint("Transformations: \(String(describing: self?.heroTransformations))")
                    debugPrint("Número de transformaciones: \(transformations.count)")
                    if transformations.count > 0 {
                        self?.statusHeroDetail.value = .transformationsUpdated
                    }
                case .failure(let error):
                    self?.statusHeroDetail.value = .error(msg: error.description)
                }
            }
        }
    }
    
    /// Carga las ubicaciones del héroe desde el caso de uso.
    /// - Parameter id: ID del héroe.
    private func loadLocations(id: String?) {
        DispatchQueue.main.async {
            self.useCase.loadLocationsForHeroWithId(id: id ?? "") { [weak self] result in
                switch result {
                case .success(let locations):
                    self?.heroLocations = locations
                    debugPrint("Locations: \(String(describing: self?.heroLocations))")
                    debugPrint("Número de ubicaciones: \(String(describing: self?.heroLocations.count))")
                    self?.statusHeroDetail.value = .locationUpdated
                case .failure(let error):
                    self?.statusHeroDetail.value = .error(msg: error.description)
                }
            }
        }
    }
    
    // MARK: - Annotation Management
    
    /// Crea anotaciones para cada ubicación del héroe.
    private func createAnnotations() {
        self.annotations = []
        heroLocations.forEach { [weak self] location in
            guard let coordinate = location.coordinate else { return }
            let annotation = HeroAnnotation(title: self?.hero.name, coordinate: coordinate)
            self?.annotations.append(annotation)
        }
        self.statusHeroDetail.value = .locationUpdated
    }
    
    // MARK: - Hero Information Retrieval
    
    /// Obtiene el nombre del héroe.
    func getHeroName() -> String {
        return hero.name
    }
    
    /// Obtiene la descripción del héroe.
    func getHeroDescription() -> String {
        return hero.info
    }
    
    /// Obtiene la URL de la foto del héroe.
    func getHeroPhotoURL() -> URL? {
        return URL(string: hero.photo)
    }
}
