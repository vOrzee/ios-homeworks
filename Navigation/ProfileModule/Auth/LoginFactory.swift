//
//  LoginFactory.swift
//  Navigation
//
//  Created by Роман Лешин on 09.10.2024.
//

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}
