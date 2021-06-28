//
//  MySpotRegistrationStep3.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/2/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import DLRadioButton
import SkyFloatingLabelTextField

protocol MySpotRegistrationStep3Delegate {
    func onAddPhotosClicked()
    func onAddSelfiePhotoClicked()
    func showToast(message: String)
    func onGetMySpotPressed(data: MySpotRegisStep3)
}

class MySpotRegistrationStep3 : UIView{
    
    
    @IBOutlet weak var idNumberField: SkyFloatingLabelTextField!
    var delegate : MySpotRegistrationStep3Delegate?
    
    @IBOutlet weak var idNumberImageView: UIImageView!
    @IBOutlet weak var selfieWithIdImageView: UIImageView!
    @IBOutlet weak var getMySpotButton: UIButton!
    
    var type : Int!
    var data = MySpotRegisStep3()
    let thisBaseFont = R.font.barlowRegular(size: 14)
    
    override func awakeFromNib() {
        super.awakeFromNib()

        idNumberImageView.isUserInteractionEnabled = true
        selfieWithIdImageView.isUserInteractionEnabled = true
        idNumberImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddIdNumberPressed(_:))))
        selfieWithIdImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddSelfiePressed(_:))))
        
        self.getMySpotButton.makeItRounded(width:0.0, cornerRadius : self.getMySpotButton.bounds.height / 2)
        self.getMySpotButton.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        adjustTextFields()

    }
    
    func adjustTextFields() {
        idNumberField.lineHeight = 0
        idNumberField.lineColor = UIColor.clear
        idNumberField.placeholder = NSLocalizedString("ID Number (KTP)", comment: "")
        idNumberField.title = NSLocalizedString("ID Number (KTP)", comment: "")
        idNumberField.placeholderFont = self.thisBaseFont!
        idNumberField.placeholderColor = Colors.placeholderGray
        idNumberField.titleFont = self.thisBaseFont!
        idNumberField.tintColor = Colors.blueTwo
        idNumberField.selectedTitleColor = Colors.blueTwo
        idNumberField.titleFormatter = { $0 }
        idNumberField.delegate = self
    }

    @objc func onAddIdNumberPressed(_ sender: UITapGestureRecognizer){
       self.delegate?.onAddPhotosClicked()
    }
    
    @objc func onAddSelfiePressed(_ sender: UITapGestureRecognizer){
        self.delegate?.onAddSelfiePhotoClicked()
    }
    
    @IBAction func onGetMySpotPressed(_ sender: Any) {
        data.acceptTerm = "1"
        if (idNumberField.text?.count == 16){
            data.idCard = idNumberField.text
        } else {
            delegate?.showToast(message: "Please enter valid ID Card Number, it must be 16 characters long.")
        }
            
        self.delegate?.onGetMySpotPressed(data: data)
    }
    
    func setPhotoID(image: UIImage){
        idNumberImageView.contentMode = .scaleAspectFill
        idNumberImageView.image = image
    }
    
    func setPhotoSelfe(image: UIImage){
        selfieWithIdImageView.contentMode = .scaleAspectFill
        selfieWithIdImageView.image = image
    }
   
    
}

extension MySpotRegistrationStep3 : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn:"0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet) && textField.text?.count ?? 0 <= 16

       }
}
