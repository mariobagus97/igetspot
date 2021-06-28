//
//  PaymentVoucherCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 01/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class PaymentVoucherCell: MKTableViewCell {
    
    @IBOutlet weak var voucherField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func getVoucher() -> String{
        return voucherField.text ?? ""
    }
    
}
