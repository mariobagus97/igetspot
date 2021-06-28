//
//  PaymentPayCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 01/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol PaymentPayCellDelegate {
    func didPayPressed()
}

class PaymentPayCell: MKTableViewCell {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var payNowButton: UIButton!
    
    var delegate : PaymentPayCellDelegate!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        payNowButton.makeItRounded(width:0.0, cornerRadius : payNowButton.bounds.height / 2)
        payNowButton.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    func setContent(total: String){
        totalLabel.text = "IDR " + total.currencyOnlyDigit
    }
    
    @IBAction func onPayPressed(_ sender: Any) {
        self.delegate?.didPayPressed()
    }
}
