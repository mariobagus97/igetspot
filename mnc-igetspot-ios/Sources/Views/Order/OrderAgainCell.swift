////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol OrderAgainCellDelegate:class {
    func orderAgainButtonDidClicked(orderPackage:OrderHistoryPackage)
}

class OrderAgainCell: MKTableViewCell {
    
    @IBOutlet weak var orderAgainButton: UIButton!
    weak var delegate: OrderAgainCellDelegate?
    var orderPackage:OrderHistoryPackage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeGradientButton()
    }
    
    // MARK: - Actions
    @IBAction func orderButtonDidClicked() {
        guard let orderPackage = self.orderPackage else {
            return
        }
        delegate?.orderAgainButtonDidClicked(orderPackage: orderPackage)
    }
    
    // MARK: - Private Functions
    private func makeGradientButton(){
        orderAgainButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 0.35, yStartPos: 0, yEndPos: 0)
        orderAgainButton.makeItRounded(width: 0, cornerRadius: orderAgainButton.frame.height/2)
    }
    
    func setContent(orderPackage: OrderHistoryPackage) {
        self.orderPackage = orderPackage
    }
    
}
