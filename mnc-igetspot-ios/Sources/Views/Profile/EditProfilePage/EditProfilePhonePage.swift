//
//  EditProfilePhonePage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/12/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol EditProfilePhonePageDelegate {
    func onUpdatePressed(currentPhone: String, newPhone: String, passwordLogin: String)
}

class EditProfilePhonePage : UIView {
    
    @IBOutlet weak var currentPhoneField: UITextField!
    
    @IBOutlet weak var newPhoneField: UITextField!
    
    @IBOutlet weak var passwordLoginField: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var delegate : EditProfilePhonePageDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateButton.makeItRounded(width:0.0, cornerRadius : self.updateButton.bounds.height / 2)
        self.updateButton.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    @IBAction func onUpdatePressed(_ sender: Any) {
        self.delegate?.onUpdatePressed(currentPhone: currentPhoneField.text ?? "", newPhone: newPhoneField.text ?? "", passwordLogin: passwordLoginField.text ?? "")
    }
    
    func showData(currentPhone: String){
        currentPhoneField.text = currentPhone
    }
    
    
    
}

