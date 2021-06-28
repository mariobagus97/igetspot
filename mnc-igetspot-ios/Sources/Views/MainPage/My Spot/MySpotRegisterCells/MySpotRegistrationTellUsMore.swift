//
//  MySpotRegistrationTellUsMore.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/28/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KMPlaceholderTextView

protocol MySpotRegistrationTellUsMoreDelegate {
    func showTimeWorkPicker()
    func onContinue(masterName: String, describeWork: String, workTime: String,
                                                      instagram: String, linkedin: String, youtube: String, website: String)
}

class MySpotRegistrationTellUsMore : UIView {
    
    @IBOutlet weak var masterNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var describeWorkTextView: KMPlaceholderTextView!
    @IBOutlet weak var instagramField: UITextField!
    @IBOutlet weak var linkedinField: UITextField!
    @IBOutlet weak var youtubeField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var workField: SkyFloatingLabelTextField!
    @IBOutlet weak var describeWorkLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    let thisBaseFont = R.font.barlowRegular(size: 14)
    
    var delegate : MySpotRegistrationTellUsMoreDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupFont()
        setupButton()
        addGesture()
    }
    
    func setupFont() {
        
        masterNameField.lineHeight = 0
        masterNameField.lineColor = UIColor.clear
        masterNameField.placeholder = NSLocalizedString("Master Name", comment: "")
        masterNameField.title = NSLocalizedString("Master Name", comment: "")
        masterNameField.placeholderFont = self.thisBaseFont!
        masterNameField.placeholderColor = Colors.placeholderGray
        masterNameField.titleFont = self.thisBaseFont!
        masterNameField.tintColor = Colors.blueTwo
        masterNameField.selectedTitleColor = Colors.blueTwo
        masterNameField.titleFormatter = { $0 }
        
        workField.lineHeight = 0
        workField.lineColor = UIColor.clear
        workField.placeholder = NSLocalizedString("How long have you been in your field?", comment: "")
        workField.title = NSLocalizedString("How long have you been in your field?", comment: "")
        workField.placeholderFont = self.thisBaseFont!
        workField.placeholderColor = Colors.placeholderGray
        workField.titleFont = self.thisBaseFont!
        workField.tintColor = Colors.blueTwo
        workField.selectedTitleColor = Colors.blueTwo
        workField.titleFormatter = { $0 }
        
        describeWorkTextView.placeholderFont = self.thisBaseFont
        describeWorkTextView.font = self.thisBaseFont
        
        describeWorkLabel.textColor = .white
        describeWorkTextView.delegate = self
    }
    
    func setupButton(){
        continueButton.makeItRounded(width:0.0, cornerRadius : continueButton.bounds.height / 2)
        continueButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    
    }
    
    func addGesture(){
        workField.isUserInteractionEnabled = true
        workField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showWorkPicker(_:))))
    }
    
    @objc func showWorkPicker(_ sender: UITapGestureRecognizer) {
        describeWorkTextView.resignFirstResponder()
        self.delegate?.showTimeWorkPicker()
    }
    
    @objc func changeWorkLabelColor(_ sender: UITapGestureRecognizer){
//        describeWorkLabel.textColor = UIColor.rgb(red: 155, green: 155, blue: 155)
    }
    
    func setLongWork(time: String){
        workField.text = time
    }
    
    @IBAction func onContinuePressed(_ sender: Any) {
          self.delegate?.onContinue(masterName: masterNameField.text!, describeWork: describeWorkTextView.text, workTime: workField.text!, instagram: instagramField.text!, linkedin: linkedinField.text!, youtube: youtubeField.text!, website: websiteField.text!)
    }
}

extension MySpotRegistrationTellUsMore : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        describeWorkLabel.textColor = Colors.blueTwo
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text != nil && textView.text != "") {
            describeWorkLabel.textColor = Colors.gray
        } else {
            describeWorkLabel.textColor = .white
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text != nil && textView.text != "") {
            describeWorkLabel.textColor = Colors.blueTwo
            var newFrame = self.describeWorkTextView.frame
            let width = newFrame.size.width
            let newSize = self.describeWorkTextView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
            
            newFrame.size = CGSize(width: width, height: newSize.height)
            textView.frame = newFrame
            
            
            self.textViewHeight.constant = newSize.height
            self.describeWorkTextView.setNeedsLayout()
            self.describeWorkTextView.layoutIfNeeded()
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
        } else {
            self.textViewHeight.constant = 45.0
            self.describeWorkTextView.setNeedsLayout()
            self.describeWorkTextView.layoutIfNeeded()
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
            describeWorkLabel.textColor = .white
        }
    }
}
