//
//  DashboardInteractor.swift
//  GBMCodeChallenge
//
//  Created by Armand on 11/12/21.
//

import Foundation

class DashboardInteractor: PresenterToInteractorDashboardProtocol {
    var presenter: InteractorToPresenterDashboardProtocol?
    
    private var timer: Timer?
    private let refreshSeconds: TimeInterval = 10.0
    
    lazy var httpClient: HTTPClient = {
        let session: URLSession = URLSession(configuration: .default)
        let baseURL = PlistParser.getStringValue(forKey: "BaseURL")
        return HTTPClient(baseURL: baseURL, urlSession: session)
    }()
    
    func fetchRecords() {
        
        httpClient.request(request: GetIPCRecord()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let records):
                self.presenter?.onRecordsResponseSuccess(recordsList: records)
                if self.timer == nil {
                    self.startTimer()
                }
            case .failure(let error):
                self.presenter?.onRecordsResponseFailed(error: error)
            }
        }
    }
    
    private func startTimer() {
        self.timer = Timer()
        self.timer = Timer.scheduledTimer(withTimeInterval: refreshSeconds, repeats: true, block: { [weak self] _ in
            print("Timer count")
            self?.fetchRecords()
        })
    }
    
    func invalidateTimer() {
        self.timer?.invalidate()
    }
}
