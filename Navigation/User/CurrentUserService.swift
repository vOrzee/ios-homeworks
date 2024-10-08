//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//
import StorageService

class CurrentUserService: UserService {
    private static let currentUser: User = UsersRepository.make()[0]
    
    static func getUser(byLogin login: String) -> User? {
        return currentUser.login == login ? currentUser : nil
    }
}
