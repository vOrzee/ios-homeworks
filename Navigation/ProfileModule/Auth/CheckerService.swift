//
//  CheckService.swift
//  Navigation
//
//  Created by Роман Лешин on 14.10.2024.
//

import FirebaseAuth

class CheckerService: CheckerServiceProtocol {
    func checkCredentials(withEmail email: String, password: String, completion: @escaping ((Result<User, AuthError>) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error as NSError? {
                let fbErrorCode = AuthErrorCode(rawValue: error.code)
                
                switch fbErrorCode {
                case .userNotFound:
                    completion(.failure(.userNotFound(message: NSLocalizedString("User not found.", comment: ""))))
                case .wrongPassword:
                    completion(.failure(.wrongPassword(message: NSLocalizedString("Invalid password.", comment: ""))))
                case .emailAlreadyInUse:
                    completion(.failure(.emailAlreadyInUse(message: NSLocalizedString("Email is already in use.", comment: ""))))
                case .invalidEmail:
                    completion(.failure(.invalidEmail(message: NSLocalizedString("Invalid email.", comment: ""))))
                case .networkError:
                    completion(.failure(.networkUnavailable(message: NSLocalizedString("Network error.", comment: ""))))
                default:
                    completion(.failure(.unknownError(message: error.localizedDescription)))
                }
            } else if let user = authDataResult?.user {
                completion(.success(user))
            }
        }
    }
    
    func signUp(withEmail email: String, password: String, completion: @escaping ((Result<User, AuthError>) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error as NSError? {
                let fbErrorCode = AuthErrorCode(rawValue: error.code)
                
                switch fbErrorCode {
                case .userNotFound:
                    completion(.failure(.userNotFound(message: NSLocalizedString("User not found.", comment: ""))))
                case .wrongPassword:
                    completion(.failure(.wrongPassword(message: NSLocalizedString("Invalid password.", comment: ""))))
                case .emailAlreadyInUse:
                    completion(.failure(.emailAlreadyInUse(message: NSLocalizedString("Email is already in use.", comment: ""))))
                case .invalidEmail:
                    completion(.failure(.invalidEmail(message: NSLocalizedString("Invalid email.", comment: ""))))
                case .networkError:
                    completion(.failure(.networkUnavailable(message: NSLocalizedString("Network error.", comment: ""))))
                default:
                    completion(.failure(.unknownError(message: error.localizedDescription)))
                }
            } else if let user = authDataResult?.user {
                completion(.success(user))
            }
        }
    }
    
    
}
