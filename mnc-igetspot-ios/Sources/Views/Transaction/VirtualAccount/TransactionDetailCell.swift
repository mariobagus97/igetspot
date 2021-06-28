//
//  TransactionDetailCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/25/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class TransactionDetailCell : MKTableViewCell {
    
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var serviceDateLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var packageTotalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(detail: TransactionDetailVA){
        packageNameLabel.text = detail.packageName
        orderDateLabel.text = detail.orderDate
        serviceDateLabel.text = detail.serviceDate
        venueLabel.text = detail.orderAddress
        durationLabel.text = detail.packageDuration
        packageTotalLabel.text = detail.packagePrice?.currency
    }
}
