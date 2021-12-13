//
//  LoginProtocols.swift
//  GBMCodeChallenge
//
//  Created by Armand on 11/12/21.
//

import Foundation
import UIKit

protocol ViewToPresenterLoginProtocol: AnyObject {
    var view: PresenterToViewLoginProtocol? { get set }
    var interactor: PresenterToInteractorLoginProtocol? { get set }
    var router: PresenterToRouterLoginProtocol? { get set }
    func getBiometricType() -> BiometricType
    func login()
}

protocol PresenterToViewLoginProtocol: AnyObject {
    func onLoginFailed(error: AuthError)
}

protocol PresenterToRouterLoginProtocol: AnyObject {
    func presentDashboard(fromView: PresenterToViewLoginProtocol?)
}

protocol PresenterToInteractorLoginProtocol: AnyObject {
    var presenter: InteractorToPresenterLoginProtocol? { get set }
    func getBiometricType() -> BiometricType
    func login()
}

protocol InteractorToPresenterLoginProtocol: AnyObject {
    func onLoginSuccess()
    func onLoginFailed(error: AuthError)
}
