//
//  LoginPresenter.swift
//  GBMCodeChallenge
//
//  Created by Armand on 11/12/21.
//

import Foundation
import UIKit

class LoginPresenter: ViewToPresenterLoginProtocol {

    var view: PresenterToViewLoginProtocol?
    
    var interactor: PresenterToInteractorLoginProtocol?
    
    var router: PresenterToRouterLoginProtocol?
    
    func getBiometricType() -> BiometricType {
        guard let interactor = interactor else { return .unavailable }
        return interactor.getBiometricType()
    }
    
    func login() {
        interactor?.login()
    }
}

extension LoginPresenter: InteractorToPresenterLoginProtocol {
    func onLoginFailed(error: AuthError) {
        view?.onLoginFailed(error: error)
    }
    
    func onLoginSuccess() {
        router?.presentDashboard(fromView: view)
    }
}
