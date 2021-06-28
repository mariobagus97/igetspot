//
//  PaymentBankCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 01/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class PaymentBankCell : MKTableViewCell {
    
    @IBOutlet weak var atmOptionView: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var bankListTable: BankListTableView!
    
    var selectedBank : Bank!
    
    @IBOutlet weak var tableheight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        arrowImage.isHidden = true
        arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    func setContent(list: [Bank]){
        bankListTable.delegate = self
        bankListTable.setContent(list: list)
        tableheight.constant = bankListTable.tableView.contentSize.height
        self.bankListTable.setNeedsLayout()
        self.bankListTable.layoutIfNeeded()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

}

extension PaymentBankCell : BankListTableViewDelegate {
    func onCellPressed(bank: Bank){
        self.selectedBank = bank
        self.setNeedsLayout()
        layoutIfNeeded()
    }
        
}
