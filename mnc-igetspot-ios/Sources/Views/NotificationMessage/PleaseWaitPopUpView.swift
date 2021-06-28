//
//  PleaseWaitPopUpView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/26/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftMessages

class PleaseWaitPopUpView : MessageView {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicatorView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        indicatorView.startAnimating()
        
        containerView.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: backgroundView.bounds.size.width / 4)
        
        
    }
    
}
