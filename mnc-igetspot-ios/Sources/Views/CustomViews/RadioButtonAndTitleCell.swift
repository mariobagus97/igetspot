//
//  RadioButtonAndTitleCell.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 02/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class RadioButtonAndTitleCell: UITableViewCell {
    
    @IBOutlet weak var radioButton: KGRadioButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        radioButton.isUserInteractionEnabled = true
    }

    func setContent(withTitle title:String?, isSelected:Bool) {
        
        var textColor:UIColor!
        var font: UIFont!
        if isSelected {
            textColor = UIColor.black
            font = R.font.barlowMedium(size: 14)!
        } else {
            textColor = Colors.gray
            font = R.font.barlowRegular(size: 14)!
        }
        radioButton.isSelected = isSelected
        titleLabel.text = title
        titleLabel.textColor = textColor
        titleLabel.font = font
        setNeedsLayout()
        layoutIfNeeded()
    }
    
}
