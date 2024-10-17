//
//  AuthState.swift
//  Navigation
//
//  Created by Роман Лешин on 17.10.2024.
//

import RealmSwift

class AuthState: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var email: String
    @Persisted var password: String
}
