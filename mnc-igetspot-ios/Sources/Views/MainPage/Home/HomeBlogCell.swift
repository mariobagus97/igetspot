//
//  HomeBlogCell.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 20/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import FSPagerView

class HomeBlogCell: FSPagerViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabelTopConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.shadowRadius = 0
        self.contentView.layer.shadowOpacity = 0
        
        if (UIDevice.current.hasTopNotch) {
            titleLabelTopConstraints.constant += 20
        }
    }
    
    func setContent(withWhatsOn whatsOn:Whatson) {
        self.backgroundImageView?.loadIGSImage(link: whatsOn.imageUrl ?? "")
        titleLabel.text = whatsOn.title
        authorLabel.text = whatsOn.author
    }
    
    func setTextLabel(withTitle title:String?, andAuthor author:String?) {
        if let titleString = title, let authorString = author {
            let separatorString = "|"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(titleString)   \(separatorString)   \(authorString)")
            attributedString.setColorForText(textForAttribute: titleString, withColor: UIColor.white, withFont: R.font.barlowBold(size: 20))
            attributedString.setColorForText(textForAttribute: separatorString, withColor: UIColor.white, withFont: R.font.barlowRegular(size: 26))
            attributedString.setColorForText(textForAttribute: authorString, withColor: UIColor.white, withFont: R.font.barlowRegular(size: 14))
            titleLabel.attributedText = attributedString
        }
    }

}
