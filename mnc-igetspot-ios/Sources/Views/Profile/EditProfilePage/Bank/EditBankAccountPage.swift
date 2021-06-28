//
//  EditBankAccount.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/12/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol EditBankAccountPageDelegate {
    func didChooseBankPressed(bankId: String)
    func onUpdatePressed(bankId: String, bankAccountHolder: String, bankAccountNumber: String, passwordLogin: String)
}

class EditBankAccountPage : UIView {
    
    @IBOutlet weak var bankAccountLabel: UILabel!
    @IBOutlet weak var bankAccountNameLabel: UILabel!
    @IBOutlet weak var bankAccountNumberLabel: UILabel!
    @IBOutlet weak var chooseYourBankView: UIView!
    @IBOutlet weak var bankNameLabel: UITextField!
    @IBOutlet weak var accountHolderField: UITextField!
    @IBOutlet weak var accountNumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    var bank : Bank!
    var userBank : UserBankDetail!
    
    var delegate : EditBankAccountPageDelegate?
    var bankId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accountNumberField.keyboardType = .numberPad
        accountNumberField.delegate = self
        
        self.updateButton.makeItRounded(width:0.0, cornerRadius : self.updateButton.bounds.height / 2)
        self.updateButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        addGesture()
    }
    
    func showUserData(bankDetail : UserBankDetail){
        self.bankId = bankDetail.bankId ?? ""
        self.userBank = bankDetail
        self.bankNameLabel.text = bankDetail.bankName
        self.accountHolderField.text = bankDetail.accountHolder
        self.accountNumberField.text = bankDetail.accountNo
    }
    
    func setBank(bank: Bank, bankId: String){
        self.bankId = bank.id ?? ""
        self.bank = bank
        self.bankNameLabel.text = bank.bankName
    }
    
    func addGesture(){
        chooseYourBankView.isUserInteractionEnabled = true
        chooseYourBankView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onChooseBankPressed(_:))))
    }
    

    @objc func onChooseBankPressed(_ sender: UITapGestureRecognizer){
        self.delegate?.didChooseBankPressed(bankId: self.bankId ?? "")
    }
    
    @IBAction func onUpdatePressed(_ sender: Any) {
        self.delegate?.onUpdatePressed(bankId: self.bankId , bankAccountHolder: self.accountHolderField.text ?? "", bankAccountNumber: self.accountNumberField.text ?? "", passwordLogin: passwordField.text ?? "")
    }
    
}

extension EditBankAccountPage : UITextFieldDelegate {
    //MARK - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For numers
        if textField == accountNumberField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
