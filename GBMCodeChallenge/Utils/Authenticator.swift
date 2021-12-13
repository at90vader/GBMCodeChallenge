//
//  Authenticator.swift
//  GBMCodeChallenge
//
//  Created by Armand on 11/12/21.
//

import Foundation
import LocalAuthentication

enum AuthError: Error {
    case customError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .customError(message: let message):
            return message
        }
    }
}

enum BiometricType {
    case unavailable
    case touch
    case face
}

protocol AuthenticatorProtocol {
    func getBiometricType() -> BiometricType
    func authenticate(completion: @escaping (Result<Void, AuthError>) -> ())
}

class Authenticator: AuthenticatorProtocol {
    let context = LAContext()
    var error: NSError?
    
    func getBiometricType() -> BiometricType {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .unavailable
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            return .unavailable
        }
    }
    
    func authenticate(completion: @escaping (Result<Void, AuthError>) -> ()) {
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(.failure(.customError(message: error?.localizedDescription ?? "An error occurred while authenticating.")))
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This app needs your TouchID to Login") { success, authError in
            DispatchQueue.main.async {
                if success {
                    completion(.success(()))
                } else {
                    completion(.failure(.customError(message: authError?.localizedDescription  ?? "An error occurred while authenticating.")))
                }
            }
        }
    }
}
