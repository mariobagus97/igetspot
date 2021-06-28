////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class BalanceCell: MKTableViewCell {
    
    @IBOutlet weak var balanceDateLabel: UILabel!
    @IBOutlet weak var balanceTotalLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setContent(balance:String, date:String) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Balance until: \(date)")
        attributedString.setColorForText(textForAttribute: date, withColor: UIColor.black, withFont: R.font.barlowMedium(size: 14))
        balanceDateLabel.attributedText = attributedString
        balanceTotalLabel.text = balance.currency
    }
    
}
