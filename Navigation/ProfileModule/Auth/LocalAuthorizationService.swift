//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Роман Лешин on 27.11.2024.
//

import UIKit
import LocalAuthentication

class LocalAuthorizationService {
    
    static func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) async {
        let laContext = LAContext()
        var error: NSError?
        if !laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authorizationFinished(false)
            return
        }
        laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: NSLocalizedString("To access data", comment: "")) { success, _ in
            if success {
                authorizationFinished(true)
            } else {
                authorizationFinished(false)
            }
        }
    }
}
