//
//  RecordTableViewCell.swift
//  GBMCodeChallenge
//
//  Created by Armand on 12/12/21.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!

    func setupCell(with record: IPCRecordViewModel) {
        
        timeLabel.text = record.date
        priceLabel.text = record.price
        volumeLabel.text = record.volume
        percentageLabel.text = record.percentageChange
        changeLabel.text = record.change
        changeLabel.textColor = record.color
    }
}
