//
//  RadioButtonDoubleLabelCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 01/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class RadioButtonDoubleLabelCell: UITableViewCell {
    
    @IBOutlet weak var radioButton: KGRadioButton!
    @IBOutlet weak var firstlabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        radioButton.isUserInteractionEnabled = true
    }
    
    func setContent(firstString:String?, secondString: String?, isSelected:Bool) {
        
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
        firstlabel.text = firstString
        firstlabel.font = font
        
        secondLabel.text = secondString
        secondLabel.textColor = textColor
        secondLabel.font = font
    }
}
