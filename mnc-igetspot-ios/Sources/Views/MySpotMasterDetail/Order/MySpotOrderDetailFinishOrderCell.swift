//
//  MySpotOrderDetailFinishOrderCell.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 25/03/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MySpotOrderDetailFinishOrderCellDelegate:class {
    func viewOrderStatusButtonDidClicked()
    func finishOrderButtonDidClicked()
}

class MySpotOrderDetailFinishOrderCell: MKTableViewCell {

   @IBOutlet weak var viewOrderStatusButton: UIButton!
   @IBOutlet weak var swipeToFinishOrderButton: MMSlidingButton!
   weak var delegate: MySpotOrderDetailFinishOrderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        viewOrderStatusButton.setTitle("View Your Order Status", for: .normal)
        viewOrderStatusButton.makeItRounded(width:0.0, cornerRadius : viewOrderStatusButton.bounds.height / 2)
        viewOrderStatusButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        swipeToFinishOrderButton.buttonFont = R.font.barlowMedium(size: 18)!
        swipeToFinishOrderButton.delegate = self
        swipeToFinishOrderButton.start(count: 0)
        
    }
    
    
    // MARK: - Actions
    @IBAction func viewOrderStatusButtonDidClicked() {
        delegate?.viewOrderStatusButtonDidClicked()
    }
}

extension MySpotOrderDetailFinishOrderCell: SlideButtonDelegate {
    func buttonStatus(status:String, sender:MMSlidingButton) {
        print("status : \(status)")
        if status == "Unlocked" {
            swipeToFinishOrderButton.stop()
            delegate?.finishOrderButtonDidClicked()
        }
    }
}
