//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//
import StorageService

class CurrentUserService: UserService {
    private let currentUser: User = UsersRepository.make()[1]
    
    func getUser(byLogin login: String) -> User? {
        return currentUser.login == login ? currentUser : nil
    }
}
