//
//  AuthService.swift
//  Navigation
//
//  Created by Роман Лешин on 17.10.2024.
//

import RealmSwift
import Foundation
import KeychainSwift

class AuthService {
    static let shared = AuthService()
    
    private let realm: Realm
    
    private let keyChain = KeychainSwift()

    private init() {
        if let keyData = keyChain.getData("realmEncryptionKey") {
            Realm.Configuration.defaultConfiguration = Realm.Configuration(encryptionKey: keyData, schemaVersion: 7)
        } else {
            var key = Data(count: 64)
            _ = key.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in
                SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            }

            keyChain.set(key, forKey: "realmEncryptionKey")
            Realm.Configuration.defaultConfiguration = Realm.Configuration(encryptionKey: key, schemaVersion: 7) //, deleteRealmIfMigrationNeeded: true)
        }
//        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
//        try? FileManager.default.removeItem(at: realmURL)
        realm = try! Realm()
    }
    
    func saveCredentials(email: String, password: String) {
        let credentials = AuthState()
        credentials.email = email
        credentials.password = password
        
        try! realm.write {
            realm.add(credentials, update: .modified)
        }
    }
    
    func getCredentials() -> AuthState? {
        return realm.objects(AuthState.self).first
    }
    
    func clearCredentials() {
        try! realm.write {
            let allCredentials = realm.objects(AuthState.self)
            realm.delete(allCredentials)
        }
    }
}
