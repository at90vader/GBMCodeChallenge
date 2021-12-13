//
//  GetIPCRecord.swift
//  GBMCodeChallenge
//
//  Created by Armand on 09/12/21.
//

import Foundation

struct GetIPCRecord: HTTPRequest {
    typealias Response = [IPCRecord]
    
    let urlPath: String
    let method: HTTPMethod = .GET
    
    init() {
        urlPath = "/v3/cc4c350b-1f11-42a0-a1aa-f8593eafeb1e"
    }
}
