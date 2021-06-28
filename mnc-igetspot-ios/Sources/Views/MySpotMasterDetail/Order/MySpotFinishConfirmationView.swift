////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotFinishConfirmationViewDelegate:class {
    func backToOrderButtonDidClicked()
}

class MySpotFinishConfirmationView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backToOrderButton: UIButton!
    weak var delegate: MySpotFinishConfirmationViewDelegate?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        adjustLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        adjustLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Layouts
    private func adjustLayout() {
        backToOrderButton.makeItRounded(width:0.0, cornerRadius : backToOrderButton.bounds.height / 2)
        backToOrderButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: NSLocalizedString("Transaction amount will be transferred to your balance once you get the review, or automatically 2 days after the order is marked as finished.", comment: ""))
        attributedString.setColorForText(textForAttribute: "once you get the review", withColor: UIColor.black, withFont: R.font.barlowMedium(size: 12))
        attributedString.setColorForText(textForAttribute: "automatically 2 days after the order is marked as finished", withColor: UIColor.black, withFont: R.font.barlowMedium(size: 12))
        descriptionLabel.attributedText = attributedString
    }
    
    // MARK: - Actions
    @IBAction func backToOrderButtonDidClicked() {
        delegate?.backToOrderButtonDidClicked()
    }

}
