//
//  AuthError.swift
//  Navigation
//
//  Created by Роман Лешин on 14.10.2024.
//

enum AuthError: Error {
    case invalidCredentials(message: String)
    case userNotFound(message: String)
    case emailAlreadyInUse(message: String)
    case invalidEmail(message: String)
    case networkUnavailable(message: String)
    case wrongPassword(message: String)
    case unknownError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials(let message):
            return message
        case .userNotFound(let message):
            return message
        case .unknownError(let message):
            return message
        case .emailAlreadyInUse(message: let message):
            return message
        case .invalidEmail(message: let message):
            return message
        case .networkUnavailable(message: let message):
            return message
        case .wrongPassword(message: let message):
            return message
        }
    }
}
