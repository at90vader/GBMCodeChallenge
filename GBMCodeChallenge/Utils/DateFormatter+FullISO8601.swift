//
//  DateFormatter+FullISO8601.swift
//  GBMCodeChallenge
//
//  Created by Armand on 10/12/21.
//

import Foundation

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
      formatter.calendar = Calendar(identifier: .iso8601)
      formatter.locale = Locale(identifier: "en_US_POSIX")
      return formatter
    }()
}
