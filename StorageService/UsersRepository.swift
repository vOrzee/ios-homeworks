//
//  UsersRepository.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//

import Foundation
import UIKit

public enum UsersRepository {
    public static func make() -> [User] {
        return [
            User(login: "jomarzka", fullName: "Hipster Cat", avatar: UIImage(named: "HipsterCat")!, status: "Waiting for something...")
        ]
    }
}
