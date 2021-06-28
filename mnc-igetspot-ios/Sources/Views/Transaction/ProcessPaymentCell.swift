////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol ProcessPaymentCellDelegate:class {
    func processPaymentButtonDidClicked(invoiceID: String?, orderId:String, txId:String?, total: Int)
}

class ProcessPaymentCell: MKTableViewCell {

    @IBOutlet weak var processPaymentButton: UIButton!
    var orderId:String?
    var tXid:String?
    var total:Int?
    var invoiceID:String?
    weak var delegate: ProcessPaymentCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        processPaymentButton.makeItRounded(width: 0, cornerRadius: processPaymentButton.frame.size.height / 2)
        processPaymentButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    // MARK: - Actions
    @IBAction func processPaymentButtonDidClicked() {
        guard let orderId = self.orderId else {
            return
        }
        delegate?.processPaymentButtonDidClicked(invoiceID: invoiceID, orderId: orderId, txId: tXid, total: total ?? 0)
    }
    
}
