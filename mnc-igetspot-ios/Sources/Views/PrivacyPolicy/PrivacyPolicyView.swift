//
//  PrivacyPolicyView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/18/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class PrivacyPolicyView : UIView {
    
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setPrivacyPolicy(text : String){
        privacyPolicyLabel.setHTMLFromString(text: text)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}
