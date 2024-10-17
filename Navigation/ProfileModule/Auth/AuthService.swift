//
//  AuthService.swift
//  Navigation
//
//  Created by Роман Лешин on 17.10.2024.
//

import RealmSwift

class AuthService {
    let realm: Realm
    
    init() {
        let config = Realm.Configuration(schemaVersion: 4, deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
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
