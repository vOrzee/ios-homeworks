//
//  UserService.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//

import StorageService

protocol UserService {
    static func getUser(byLogin login: String) -> User?
}
