//
//  DashboardInteractorTest.swift
//  GBMCodeChallengeTests
//
//  Created by Armand on 13/12/21.
//

import XCTest

class DashboardInteractorTest: XCTestCase {
    
    var sut: DashboardInteractor?
    var mockPresenter: MockDashboardPresenter?
    var requestURL = "\(PlistParser.getStringValue(forKey: "BaseURL"))\(GetIPCRecord().urlPath)"
    var expectation: XCTestExpectation?
    
    override func setUp() {
        sut = DashboardInteractor()
        mockPresenter = MockDashboardPresenter()
        sut?.presenter = mockPresenter
        expectation = XCTestExpectation(description: "IPC Records response expectation")
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        sut?.httpClient = HTTPClient(baseURL: "https://run.mocky.io", urlSession: urlSession)
    }
    
    override func tearDown() {
        sut = nil
        mockPresenter = nil
        
    }
    
    func testSuccessfulServiceResponse() throws {
        
        guard let jsonData = loadJson(filename: "mockedIPCRecordsResponse") else {
            XCTFail("invalid JSON")
            return
        }
        
        guard let apiURL = URL(string: self.requestURL) else {
            XCTExpectFailure()
            return
        }
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == apiURL else {
                throw HTTPError.badURL
            }
            
            let response = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, jsonData)
        }
        
        sut?.fetchRecords()
        mockPresenter?.expectation = expectation
        
        wait(for: [expectation!], timeout: 1.0)
    }
    
    func testFailingServiceResponse() throws {
        
        let expectation = XCTestExpectation(description: "IPC Records response expectation")
        
        let jsonData = Data()
        
        guard let apiURL = URL(string: self.requestURL) else {
            XCTExpectFailure()
            return
        }
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == apiURL else {
                throw HTTPError.badURL
            }
            
            let response = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, jsonData)
        }
        
        sut?.httpClient.request(request: GetIPCRecord(), completion: { result in
            switch result {
            case .success( _):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func loadJson(filename fileName: String) -> Data? {
        do {
            if let bundlePath = Bundle(for: type(of: self)).path(forResource: fileName,
                                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
}

class MockDashboardPresenter: InteractorToPresenterDashboardProtocol {
    
    var response: [IPCRecord]?
    
    var error: HTTPError?
    
    var expectation: XCTestExpectation?
    
    func onRecordsResponseSuccess(recordsList: [IPCRecord]) {
        
        let stringDate = "2020-08-18T00:01:43.633-05:00"
        let dateFormatter = DateFormatter.iso8601Full
        let date = dateFormatter.date(from: stringDate)
        XCTAssertEqual(recordsList[0].date, date)
        let price: Decimal = 39285.85
        XCTAssertEqual(recordsList[0].price, price)
        let percentageChange: Decimal = 0.86250
        XCTAssertEqual(recordsList[0].percentageChange, percentageChange)
        let volume: Int64 = 128684937
        XCTAssertEqual(recordsList[0].volume, volume)
        let change: Decimal = 335.97
        XCTAssertEqual(recordsList[0].change, change)
        expectation?.fulfill()
    }
    
    func onRecordsResponseFailed(error: HTTPError) {
        self.error = error
    }
}

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override func stopLoading() {
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler unavailable")
        }
        
        do {
            let (response, data) = try handler(request)
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}
