//
//  AmountBalanceCell.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 17/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class AmountBalanceCell: MKTableViewCell {
    
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var detailedButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func detailedButtonDidClicked() {
        
    }
    
}
