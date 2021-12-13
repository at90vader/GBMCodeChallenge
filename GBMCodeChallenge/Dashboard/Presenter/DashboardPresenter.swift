//
//  DashboardPresenter.swift
//  GBMCodeChallenge
//
//  Created by Armand on 09/12/21.
//

import Foundation
import UIKit

class DashboardPresenter: ViewToPresenterDashboardProtocol {
    var view: PresenterToViewDashboardProtocol?
    var interactor: PresenterToInteractorDashboardProtocol?
    var router: PresenterToRouterDashboardProtocol?
    func startFetchingRecords() {
        interactor?.fetchRecords()
    }
    func presentLogin() {
        interactor?.invalidateTimer()
        router?.presentLogin(fromView: view)
    }
}

extension DashboardPresenter: InteractorToPresenterDashboardProtocol {
    func onRecordsResponseSuccess(recordsList: [IPCRecord]) {
        
        DashboardViewModel.setup(with: recordsList) { [weak self] viewModel in
            self?.view?.onRecordsResponseSuccess(viewModel: viewModel)
        }
    }
    
    func onRecordsResponseFailed(error: HTTPError) {
        view?.onRecordsResponseFailed(error: error)
    }
}
