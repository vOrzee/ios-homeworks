//
//  CheckServiceProtocol.swift
//  Navigation
//
//  Created by Роман Лешин on 14.10.2024.
//
import FirebaseAuth

protocol CheckerServiceProtocol {
    func checkCredentials(withEmail: String, password: String, completion: @escaping ((Result<User, AuthError>)->Void))
    func signUp(withEmail: String, password: String, completion: @escaping ((Result<User, AuthError>)->Void))
}
