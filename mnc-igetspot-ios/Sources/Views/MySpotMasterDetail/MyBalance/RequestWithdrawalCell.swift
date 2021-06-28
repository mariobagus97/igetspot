//
//  RequestWithdrawlCell.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 17/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol RequestWithdrawalCellDelegate:class {
    func requestWithdrawalButtonDidClicked()
}

class RequestWithdrawalCell: MKTableViewCell {

    @IBOutlet weak var requestWithdrawalButton: UIButton!
    weak var delegate: RequestWithdrawalCellDelegate?
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        requestWithdrawalButton.makeItRounded(width: 0, cornerRadius: requestWithdrawalButton.frame.height/2)
        makeGradientButton()
    }
    
    // MARK: - Private Functions
    func makeGradientButton(){
        requestWithdrawalButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    // MARK: - Actions
    @IBAction func requestWithdrawalButtonDidClicked() {
        delegate?.requestWithdrawalButtonDidClicked()
    }
    
}
