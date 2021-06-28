//
//  WalkthroughViewCell.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 20/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import FSPagerView

class WalkthroughViewCell: FSPagerViewCell {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.shadowRadius = 0
        self.contentView.layer.shadowOpacity = 0
        self.iconImageView.contentMode = .scaleAspectFit
    }
    
    
    func setupCell(withWalkthrough walkthrough:Walkthrough) {
        self.iconImageView.image = walkthrough.getImage()
        self.titleLabel.text = walkthrough.getTitle()
        self.descLabel.text = walkthrough.getDescription()
        self.descLabel.setLineHeight(lineHeight: 1.5)
    }

}
