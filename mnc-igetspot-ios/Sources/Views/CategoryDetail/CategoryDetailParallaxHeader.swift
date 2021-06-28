//
//  CategoryDetailParallaxHeader.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/30/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class CategoryDetailParallaxHeader : UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var imageUrlString: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        overlayView.applyGradient(colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.3)], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 0.1)
    }
    
    func setTitle(title: String){
        self.titleLabel.text = title
    }
    
    func setBackgroundImage(urlString:String) {
        backgroundImageView.loadIGSImage(link: urlString)
    }
}
