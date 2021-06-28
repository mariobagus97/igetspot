////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class HistoryOrderIdStatusCell: MKTableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var statusOrderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }

    func setContent(orderId:String, statusOrder:String, statusOrderString:String) {
        statusOrderLabel.text = statusOrderString
        orderIdLabel.text = orderId
        if let orderStatusInt = Int(statusOrder), let orderStatus = OrderStatus(rawValue: orderStatusInt) {
            if (orderStatus == .decline) {
                containerView.removeGradient()
                containerView.backgroundColor = Colors.gradientThemeOne
            }
        }
    }
}
