//
//  UserService.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//

import StorageService

protocol UserService {
    var currentUser: User { get set }
    func getUser(byLogin login: String) -> User?
}

extension UserService {
    func getUser(byLogin login: String) -> User? {
        return login == currentUser.login ? currentUser : nil
    }
}
