//
//  MySpotOrderDetailConfirmDeclineCell.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 25/03/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MySpotOrderDetailConfirmDeclineCellDelegate:class {
    func declineButtonDidClicked()
    func confirmButtonDidClicked()
}

class MySpotOrderDetailConfirmDeclineCell: MKTableViewCell {

    @IBOutlet weak var declineButton: GradientBorderButton!
    @IBOutlet weak var confirmButton: UIButton!
    weak var delegate: MySpotOrderDetailConfirmDeclineCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        confirmButton.setTitle(NSLocalizedString("Confirm Order", comment: ""), for: .normal)
        confirmButton.makeItRounded(width:0, cornerRadius :confirmButton.bounds.height / 2)
        confirmButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 0.35, yStartPos: 0, yEndPos: 0)
        
        declineButton.setTitle(NSLocalizedString("Decline", comment: ""), for: .normal)
        declineButton.setTitleColor(Colors.vividBlue, for: .normal)
        declineButton.setupButton(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], startPoint: CGPoint.zero, endPoint: CGPoint(x: 1, y: 0), cornerRadius: declineButton.bounds.height)
    }
    
    @IBAction func declineButtonDidClicked() {
        delegate?.declineButtonDidClicked()
    }
    
    @IBAction func confirmButtonDidClicked() {
        delegate?.confirmButtonDidClicked()
    }
    
}
