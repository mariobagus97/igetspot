////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol OrderIDHeaderCellDelegate:class {
    func orderIdCellDidClicked(orderId:String, isExpanded:Bool)
}

class OrderIDHeaderCell: MKTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    weak var delegate: OrderIDHeaderCellDelegate?
    var orderId:String?
    var isExpanded:Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    override func onSelected() {
        guard let orderId = self.orderId else {
            return
        }
        delegate?.orderIdCellDidClicked(orderId: orderId, isExpanded: isExpanded)
    }
    
    func setContent(orderId:String, isExpanded:Bool) {
        self.orderId = orderId
        self.isExpanded = isExpanded
        
        orderIdLabel.text = orderId
        let expandedImage = R.image.arrowDownWhite()
        let notExpandedImage = R.image.arrowRightWhite()
        arrowImageView.image = isExpanded ? expandedImage:notExpandedImage
    }
    
}
