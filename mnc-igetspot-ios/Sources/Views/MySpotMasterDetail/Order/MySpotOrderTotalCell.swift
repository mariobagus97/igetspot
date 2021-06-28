////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MySpotOrderTotalCell: MKTableViewCell {
    
    @IBOutlet weak var totalPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setContent(totalOrderPrice:Int) {
        totalPriceLabel.text = "\(totalOrderPrice)".currency
    }
    
}
