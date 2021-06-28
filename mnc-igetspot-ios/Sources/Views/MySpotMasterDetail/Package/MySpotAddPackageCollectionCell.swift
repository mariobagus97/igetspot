////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MySpotAddPackageCollectionCell: MKCollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func loadView() {
        super.loadView()
        
        self.containerView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
    }
    
    func setupCell(name:String, image:UIImage? = nil) {
        addNameLabel.text = name
        iconImageView.image = image
    }
}
