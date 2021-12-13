//
//  LoginRouter.swift
//  GBMCodeChallenge
//
//  Created by Armand on 11/12/21.
//

import Foundation
import UIKit

class LoginRouter: PresenterToRouterLoginProtocol {
    
    static func createLoginModule() -> LoginViewController {
        let view = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let presenter: ViewToPresenterLoginProtocol & InteractorToPresenterLoginProtocol = LoginPresenter()
        let interactor: PresenterToInteractorLoginProtocol = LoginInteractor()
        let router: PresenterToRouterLoginProtocol = LoginRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func presentDashboard(fromView: PresenterToViewLoginProtocol?) {
        let dashboardVC = DashboardRouter.createDashboardModule()
        guard let fromView = fromView as? UIViewController,
        let navigationController = fromView.navigationController else { return }
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([dashboardVC], animated: true)
    }
}
