//
//  TestUserService.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//

import StorageService

class TestUserService: UserService {
    private let currentUser: User = UsersRepository.make()[0]
    
    func getUser(byLogin login: String) -> User? {
        return currentUser.login == login ? currentUser : nil
    }
}
