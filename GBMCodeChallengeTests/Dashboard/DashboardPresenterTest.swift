//
//  DashboardPresenterTest.swift
//  GBMCodeChallengeTests
//
//  Created by Armand on 13/12/21.
//

import XCTest

class DashboardPresenterTest: XCTestCase {
    
    var sut: DashboardPresenter?
    var mockView: MockDashboardView?
    var mockInteractor: MockDashboardInteractor?
    var mockRouter: MockDashboardRouter?

    override func setUp() {
        sut = DashboardPresenter()
        mockView = MockDashboardView()
        mockInteractor = MockDashboardInteractor()
        mockRouter = MockDashboardRouter()
        mockInteractor?.presenter = sut
        sut?.view = mockView
        sut?.interactor = mockInteractor
        sut?.router = mockRouter
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func testViewUpdateOnSuccess() {
        sut?.startFetchingRecords()
        let expectation = XCTestExpectation(description: "View Model creation expectation")
        mockView?.expectation = expectation
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testViewUpdateOnFail() {
        mockInteractor?.fails = true
        mockView?.fails = true
        sut?.startFetchingRecords()
    }
    
    func testInteractorStartsRequest() {
        sut?.startFetchingRecords()
        XCTAssertTrue(mockInteractor?.processing ?? false)
    }
    
    func testInvalidatingInteractorsTimer() {
        sut?.presentLogin()
        XCTAssertTrue(mockInteractor?.invalidatingTimer ?? false)
    }
    
    func testRouterPresentingLogin() {
        sut?.presentLogin()
        XCTAssertTrue(mockRouter?.presentedLogin ?? false)
    }
}

class MockDashboardView: PresenterToViewDashboardProtocol {
        
    var fails = false
    var expectation: XCTestExpectation?
    
    func onRecordsResponseSuccess(viewModel: DashboardViewModel) {
        if fails {
            XCTFail()
        } else {
            XCTAssertNotNil(viewModel)
        }
        expectation?.fulfill()
    }
    
    func onRecordsResponseFailed(error: HTTPError) {
        if fails {
            XCTAssertNotNil(error)
        } else {
            XCTFail()
        }
        expectation?.fulfill()
    }
}

class MockDashboardInteractor: PresenterToInteractorDashboardProtocol {
    var presenter: InteractorToPresenterDashboardProtocol?
    var fails = false
    var processing = false
    var invalidatingTimer = false
    
    func fetchRecords() {
        self.processing = true
        if fails {
            self.presenter?.onRecordsResponseFailed(error: .generic(error: "Error Test"))
        } else {
            self.presenter?.onRecordsResponseSuccess(recordsList: [])
        }
        
    }
    
    func invalidateTimer() {
        self.invalidatingTimer = true
    }
    
    
}

class MockDashboardRouter: PresenterToRouterDashboardProtocol {
    
    var presentedLogin = false
    
    func presentLogin(fromView: PresenterToViewDashboardProtocol?) {
        presentedLogin = true
    }
}
