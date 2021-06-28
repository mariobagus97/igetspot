//
//  ProfileMenuTVCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/25/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class ProfileMenuTVCell : MKTableViewCell {
    
    @IBOutlet weak var profileListLabel: UILabel!
    
    @IBOutlet weak var intoMenuLabel: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func loadView() {
        super.loadView()
        containerView.isUserInteractionEnabled = true
        
//        intoMenuLabel.transform = CGAffineTransform(rotationAngle: -120)
        
        
    }
    
    func setContent(listName: String) {
        profileListLabel.text = listName
    }
    
}
