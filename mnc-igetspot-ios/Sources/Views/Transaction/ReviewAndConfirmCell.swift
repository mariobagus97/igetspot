////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol ReviewAndConfirmCellDelegate:class {
    func reviewAndConfirmButtonDidClicked(orderId:String, master:ActiveTransactionMaster, package:ActiveTransactionPackage)
}

class ReviewAndConfirmCell: MKTableViewCell {
    @IBOutlet weak var reviewAndConfirmButton: UIButton!
    var orderId:String?
    var activeTransactionMaster: ActiveTransactionMaster?
    var activeTransactionPackage: ActiveTransactionPackage?
    weak var delegate: ReviewAndConfirmCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewAndConfirmButton.makeItRounded(width: 0, cornerRadius: reviewAndConfirmButton.frame.size.height / 2)
        reviewAndConfirmButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    // MARK: - Actions
    @IBAction func reviewAndConfirmButtonButtonDidClicked() {
        guard let orderId = self.orderId, let activeTransactionMaster = self.activeTransactionMaster, let package = self.activeTransactionPackage else {
            return
        }
        delegate?.reviewAndConfirmButtonDidClicked(orderId: orderId, master: activeTransactionMaster, package: package)
    }
    
}
