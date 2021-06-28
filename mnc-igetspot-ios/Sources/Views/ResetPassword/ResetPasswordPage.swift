//
//  ResetPasswordPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 23/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol ResetPasswordPageDelegate: class {
    func changePassword(password: String, confirmpassword: String)
}

class ResetPasswordPage: UIView {
    
    @IBOutlet weak var newPasswordFiedl: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordField: SkyFloatingLabelTextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    weak var delegate : ResetPasswordPageDelegate!
    let thisBaseFont = R.font.barlowRegular(size: 14)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setFieldFont()
        setButton()
    }
    
    func setFieldFont(){
        newPasswordFiedl.lineHeight = 0
//        newPasswordFiedl.lineColor = UIColor.clear
        newPasswordFiedl.placeholder = NSLocalizedString("New Password", comment: "")
        newPasswordFiedl.title = NSLocalizedString("New Password", comment: "")
        newPasswordFiedl.placeholderFont = self.thisBaseFont!
        newPasswordFiedl.placeholderColor = Colors.placeholderGray
        newPasswordFiedl.titleFont = self.thisBaseFont!
        newPasswordFiedl.tintColor = Colors.placeholderGray
        newPasswordFiedl.selectedTitleColor = Colors.placeholderGray
        newPasswordFiedl.titleFormatter = { $0 }
        
        confirmPasswordField.lineHeight = 0
//        confirmPasswordField.lineColor = UIColor.clear
        confirmPasswordField.placeholder = NSLocalizedString("Confirm Password", comment: "")
        confirmPasswordField.title = NSLocalizedString("Confirm Password", comment: "")
        confirmPasswordField.placeholderFont = self.thisBaseFont!
        confirmPasswordField.placeholderColor = Colors.placeholderGray
        confirmPasswordField.titleFont = self.thisBaseFont!
        confirmPasswordField.tintColor = Colors.placeholderGray
        confirmPasswordField.selectedTitleColor = Colors.placeholderGray
        confirmPasswordField.titleFormatter = { $0 }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setButton(){
        changePasswordButton.makeItRounded(width:0.0, cornerRadius :changePasswordButton.bounds.height / 2)
        changePasswordButton.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    @IBAction func onChangePressed(_ sender: Any) {
        delegate?.changePassword(password: newPasswordFiedl.text ?? "", confirmpassword: confirmPasswordField.text ?? "")
    }
}
