////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol TotalOrderProcessCellDelegate:class {
    func processOrderButtonDidClicked()
}

class TotalOrderProcessCell: MKTableViewCell {
    
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var processButton: UIButton!
    weak var delegate: TotalOrderProcessCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeGradientButton()
    }
    
    // MARK: - Actions
    @IBAction func processButtonDidClicked() {
        delegate?.processOrderButtonDidClicked()
    }

    // MARK: - Private Functions
    private func makeGradientButton(){
        processButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 0.35, yStartPos: 0, yEndPos: 0)
        processButton.makeItRounded(width: 0, cornerRadius: processButton.frame.height/2)
    }
    
    func setContent(price:String) {
        totalPriceLabel.text = price.currency
    }
    
    
}
