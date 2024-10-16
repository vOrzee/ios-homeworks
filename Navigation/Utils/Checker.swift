//
//  Checker.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//
import StorageService

class Checker {
    static let shared = Checker()
    
    private let login: String
    private let password = "123456"
    
    private init() {
        #if DEBUG
        login = UsersRepositoryInMemoryStorage.make()[0].login
        #else
        login = UsersRepositoryInMemoryStorage.make()[1].login
        #endif
    }
    
    func check(login: String, password: String) throws -> Bool {
        if !(login == self.login && password == self.password) {throw AppError.unauthorized}
        return true
    }
}
