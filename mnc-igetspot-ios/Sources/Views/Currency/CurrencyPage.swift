//
//  CurrencyPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/19/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import SwiftMessages

class CurrencyPage : MessageView {
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: 10)
    }
}
