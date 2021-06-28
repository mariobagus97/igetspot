//
//  MySpotBankCell.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 17/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MySpotBankCellDelegate:class {
    func editBankButtonDidClicked()
}

class MySpotBankCell: MKTableViewCell {
    
    @IBOutlet weak var logoBankImageView: UIImageView!
    @IBOutlet weak var branchLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var editBankButton: UIButton!
    @IBOutlet weak var separatorLeadingConstraint: NSLayoutConstraint!
    var delegate: MySpotBankCellDelegate?
    var separatorLeadingSpaceDefault = 25

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func editBankButtonDidClicked() {
        delegate?.editBankButtonDidClicked()
    }
    
    func setContent(bankBranch:String?, bankAccountHolder:String, bankName:String, bankAccountNumber:String) {
        branchLabel.text = "\(bankName)"
        accountNumberLabel.text = bankAccountNumber
        accountNameLabel.text = bankAccountHolder
        editBankButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
    }
    
    func setEmptyBankData() {
        branchLabel.text = NSLocalizedString("You don't have bank info. Please add your bank info so you can withdrawl", comment: "")
        editBankButton.setTitle(NSLocalizedString("Add", comment: ""), for: .normal)
    }
    
}
