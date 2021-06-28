//
//  BlogDetailCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 25/10/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class BlogDetailHeaderCell: MKTableViewCell {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageHeight.constant = self.frame.size.width * 0.6 
    }
    
    // MARK: - Public Function
    func setContent(withImageUrl imageUrl:String, title:String) {
        headerImageView.loadIGSImage(link: imageUrl)
        titleLabel.text = title
        
        overlayView.applyGradient(colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.5)], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 0.1)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}
