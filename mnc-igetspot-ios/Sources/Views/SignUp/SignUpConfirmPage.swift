//
//  SignUpConfirmPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/15/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol SignUpConfirmPageDelegate {
    func didHidePressed()
}

class SignUpConfirmPage : UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    var delegate : SignUpConfirmPageDelegate!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        imageView.image = R.image.afterRegistration()
    }
    
    
    @IBAction func onHidePressed(_ sender: Any) {
        self.delegate?.didHidePressed()
    }
}
