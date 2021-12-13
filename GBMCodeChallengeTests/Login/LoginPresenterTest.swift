//
//  LoginPresenterTest.swift
//  GBMCodeChallengeTests
//
//  Created by Armand on 12/12/21.
//

import XCTest

class LoginPresenterTest: XCTestCase {
    
    var sut: LoginPresenter?
    var mockView: MockLoginView?
    var mockInteractor: MockLoginInteractor?
    var mockRouter: MockLoginRouter?
    
    override func setUp() {
        sut = LoginPresenter()
        mockView = MockLoginView()
        mockInteractor = MockLoginInteractor()
        mockRouter = MockLoginRouter()
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
        sut?.login()
        XCTAssertNil(mockView?.error)
    }
    
    func testViewUpdateOnFail() {
        mockInteractor?.fails = true
        sut?.login()
        XCTAssertNotNil(mockView?.error)
    }
    
    func testInteractorStartsLoginProcess() {
        sut?.login()
        XCTAssertTrue(mockInteractor?.processing ?? false)
    }
    
    func testRouterPresentingDashboard() {
        sut?.login()
        XCTAssertTrue(mockRouter?.presentedDashboard ?? false)
    }
    
    func testGetBiometricFaceId() {
        mockInteractor?.biometricType = .face
        XCTAssertEqual(sut?.getBiometricType(), .face)
    }
    
    func testGetBiometricTouchId() {
        mockInteractor?.biometricType = .touch
        XCTAssertEqual(sut?.getBiometricType(), .touch)
    }
    
    func testGetBiometricFail() {
        mockInteractor?.biometricType = .unavailable
        XCTAssertEqual(sut?.getBiometricType(), .unavailable)
    }
}

class MockLoginView: PresenterToViewLoginProtocol {
    
    var error: AuthError?
    
    func onLoginFailed(error: AuthError) {
        self.error = error
    }
}


class MockLoginInteractor: PresenterToInteractorLoginProtocol {
    
    var presenter: InteractorToPresenterLoginProtocol?
    var fails = false
    var processing = false
    var biometricType: BiometricType = .unavailable
    
    func getBiometricType() -> BiometricType {
        return biometricType
    }
    
    func login() {
        self.processing = true
        if fails {
            presenter?.onLoginFailed(error: .customError(message: "Error Test"))
        } else {
            presenter?.onLoginSuccess()
        }
    }
}

class MockLoginRouter: PresenterToRouterLoginProtocol {

    var presentedDashboard = false
    
    func presentDashboard(fromView: PresenterToViewLoginProtocol?) {
        presentedDashboard = true
    }
}
