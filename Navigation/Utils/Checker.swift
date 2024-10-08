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
    private let password = "12345"
    
    private init() {
        #if DEBUG
        login = UsersRepository.make()[0].login
        #else
        login = UsersRepository.make()[1].login
        #endif
    }
    
    func check(login: String, password: String) -> Bool {
        return login == self.login && password == self.password
    }
}
