////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class SubTotalOrderCell: MKTableViewCell {
    
    @IBOutlet weak var subTotalTitleLabel: UILabel!
    @IBOutlet weak var subTotalPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setContent(price:String) {
        subTotalPriceLabel.text = price.currency
    }
    
}
