////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol TransactionDetailOrderCompleteCellDelegate:class {
    func reviewConfirmButtonDidClicked()
    func reportButtonDidClicked()
}

class TransactionDetailOrderCompleteCell: MKTableViewCell {
    
    @IBOutlet weak var reviewConfirmButton: UIButton!
    @IBOutlet weak var reportButton: GradientBorderButton!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    weak var delegate: TransactionDetailOrderCompleteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        reviewConfirmButton.setTitle("Review & Confirm", for: .normal)
        reviewConfirmButton.makeItRounded(width:0.0, cornerRadius : reviewConfirmButton.bounds.height / 2)
        reviewConfirmButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        reportButton.setTitle("Report This Order", for: .normal)
        reportButton.setTitleColor(Colors.vividBlue, for: .normal)
        reportButton.setupButton(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], startPoint: CGPoint.zero, endPoint: CGPoint(x: 1, y: 0), cornerRadius: reportButton.bounds.height)
    }
    
    @IBAction func reviewConfirmButtonDidClicked() {
        delegate?.reviewConfirmButtonDidClicked()
    }
    
    @IBAction func reportButtonDidClicked() {
        delegate?.reportButtonDidClicked()
    }
}
