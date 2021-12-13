//
//  DashboardViewModel.swift
//  GBMCodeChallenge
//
//  Created by Armand on 13/12/21.
//

import Foundation

struct DashboardViewModel {
    var date: String = ""
    var records: [IPCRecordViewModel] = []
    var recordsForGraph: [Double] = []
    
    static func setup(with records: [IPCRecord], completion: @escaping (DashboardViewModel) -> ()) {
        var viewModel = DashboardViewModel()
        DispatchQueue.global(qos: .userInitiated).async {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.setLocalizedDateFormatFromTemplate("MMM dd,yyyy")
            if records.count > 0 {
                viewModel.date = formatter.string(from: records[0].date)
            }
            records.forEach { record in
                viewModel.records.append(IPCRecordViewModel(record: record))
                viewModel.recordsForGraph.append((record.price as NSDecimalNumber).doubleValue)
            }
            
            DispatchQueue.main.async {
                completion(viewModel)
            }
        }
    }
}
