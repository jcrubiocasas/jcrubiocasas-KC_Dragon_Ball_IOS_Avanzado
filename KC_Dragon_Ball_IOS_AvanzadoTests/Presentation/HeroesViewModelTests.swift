//
//  HeroesViewModelTests.swift
//  GokuAndFriendsTests
//
//  Created by Pedro on 21/10/24.
//

import XCTest
@testable import KC_Dragon_Ball_IOS_Avanzado

class HeroUseCaseMock: HeroUseCaseProtocol {
    func loadHeros(filter: NSPredicate?, completion: @escaping ((Result<[Hero], GAError>) -> Void)) {
        let heroes = try? MockData.mockHeroes().map({$0.mapToHero()})
        completion(.success(heroes ?? []))
    }
}

class HeroUseCaseErrorMock: HeroUseCaseProtocol {
    func loadHeros(filter: NSPredicate?, completion: @escaping ((Result<[Hero], GAError>) -> Void)) {
        completion(.failure(.noDataReceived))
    }
}

final class HeroesViewModelTests: XCTestCase {
    
    var sut: HeroesViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = HeroesViewModel(useCase: HeroUseCaseMock())
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    
    func testLoad_Should_Return_Heroes() {
        //Given
        var heroes: [Hero]?
        let expectedCountHeroes = 26
        
        // When
        let expectation = expectation(description: "Load heroes")
        sut.statusHeroes.bind {[weak self] staus in
            switch staus {
            case .dataUpdated:
                heroes = self?.sut.heroes
                expectation.fulfill()
            case .error(msg: _):
                XCTFail("Expected success")
            case .none:
                break
            }
        }
        sut.loadData(filter: nil)
        
        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(heroes?.count, expectedCountHeroes)
    }
    
    func testLoad_Should_Return_Error() {
        //Given
        sut = HeroesViewModel(useCase: HeroUseCaseErrorMock())
        var msgError: String?
        
        // When
        let expectarion = expectation(description: "Load Heroes sould return error")
        sut.statusHeroes.bind { status in
            switch status {
                
            case .dataUpdated:
                XCTFail("EXpected Error")
            case .error(msg: let msg):
                msgError = msg
                expectarion.fulfill()
            case .none:
                break
            }
        }
        sut.loadData(filter: nil)
        
        //Then
        wait(for: [expectarion], timeout: 1)
        XCTAssertEqual(msgError, "Data no received from server")
    }
    
    
    func test_HeroATIndex() {
        //Given
        var hero: Hero?
        
        // When
        let expectation = expectation(description: "Load hero at index")
        sut.statusHeroes.bind { status in
            switch status {
            case .dataUpdated:
                expectation.fulfill()
            case .error(msg: _):
                XCTFail("Expected success")
            case .none:
                break
            }
        }
        sut.loadData(filter: nil)
        
        //Then
        wait(for: [expectation], timeout: 1)
        
        hero = sut.heroAt(index: 0)
        XCTAssertNotNil(hero)
        XCTAssertEqual(hero?.name, "Maestro Roshi")
        
        // Out of bounds
        hero = sut.heroAt(index: 30)
        XCTAssertNil(hero)
    }
}


extension ApiHero {
    
    func mapToHero() -> Hero {
        Hero.init(id: self.id ?? "",
                  name: self.name ?? "",
                  info: self.description ?? "",
                  photo: self.photo ?? "",
                  favorite: self.favorite ?? false)
    }
}
