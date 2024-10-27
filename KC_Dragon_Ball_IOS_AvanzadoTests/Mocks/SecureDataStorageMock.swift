//
//  SecureDataStorageMock.swift
//  GokuAndFriends
//
//  Created by Pedro on 17/10/24.
//
import Foundation
@testable import KC_Dragon_Ball_IOS_Avanzado


///Mock para SecureDataStorage, implementa el protocol
/// Igual que SecureDataStorage pero en vez de usar KEyChain usamos Userdefaults
class SecureDataStorageMock: SecureDataStoreProtocol {
    
    private let kToken = "kToken"
    private var userDefaults = UserDefaults.standard
    
    func set(token: String) {
        userDefaults.set(token, forKey: kToken)
    }
    
    func getToken() -> String? {
        userDefaults.string(forKey: kToken)
    }
    
    func deleteToken() {
        userDefaults.removeObject(forKey: kToken)
    }
}
