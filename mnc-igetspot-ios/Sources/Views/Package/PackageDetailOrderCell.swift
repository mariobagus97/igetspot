////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol PackageDetailOrderCellDelegate: class {
    func orderButtonDidClicked()
}

class PackageDetailOrderCell: MKTableViewCell {
    
    @IBOutlet weak var orderButton: UIButton!
    weak var delegate: PackageDetailOrderCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        orderButton.setTitle(NSLocalizedString("Order", comment: ""), for: .normal)
        orderButton.makeItRounded(width: 0, cornerRadius: 20.0)
        makeGradientButton()
    }
    
    // MARK: - Private Functions
    func makeGradientButton(){
        orderButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    // MARK: - Actions
    @IBAction func orderButtonDidClicked() {
        delegate?.orderButtonDidClicked()
    }
}
