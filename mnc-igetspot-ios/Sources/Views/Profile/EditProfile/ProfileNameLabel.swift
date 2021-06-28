//
//  ProfileNameLabel.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/25/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class ProfileNameLabel : MKTableViewCell{
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var itemPlaceholderLabel: UILabel!
    
    
    @IBOutlet weak var itemContentView: UITextView!
    
    
    @IBOutlet weak var itemContentField: UITextField!
    
    var placeHolderText : String!
    
    let datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        itemContentView.delegate = self
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setContent(itemName: String?, itemPlaceholder: String?, itemContent: String?){
        
        self.itemNameLabel.text = itemName
        
        //        self.placeHolderText = itemPlaceholder
        
        self.itemContentField.placeholder = itemPlaceholder
        
        if (itemName != nil){
            if (itemName?.contains("Password"))!{
                itemContentField.isSecureTextEntry = true
            } 
        }
        
        if (itemContent != nil){
            itemContentField.text = itemContent
        }
        //        if itemName == nil {
        //            itemNameLabel.removeFromSuperview()
        //        } else {
        //            itemNameLabel.text = itemName
        //
        //            if(itemName?.contains("Date"))!{
        //
        //            }
        //
        //            if (itemName?.contains("Password"))!{
        //                itemContentView.removeFromSuperview()
        //                itemContentField.text = ""
        //                itemContentField.isSecureTextEntry = true
        //            } else {
        //                itemContentField.removeFromSuperview()
        //            }
        //        }
        //
        //        if itemPlaceholder == nil {
        //            itemPlaceholderLabel.removeFromSuperview()
        //        } else {
        //            itemPlaceholderLabel.contentMode = .scaleToFill
        //            itemPlaceholderLabel.numberOfLines = 0
        //            itemPlaceholderLabel.text = itemPlaceholder
        //        }
        //
        //        if itemContent == nil {
        //             itemContentView.removeFromSuperview()
        //             itemContentField.removeFromSuperview()
        //        } else {
        //            if (itemContentView.isDescendant(of: self)){
        //                itemContentView.text = itemContent
        //            } else {
        //                itemContentField.addTarget(self, action: #selector(self.showDatePicker(_:)), for: .touchUpInside)
        //
        //                itemContentField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDatePicker(_:))))
        //
        //
        //                itemContentField.text = itemContent
        //            }
        //        }
    }
    
    @objc func showDatePicker(_ sender: UITapGestureRecognizer){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        itemContentField.inputAccessoryView = toolbar
        itemContentField.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        itemPlaceholderLabel.text = formatter.string(from: datePicker.date)
        endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        endEditing(true)
    }
    
    //    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    //
    //        self.itemContentView.textColor = .black
    //
    //        if(self.itemContentView.text == placeHolderText) {
    //            self.itemContentView.text = ""
    //        }
    //
    //        return true
    //    }
    //
    //    func textViewDidEndEditing(_ textView: UITextView) {
    //        if(itemContentView.text == "") {
    //            self.itemContentView.text = placeHolderText
    //            self.itemContentView.textColor = .lightGray
    //        }
    //    }
    
    //    override func viewWillAppear(animated: Bool) {
    //
    //        if(currentQuestion.answerDisplayValue == "") {
    //            self.itemContentView.text = placeHolderText
    //            self.itemContentView.textColor = .lightGray
    //        } else {
    //            self.itemContentView.text = "xxx" // load default text / or stored
    //            self.itemContentView.textColor = .black
    //        }
    //    }
    
}
