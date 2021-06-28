//
//  TransactionCSCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/28/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class TransactionDotListCell : MKTableViewCell {
    
    @IBOutlet weak var csLabel: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    func setLabel(textString:String, boldTextArray:[String]?) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: textString)
        if let boldText = boldTextArray {
            for boltText in boldText {
                attributedString.setColorForText(textForAttribute: boltText, withColor: UIColor.black, withFont: R.font.barlowMedium(size: 14))
            }
        }
        csLabel.attributedText = attributedString
    }
    
}
