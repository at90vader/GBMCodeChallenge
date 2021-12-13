//
//  IPCRecord.swift
//  GBMCodeChallenge
//
//  Created by Armand on 09/12/21.
//

import Foundation

struct IPCRecord: Codable {
    var date: Date
    var price: Decimal
    var percentageChange: Decimal
    var volume: Int64
    var change: Decimal
}
