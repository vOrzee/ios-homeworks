//
//  UserService.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//

import StorageService

protocol UserService {
    func getUser(byLogin login: String) -> User?
}
