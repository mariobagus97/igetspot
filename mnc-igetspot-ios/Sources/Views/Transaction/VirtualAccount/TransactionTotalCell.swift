//
//  TransactionTotalCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/25/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol TransactionTotalCellDelegate {
    func onBackButtonPressed()
}

class TransactionTotalCell : MKTableViewCell {
    
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var goBackButton: UIButton!
    
    var delegate : TransactionTotalCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        goBackButton.makeItRounded(width:0.0, cornerRadius : goBackButton.bounds.height / 2)
         goBackButton.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    func setContent(subtotal: String, total: String){
        subtotalLabel.text = subtotal.currency
        totalLabel.text = total.currency
    }    

    @IBAction func onButtonPressed(_ sender: Any) {
        self.delegate?.onBackButtonPressed()
    }
}
