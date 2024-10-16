//
//  UsersRepository.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//

import Foundation
import UIKit

public enum UsersRepositoryInMemoryStorage {
    public static func make() -> [User] {
        return [
            User(login: "user", fullName: "Test User", avatar: UIImage(named: "TestUser")!, status: "Waiting for something..."),
            User(login: "jomarzka", fullName: "Роман Лешин", avatar: UIImage(named: "Jomarzka")!, status: "Гриппую..."),
        ]
    }
}
