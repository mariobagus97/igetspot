////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotMasterInfoCellDelegate:class {
    func editPackagePrice(currentPrice:String)
}

class MySpotMasterInfoCell: MKTableViewCell {
    
    @IBOutlet weak var mySpotMasterInfoView: MySpotMasterInfoView!
    weak var delegate: MySpotMasterInfoCellDelegate?
    var currentPrice:String = "0"

    override func awakeFromNib() {
        super.awakeFromNib()
        mySpotMasterInfoView.delegate = self
        mySpotMasterInfoView.hideRightButton()
        mySpotMasterInfoView.widthLeftButtonConstraint.constant = 20
        mySpotMasterInfoView.layoutIfNeeded()
        mySpotMasterInfoView.leftButton.setRounded()
        mySpotMasterInfoView.leftButton.isUserInteractionEnabled = false
        mySpotMasterInfoView.leftButton.backgroundColor = Colors.selectedGray
        mySpotMasterInfoView.leftButton.setImage(R.image.editSmallWhite(), for: .normal)
    }
    
    func setContent(packageDetail: MySpotPackageDetail) {
        mySpotMasterInfoView.setupTitleLabel(leftTitle: packageDetail.packageName, rightTitle: NSLocalizedString("Duration", comment: ""))
        mySpotMasterInfoView.setupValueLabele(leftValue: packageDetail.price?.currency, rightValue: packageDetail.packageDuration ?? NSLocalizedString("Not described", comment: ""))
        if let priceString = packageDetail.price {
            currentPrice = priceString
        }
    }
    
    func setPackagePrice(packagePrice:String) {
        currentPrice = packagePrice.formatPriceToDigitString()
        mySpotMasterInfoView.leftValueLabel.text = packagePrice.currency
        
    }
    
    func getPackagePrice() -> String? {
        return mySpotMasterInfoView.leftValueLabel.text?.formatPriceToString()
    }
}

// MARK: - MySpotMasterInfoViewDelegate
extension MySpotMasterInfoCell: MySpotMasterInfoViewDelegate {
    func leftViewDidTapped() {
        delegate?.editPackagePrice(currentPrice: currentPrice)
    }
    
    func rightViewDidTapped() {
        
    }
    
    
}
