//
//  TestUserService.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//

import StorageService

class TestUserService: UserService {
    internal var currentUser: User = UsersRepositoryInMemoryStorage.make()[0]
}
