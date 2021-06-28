//
//  EditProfileEmailPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/12/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol EditProfileEmailPageDelegate {
    func onUpdatePressed(currentEmail: String, newEmail: String, passwordLogin: String)
}


class EditProfileEmailPage : UIView {
    
    @IBOutlet weak var currentEmailField: UITextField!
    
    @IBOutlet weak var newEmailField: UITextField!
    
    @IBOutlet weak var passwordLoginField: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var delegate : EditProfileEmailPageDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateButton.makeItRounded(width:0.0, cornerRadius : self.updateButton.bounds.height / 2)
        self.updateButton.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    @IBAction func onUpdatePressed(_ sender: Any) {
        self.delegate?.onUpdatePressed(currentEmail: currentEmailField.text ?? "", newEmail: newEmailField.text ?? "", passwordLogin: passwordLoginField.text ?? "")
    }
    
    func showUserData(currentEmail: String){
//        DispatchQueue.main.async {
        print("text before \(self.currentEmailField.text)")
             self.currentEmailField.text = currentEmail
//        }
        
        print("text after \(self.currentEmailField.text)")
       
        layoutIfNeeded()
    }
    
}
