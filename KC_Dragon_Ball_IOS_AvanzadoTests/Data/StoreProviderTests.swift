//
//  GokuAndFriendsTests.swift
//  GokuAndFriendsTests
//
//  Created by Pedro on 14/10/24.
//

import XCTest
import CoreData

// Nos prmite acceder a todas las clases de la app para hacer los tests
@testable import KC_Dragon_Ball_IOS_Avanzado

// Subclase de StoreDataProvider para poder testar los casos de error en fetch Heroes
class StoreDataProviderErrorMock: StoreDataProvider {
    override func perform<T>(request: NSFetchRequest<T>) throws -> [T] {
        throw GAError.noDataReceived
    }
}


/// Tests del Stack  de Core Data y su extension
// Importante en los target de tests solo deben estar los ficheros necesarios y creados para tests

final class StoreProviderTests: XCTestCase {
    
    var sut: StoreDataProvider!

    /// Inicializamos sut en cada Test
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StoreDataProvider(persistency: .inMemory)
        
    }

    // Eliminamos sut con cada Test
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_addHeroes_shouldReturnTheItemsInserted() throws {
        // Given
        let initialCount = sut.fetchHeroes(filter: nil).count
        let apiHero = ApiHero(id: "123", name: "name", description: "description", photo: "photo", favorite: false)
        
        // When
        sut.add(heroes: [apiHero])
        let heroes = sut.fetchHeroes(filter: nil)
        let finalCount = heroes.count
        
        // Then
        // Validamos los resueltados y que el  los valores de los atributos del objeto son los corectos.
        XCTAssertEqual(finalCount, initialCount + 1)
        let hero = try XCTUnwrap(heroes.first)  // Nos permite desenpaquetar un opcional de forma segura, si no falla el test
        XCTAssertEqual(hero.id, apiHero.id)
        XCTAssertEqual(hero.name, apiHero.name)
        XCTAssertEqual(hero.info, apiHero.description)
        XCTAssertEqual(hero.photo, apiHero.photo)
        XCTAssertEqual(hero.favorite, apiHero.favorite)
    }
    
    func test_fetchHeroes_ShoulBeSortedAsc() throws {
        // Given
        let initialCount = sut.fetchHeroes(filter: nil).count
        let apiHero = ApiHero(id: "123", name: "Luis", description: "description", photo: "photo", favorite: true)
        let apiHero2 = ApiHero(id: "1234", name: "Alberto", description: "description", photo: "photo", favorite: false)
        
        // When
        sut.add(heroes: [apiHero, apiHero2])
        let heroes = sut.fetchHeroes(filter: nil)
        
        //Then
        // Validamos los resueltados y que el  los valores de los atributos del objeto son los corectos.
        XCTAssertEqual(initialCount, 0)
        let hero = try XCTUnwrap(heroes.first)
        
        XCTAssertEqual(hero.id, apiHero2.id)
        XCTAssertEqual(hero.name, apiHero2.name)
        XCTAssertEqual(hero.info, apiHero2.description)
        XCTAssertEqual(hero.photo, apiHero2.photo)
        XCTAssertEqual(hero.favorite, apiHero2.favorite)
    }
    
    func test_addLocations_ShouldInsertLocationAndAssociateHero() throws {
        // Given
        let apiHero = ApiHero(id: "123", name: "Luis", description: "description", photo: "photo", favorite: true)
        let apiLocation = ApiLocation(id: "id", date: "date", latitude: "0000", longitude: "11111", hero: apiHero)
        
        //When
        sut.add(heroes: [apiHero])
        sut.add(locations: [apiLocation])
        let heroes = sut.fetchHeroes(filter: nil)
        let hero = try XCTUnwrap(heroes.first)
        
        //Then
        // Validamos los resueltados y que el  los valores de los atributos del objeto son los corectos.
        XCTAssertEqual(hero.locations?.count, 1)
        let location = try XCTUnwrap(hero.locations?.first)
        
        XCTAssertEqual(location.id, apiLocation.id)
        XCTAssertEqual(location.date, apiLocation.date)
        XCTAssertEqual(location.latitude, apiLocation.latitude)
        XCTAssertEqual(location.longitude, apiLocation.longitude)
        XCTAssertEqual(location.hero?.id, hero.id)
    }
    
    
    func test_fetchHeroes_Error_ShouldReturnAndEmptyAray() throws {

        // Given
        let apiHero = ApiHero(id: "123", name: "Luis", description: "description", photo: "photo", favorite: true)
        let apiLocation = ApiLocation(id: "id", date: "date", latitude: "0000", longitude: "11111", hero: apiHero)
        
        //Sobreescribimos sut con el Mock de Error
        sut = StoreDataProviderErrorMock(persistency: .inMemory)
        //When
        sut.add(heroes: [apiHero])
        sut.add(locations: [apiLocation])
        let heroes = sut.fetchHeroes(filter: nil)
        
        //Then
        // Validamos los resueltados y que el  los valores de los atributos del objeto son los corectos.
        XCTAssertEqual(heroes.count, 0, "Aunque hemso insertado 2 heroes, al dar erro debe devolver un array vacío")
    }

}
