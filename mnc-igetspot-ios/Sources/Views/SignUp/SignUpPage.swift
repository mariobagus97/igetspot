//
//  SignUpComponent.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 9/18/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

protocol SignUpProtocol : NSObjectProtocol{
    func signUp(email: String, password:String)
    func signInFacebook()
    func signInGoogle()
    func signInApple()
    func exploreAppPressed()
    func onPolicyPressed()
    func onUserAgreementPressed()
    func backButtonPressed()
}

class SignUpPage: UIView{
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var bSignUp: UIButton!
    @IBOutlet weak var signInFacebookView: UIView!
    @IBOutlet weak var SignInGoogleView: UIView!
    @IBOutlet weak var loginProviderStackView: UIStackView!
    @IBOutlet weak var lRequireEmail: UILabel!
    @IBOutlet weak var lRequirePassword: UILabel!
    @IBOutlet weak var lRequireConfirmPassword: UILabel!
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var lExploreApp: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var safeAreaTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var superviewTopConstraints: NSLayoutConstraint!
    var privacyPolicyString : NSAttributedString!
    weak var delegate : SignUpProtocol? = nil // for getting connected ViewController
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 11.0, *) {
            self.removeConstraint(superviewTopConstraints)
        } else {
            self.removeConstraint(safeAreaTopConstraints)
        }
        
        customViewComponent()
        
    }
    
    // -- CUSTOM VIEW
    func customViewComponent(){
        
        
        makeRoundedButton()
        makeGradientButton()
        addGesture()
        
        self.makeTextFieldBlank(textfield: tfEmail)
        self.makeTextFieldBlank(textfield: tfPassword)
        self.makeTextFieldBlank(textfield: tfConfirmPassword)
        
        self.hideLabel(label: lRequireEmail)
        self.hideLabel(label: lRequirePassword)
        self.hideLabel(label: lRequireConfirmPassword)
        
        //setAgreementLabel()
        setAgreement()
        
        if #available(iOS 13.0, *) {
            setupProviderLoginView()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func makeRoundedButton() {
        // make button rounded
        bSignUp.makeItRounded(width:0.0, cornerRadius :bSignUp.bounds.height / 2)
        signInFacebookView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius :signInFacebookView.bounds.height / 2)
        SignInGoogleView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius : SignInGoogleView.bounds.height / 2)
    }
    
    func makeGradientButton(){
        bSignUp.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    func addGesture(){
        
        signInFacebookView.isUserInteractionEnabled = true
        signInFacebookView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignInFacebookPressed(_:))))
        
        SignInGoogleView.isUserInteractionEnabled = true
        SignInGoogleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignInGooglePressed(_:))))
        
        let tapAction = UITapGestureRecognizer(target: self, action:#selector(bExploreAppPressed(_:)))
        lExploreApp.isUserInteractionEnabled = true
        lExploreApp.addGestureRecognizer(tapAction)
        
        agreementLabel.isUserInteractionEnabled = true
        agreementLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAgreementPressed(gesture:))))
        
    }
    
    /// - Tag: add_appleid_button
    @available(iOS 13.0, *)
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(onAuthorizationAppleIDButtonPressed), for: .touchUpInside)
        authorizationButton.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius : loginProviderStackView.bounds.height / 2)
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    func setAgreement(){
        agreementLabel.text = "By signing up, i agree to i get Spot's Terms & Conditions and Privacy Policy"
        let agreement = (self.agreementLabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: agreement)
        let range1 = (agreement as NSString).range(of: "Terms & Conditions")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range1)
        let range2 = (agreement as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range2)
        agreementLabel.attributedText = underlineAttriString
        
    }
    
    func setAgreementLabel(){
        
        // create attributed string
        let myString = "By signing up, i agree to i get Spot's "
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        
        // create attributed string
        let myString1 = "Terms & Conditions "
        let myAttribute1 = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
        let myAttrString1 = NSAttributedString(string: myString1, attributes: myAttribute1)
        
        
        // create attributed string
        let myString2 = " and "
        let myAttribute2 = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
        let myAttrString2 = NSAttributedString(string: myString2, attributes: myAttribute2)
        
        
        // create attributed string
        let privacyPolicy = "Privacy Policy"
        let myAttribute3 = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
        privacyPolicyString = NSAttributedString(string: privacyPolicy, attributes: myAttribute3)
        
        // set attributed text on a UILabel
        let conString = NSMutableAttributedString()
        conString.append(myAttrString)
        conString.append(myAttrString1)
        conString.append(myAttrString2)
        conString.append(privacyPolicyString)
        
        agreementLabel.attributedText = conString
        
        
    }
    
    
    @IBAction func bSignUpPressed(_ sender: Any) {
        
        print("sign up here view")
        
        if(tfEmail.text == ""){
            lRequireEmail.isHidden = false
            lRequireEmail.text = "This field is required"
        } else if(!emailMatches(email: tfEmail.text!)){
            lRequireEmail.isHidden = false
            lRequireEmail.text = "Email address is not valid"
        } else {
            lRequireEmail.isHidden = true
        }
        
        if(tfPassword.text == ""){
            lRequirePassword.isHidden = false
            lRequirePassword.text = "This field is required"
        } else if (!matches(password: tfPassword.text!)) {
            lRequirePassword.isHidden = false
            lRequirePassword.text = "Minimum 8 chars, at least one uppercase, one lowercase, and one number"
        } else {
            lRequirePassword.isHidden = true
            lRequirePassword.text = "This field is required"
        }
        
        if(tfConfirmPassword.text == "") {
            lRequireConfirmPassword.isHidden = false
            lRequireConfirmPassword.text = "This field is required"
        } else if (tfPassword.text != tfConfirmPassword.text) {
            lRequireConfirmPassword.isHidden = false
            lRequireConfirmPassword.text = "This password is not match"
        } else {
            lRequireConfirmPassword.isHidden = true
        }
        
        if (lRequireEmail.isHidden == true && lRequirePassword.isHidden == true && lRequireConfirmPassword.isHidden == true) {
                self.delegate?.signUp(email: tfEmail.text!, password: tfPassword.text!)
        } else {
            print("something wrong")
        }
    }
    
    @objc func onSignInFacebookPressed(_ sender: UITapGestureRecognizer){
        self.delegate?.signInFacebook()
    }
    
    @objc func onAgreementPressed(gesture: UITapGestureRecognizer){
        let text = (agreementLabel.text)!
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: agreementLabel, inRange: termsRange) {
            delegate?.onUserAgreementPressed()
        } else if gesture.didTapAttributedTextInLabel(label: agreementLabel, inRange: privacyRange) {
            delegate?.onPolicyPressed()
        } else {
            print("Tapped none")
        }
    }
    
    @objc func onSignInGooglePressed(_ sender: UITapGestureRecognizer){
        self.delegate?.signInGoogle()
    }
    
    @objc func onAuthorizationAppleIDButtonPressed() {
        self.delegate?.signInApple()
    }
    
    @objc func bExploreAppPressed(_ sender: UITapGestureRecognizer) {
        self.delegate?.exploreAppPressed()
    }
    
    @IBAction func backButtonPressed() {
        self.delegate?.backButtonPressed()
    }
    
    func matches(password: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d@_\\-$!%*#?&]{8,}$"
        return password.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func emailMatches(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return email.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
