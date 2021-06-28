//
//  ForgetPasswordView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/21/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol ForgetPasswordViewDelegate {
    func onForgetPressed(email: String)
    func backButtonPressed()
}

class ForgetPasswordView: UIView {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var forgetPasswordButton: UIButton!

    var delegate : ForgetPasswordViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        forgetPasswordButton.makeItRounded(width:0.0, cornerRadius : forgetPasswordButton.bounds.height / 2)
        
        forgetPasswordButton.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    
    @IBAction func onForgetPressed(_ sender: Any) {
        self.delegate?.onForgetPressed(email: self.emailTextField.text ?? "")
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.delegate?.backButtonPressed()
    }
    
}

