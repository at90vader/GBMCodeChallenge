//
//  LoginInteractor.swift
//  GBMCodeChallenge
//
//  Created by Armand on 11/12/21.
//

import Foundation

class LoginInteractor: PresenterToInteractorLoginProtocol {
    
    var presenter: InteractorToPresenterLoginProtocol?
    
    lazy var authenticator: AuthenticatorProtocol? = Authenticator()
    
    func getBiometricType() -> BiometricType {
        guard let authenticator = authenticator else { return .unavailable }
        return authenticator.getBiometricType()
    }
    
    func login() {
        authenticator?.authenticate { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.presenter?.onLoginSuccess()
            case .failure(let authError):
                self.presenter?.onLoginFailed(error: authError)
            }
        }
    }
}
