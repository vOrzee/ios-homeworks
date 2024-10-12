//
//  LoginInspector.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//

class LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) throws -> Bool {
        return try Checker.shared.check(login: login, password: password)
    }
}
