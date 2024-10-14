//
//  CheckServiceProtocol.swift
//  Navigation
//
//  Created by Роман Лешин on 14.10.2024.
//

protocol CheckerServiceProtocol {
    func checkCredentials(withEmail: String, password: String, completion: @escaping (()->Void))
    func signUp(withEmail: String, password: String, completion: @escaping (()->Void))
}
