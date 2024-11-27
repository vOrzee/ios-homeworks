//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Роман Лешин on 27.11.2024.
//

import UIKit
import LocalAuthentication

class LocalAuthorizationService {
    
    static var biometryType: LABiometryType {
        let laContext = LAContext()
        laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return laContext.biometryType
    }
    
    static func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, Error?) -> Void) async {
        let laContext = LAContext()
        var error: NSError?
        if !laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authorizationFinished(false, error)
            return
        }
        laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: NSLocalizedString("To access data", comment: "")) { success, error in
            if success {
                authorizationFinished(true, nil)
            } else {
                authorizationFinished(false, error)
            }
        }
    }
}
