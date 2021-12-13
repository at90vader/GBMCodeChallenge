//
//  DashboardRouter.swift
//  GBMCodeChallenge
//
//  Created by Armand on 11/12/21.
//

import Foundation
import UIKit

class DashboardRouter: PresenterToRouterDashboardProtocol {

    static func createDashboardModule() -> DashboardViewController {
        
        let view = DashboardViewController(nibName: "DashboardViewController", bundle: nil)
        
        let presenter: ViewToPresenterDashboardProtocol & InteractorToPresenterDashboardProtocol = DashboardPresenter()
        let interactor: PresenterToInteractorDashboardProtocol = DashboardInteractor()
        let router: PresenterToRouterDashboardProtocol = DashboardRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func presentLogin(fromView: PresenterToViewDashboardProtocol?) {
        let loginVC = LoginRouter.createLoginModule()
        guard let fromView = fromView as? UIViewController,
        let navigationController = fromView.navigationController else { return }
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([loginVC], animated: true)
    }
}
