//
//  DashboardProtocols.swift
//  GBMCodeChallenge
//
//  Created by Armand on 11/12/21.
//

import Foundation
import UIKit

protocol ViewToPresenterDashboardProtocol: AnyObject {
    var view: PresenterToViewDashboardProtocol? { get set }
    var interactor: PresenterToInteractorDashboardProtocol? { get set }
    var router: PresenterToRouterDashboardProtocol? { get set }
    func startFetchingRecords()
    func presentLogin()
}

protocol PresenterToViewDashboardProtocol: AnyObject {
    func onRecordsResponseSuccess(viewModel: DashboardViewModel)
    func onRecordsResponseFailed(error: HTTPError)
}

protocol PresenterToRouterDashboardProtocol: AnyObject {
    func presentLogin(fromView: PresenterToViewDashboardProtocol?)
}

protocol PresenterToInteractorDashboardProtocol: AnyObject {
    var presenter: InteractorToPresenterDashboardProtocol? { get set }
    func fetchRecords()
    func invalidateTimer()
}

protocol InteractorToPresenterDashboardProtocol: AnyObject {
    func onRecordsResponseSuccess(recordsList: [IPCRecord])
    func onRecordsResponseFailed(error: HTTPError)
}
