//
//  IPCRecordViewModel.swift
//  GBMCodeChallenge
//
//  Created by Armand on 13/12/21.
//

import Foundation
import UIKit

struct IPCRecordViewModel {
    var date: String = ""
    var price: String = ""
    var percentageChange: String = ""
    var volume: String = ""
    var change: String = ""
    var color: UIColor = .green
    
    init(record: IPCRecord) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.setLocalizedDateFormatFromTemplate("HH:mm:ss.SSS")
        let time = formatter.string(from: record.date)
        date = time
        price = "$\(record.price)"
        percentageChange = String(format: "%.4f%%", (record.percentageChange as NSDecimalNumber).doubleValue)
        volume = "\(record.volume)"
        change = "\(record.change)"
        color = record.change < 0 ? .red : .systemGreen
    }
}
