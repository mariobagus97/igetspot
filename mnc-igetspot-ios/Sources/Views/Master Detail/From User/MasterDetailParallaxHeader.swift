//
//  MasterDetailParallaxHeader.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/16/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class MasterDetailParallaxHeader: UIView {
    
    var master = Master()
    
    
    @IBOutlet weak var masterNameLabel: UILabel!
    
    @IBOutlet weak var masterAddressLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var starImageView: UIImageView!
    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    @IBOutlet weak var chatImageView: UIImageView!
    
    @IBOutlet weak var nameContainerView: UIView!
    
    @IBOutlet weak var nameHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(master: Master){
        self.master = master
        
        masterNameLabel.text = master.masterName
        masterAddressLabel.text = master.address
        ratingLabel.text = String(format: "%.1f", Double(master.rating!))
        
        nameHeightConstraint.constant = nameContainerView.frame.size.height
//        nameHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
        
        
    }
    
    
}
