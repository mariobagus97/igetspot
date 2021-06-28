////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol TransactionDetailHelpContactStatusCellDelegate:class {
    func viewOrderStatusButtonDidClicked()
    func viewMasterLocationButtonDidClicked()
    func contactUsButtonDidClicked()
}

class TransactionDetailHelpContactStatusCell: MKTableViewCell {

    @IBOutlet weak var viewOrderStatusButton: UIButton!
    @IBOutlet weak var viewMasterLocationButton: GradientBorderButton!
    @IBOutlet weak var contactUsButton: UIButton!
    weak var delegate: TransactionDetailHelpContactStatusCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        viewOrderStatusButton.setTitle("View Your Order Status", for: .normal)
        viewOrderStatusButton.makeItRounded(width:0.0, cornerRadius : viewOrderStatusButton.bounds.height / 2)
        viewOrderStatusButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
//        viewMasterLocationButton.setTitle("View Master Location", for: .normal)
//        viewMasterLocationButton.setTitleColor(Colors.vividBlue, for: .normal)
//        viewMasterLocationButton.setupButton(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], startPoint: CGPoint.zero, endPoint: CGPoint(x: 1, y: 0), cornerRadius: viewMasterLocationButton.bounds.height)
    }
    
    // MARK: - Actions
    @IBAction func viewOrderStatusButtonDidClicked() {
        delegate?.viewOrderStatusButtonDidClicked()
    }
    
    @IBAction func viewMasterLocationButtonDidClicked() {
        delegate?.viewMasterLocationButtonDidClicked()
    }
    
    @IBAction func contactUsButtonDidClicked() {
        delegate?.contactUsButtonDidClicked()
    }
    
}
