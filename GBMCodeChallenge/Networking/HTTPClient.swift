//
//  HTTPClient.swift
//  GBMCodeChallenge
//
//  Created by Armand on 09/12/21.
//

import Foundation

enum HTTPMethod: String {
    case POST
    case GET
}

protocol HTTPRequest {
    associatedtype Response: Codable
    
    var urlPath: String { get }
    var method: HTTPMethod { get }
}

enum HTTPError: Error {
    case badURL
    case parsing
    case emptyResponse
    case generic(error: String)
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "The provided URL is invalid"
        case .parsing:
            return "An error has ocurred while parsing the response"
        case .emptyResponse:
            return "The response from service is empty"
        case .generic(let error):
            return error
        }
    }
}


class HTTPClient {
    private let urlSession: URLSession
    private let baseURL: String
    
    init(baseURL: String, urlSession: URLSession) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    func request<Request: HTTPRequest>(request: Request, completion: @escaping (Result<Request.Response, HTTPError>) -> ()) {
        do {
            let urlRequest = try createURLRequest(for: request)
            
            let dataTask = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
                
                guard let self = self else { return }
                
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(.generic(error: error.localizedDescription)))
                    }
                    return
                }
                
                guard response != nil, let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(.emptyResponse))
                    }
                    return
                }
                
                self.decodeResponse(request: request, data: data) { response in
                    DispatchQueue.main.async {
                        switch response {
                        case .success(let responseObject):
                            completion(.success(responseObject))
                        case.failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
                
            } //end of dataTask
            dataTask.resume()
        } catch let error as HTTPError {
            completion(.failure(error))
        } catch {
            completion(.failure(.generic(error: error.localizedDescription)))
        }
        
    }
}

extension HTTPClient {
    
    private func createURLRequest<Request: HTTPRequest>(for request: Request) throws -> URLRequest {
        guard let url = URL(string: baseURL + request.urlPath) else {
            throw HTTPError.badURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        return urlRequest
    }
    
    private func decodeResponse<Request: HTTPRequest>(request: Request, data: Data, completion: @escaping (Result<Request.Response, HTTPError>) -> ()) {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            let responseObject = try decoder.decode(Request.Response.self, from: data)
            completion(.success(responseObject))
        } catch let error {
            print("Error: \(error)")
            completion(.failure(.parsing))
        }
    }
}
