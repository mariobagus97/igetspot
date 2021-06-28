////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol OrderStatusCellDelegate {
    func onWaitingPaymentClicked(txid: String)
}

class OrderStatusCell: MKTableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var backgroundStatusView: UIView!
    
    var txid: String?
    var delegate: OrderStatusCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onStatusPressed(_:))))
    }
    
    @objc func onStatusPressed(_ sender: UITapGestureRecognizer){
        if (self.txid != ""){
            self.delegate?.onWaitingPaymentClicked(txid: self.txid ?? "")
        }
    }
    
    
}
