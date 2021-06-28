//
//  EditProfileBasicPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/8/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol EditProfileBasicPageDelegate {
    func onUpdatePressed(firstname: String, lastname: String, username: String, birthdate: String, password: String)
    func onBirthdatePressed()
}

class EditProfileBasicPage : UIView {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var birthDateView: UITextField!
    @IBOutlet weak var updateProfileButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    var delegate : EditProfileBasicPageDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateProfileButton.makeItRounded(width:0.0, cornerRadius : self.updateProfileButton.bounds.height / 2)
        self.updateProfileButton.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
//        let datePickerView = UIDatePicker()
//        datePickerView.datePickerMode = .date
//        birthDateView.inputView = datePickerView
        
        birthDateView.isUserInteractionEnabled = true
        birthDateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDatePicker(_:))))
        birthDateView.tintColor = .clear

    }
    
    func showUserData(firstname: String, lastname: String, username: String, birthdate: String){
        self.nameField.text = firstname
        self.lastnameField.text = lastname
        self.userNameField.text = username
        self.birthDateView.text = birthdate
    }
    
    @objc func handleDatePicker(_ sender: UITapGestureRecognizer) {
        delegate?.onBirthdatePressed()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        birthDateView.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func onUpdatePressed(_ sender: Any) {
        self.delegate?.onUpdatePressed(firstname: self.nameField.text!, lastname: self.lastnameField.text! , username: self.userNameField.text!, birthdate: self.birthDateView.text!, password: self.passwordField.text ?? "")
    }
    
    func setBirthdateText(dateString: String){
        birthDateView.text = dateString
    }
    
    func getCurrentDate() -> Date? {
        guard let dateString = birthDateView.text, dateString != NSLocalizedString("Select date", comment: ""), let date = dateString.toDate("yyyy-MM-dd") else {
            return nil
        }
        
        return date.date
    }
}


