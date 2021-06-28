////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class WithdrawalDescriptionCell: MKTableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setContent()
    }
    
    func setContent() {
        let contentTextString = "You will receive your payment within 2x24 hours. If not receive your payment after that period of time please fell free to contact our customer service at cs@igetspot.com."
        let boldText = "cs@igetspot.com"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: contentTextString)
        attributedString.setColorForText(textForAttribute: boldText, withColor: UIColor.black, withFont: R.font.barlowMedium(size: 14))
        
        descriptionLabel.attributedText = attributedString
    }
    
}
