//
//  LoginInspector.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//
import FirebaseAuth

class LoginInspector: LoginViewControllerDelegate {
    private let checkerService: CheckerServiceProtocol
    
    init(checkerService: CheckerServiceProtocol) {
        self.checkerService = checkerService
    }
    
    func checkCredentials(withEmail: String, password: String, completion: @escaping ((Result<User, AuthError>) -> Void)) {
        checkerService.checkCredentials(withEmail: withEmail, password: password, completion: completion)
    }
    
    func signUp(withEmail: String, password: String, completion: @escaping ((Result<User, AuthError>) -> Void)) {
        checkerService.signUp(withEmail: withEmail, password: password, completion: completion)
    }
}
