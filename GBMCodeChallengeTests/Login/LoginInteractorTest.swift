//
//  LoginInteractorTest.swift
//  GBMCodeChallengeTests
//
//  Created by Armand on 12/12/21.
//

import XCTest

class LoginInteractorTest: XCTestCase {
    
    var sut: LoginInteractor?
    var mockPresenter: MockLoginPresenter?
    var mockAuthenticator: MockAuthenticator?

    override func setUp() {
        sut = LoginInteractor()
        mockPresenter = MockLoginPresenter()
        mockAuthenticator = MockAuthenticator()
        sut?.authenticator = mockAuthenticator
        sut?.presenter = mockPresenter
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockAuthenticator = nil
        super.tearDown()
    }
    
    func testGetBiometricFaceId() {
        mockAuthenticator?.biometricType = .face
        XCTAssertEqual(sut?.getBiometricType(), .face)
    }
    
    func testGetBiometricTouchId() {
        mockAuthenticator?.biometricType = .touch
        XCTAssertEqual(sut?.getBiometricType(), .touch)
    }
    
    func testGetBiometricFail() {
        mockAuthenticator?.biometricType = .unavailable
        XCTAssertEqual(sut?.getBiometricType(), .unavailable)
    }

    func testLoginSuccess() {
        sut?.login()
        XCTAssertTrue(mockPresenter?.isSuccess ?? false)
        XCTAssertNil(mockPresenter?.error)
    }
    
    func testLoginFail() {
        mockAuthenticator?.fails = true
        sut?.login()
        XCTAssertFalse(mockPresenter?.isSuccess ?? false)
        XCTAssertNotNil(mockPresenter?.error)
        XCTAssertNotNil(mockPresenter?.error?.localizedDescription)
        
    }
}

class MockLoginPresenter: InteractorToPresenterLoginProtocol {
    
    var isSuccess = false
    var error: AuthError?
    
    func onLoginSuccess() {
        isSuccess = true
    }
    
    func onLoginFailed(error: AuthError) {
        self.error = error
    }
}

class MockAuthenticator: AuthenticatorProtocol {
    
    var fails = false
    var biometricType: BiometricType = .unavailable
    
    func getBiometricType() -> BiometricType {
        return biometricType
    }
    
    func authenticate(completion: @escaping (Result<Void, AuthError>) -> ()) {
        if fails {
            completion(.failure(.customError(message: "Error Test")))
        } else {
            completion(.success(()))
        }
    }
}
