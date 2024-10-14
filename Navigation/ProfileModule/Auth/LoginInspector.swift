//
//  LoginInspector.swift
//  Navigation
//
//  Created by Роман Лешин on 08.10.2024.
//

class LoginInspector: LoginViewControllerDelegate {
    private let checkerService = CheckerService()
    
    func checkCredentials(withEmail: String, password: String, completion: @escaping (() -> Void)) {
        checkerService.checkCredentials(withEmail: withEmail, password: password, completion: completion)
    }
    
    func signUp(withEmail: String, password: String, completion: @escaping (() -> Void)) {
        checkerService.signUp(withEmail: withEmail, password: password, completion: completion)
    }
}
