//
//  PlistParser.swift
//  GBMCodeChallenge
//
//  Created by Armand on 09/12/21.
//

import Foundation

struct PlistParser {
    static func getStringValue(forKey key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("Couldn't retrieve \(key) from plist file")
        }
        return value
    }
}
