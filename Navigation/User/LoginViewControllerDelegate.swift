//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//

protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) -> Bool
}
