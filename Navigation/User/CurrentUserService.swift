//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//
import StorageService

class CurrentUserService: UserService {
    internal var currentUser: User = UsersRepository.make()[1]
}
