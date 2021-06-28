////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MySpotOrderCustomerCell: MKTableViewCell {
    
    @IBOutlet weak var customerContainerView: UIView!
    @IBOutlet weak var customerImageView: UIImageView!
    @IBOutlet weak var customerNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        customerImageView.setRounded()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContent(imageUrl:String, customerName:String) {
        customerImageView.load(link: imageUrl, placeholderImage: R.image.userPlacaholder())
        customerNameLabel.text = customerName
    }
}
