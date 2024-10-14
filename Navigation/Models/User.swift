//
//  User.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//

import UIKit

public class User {
    public let login: String
    public let fullName: String
    public let avatar: UIImage
    public let status: String
    
    public init(login: String, fullName: String, avatar: UIImage, status: String) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}
