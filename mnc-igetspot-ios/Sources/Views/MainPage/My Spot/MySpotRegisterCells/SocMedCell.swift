//
//  SocMedCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/30/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class SocMedCell : MKTableViewCell {
    
    @IBOutlet weak var socmedIconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setContent(icon: UIImage){
        socmedIconImage.image = icon
    }
    
    
}
