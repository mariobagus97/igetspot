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
    
    let csString = "Kamu bisa menghubungi i Get Spot dengan mengirimkan email ke "
    let csEmailString = "cs@igetspot.com "
    let telpString = "atau telepon ke "
    let phoneString = "+62 21 7303312"
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    func setLabel(textString:String, boldTextArray:[String]?) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: textString)
        if let boldArray = boldTextArray {
            for boltText in boldArray {
                attributedString.setColorForText(textForAttribute: boltText, withColor: UIColor.black, withFont: R.font.barlowMedium(size: 14))
            }
        }
        csLabel.attributedText = attributedString
    }
    
}
