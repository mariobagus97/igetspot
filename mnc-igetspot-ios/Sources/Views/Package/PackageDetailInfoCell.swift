////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import Cosmos

class PackageDetailInfoCell: MKTableViewCell {
    
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalReview: UILabel!
    @IBOutlet weak var ratingView:CosmosView!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setContent(packageDetail:PackageDetail) {
        packageNameLabel.text = packageDetail.packageName
        priceLabel.text = packageDetail.price?.currency
        ratingView.settings.updateOnTouch = false
        if let ratingString = packageDetail.rating, let rating = Double(ratingString) {
            ratingView.rating = Double(rating)
        } else {
            ratingView.rating = 0.0
        }
        
    }
    
}
