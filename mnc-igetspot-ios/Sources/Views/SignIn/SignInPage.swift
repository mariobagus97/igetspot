//
//  SignInPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/4/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import AuthenticationServices

protocol SignInProtocol : NSObjectProtocol{
    func signInFacebook()
    func signInGoogle()
    func signInApple()
    func signInEmail(email:String, password:String)
    func signUp()
    func skip()
    func onForgetPressed()
    func closeButtonPressed()
}


class SignInPage : UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var signInEmailView: UIView!
    @IBOutlet weak var signInFacebookView: UIView!
    @IBOutlet weak var SignInGoogleView: UIView!
    @IBOutlet weak var loginProviderStackView: UIStackView!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var requireEmailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var requirePasswordLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var safeAreaTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var superviewTopConstraints: NSLayoutConstraint!
    
    weak var delegate : SignInProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 11.0, *) {
            self.removeConstraint(superviewTopConstraints)
        } else {
            self.removeConstraint(safeAreaTopConstraints)
        }
        
        customViewComponent()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // -- CUSTOM VIEW
    func customViewComponent(){
        
        makeRoundedButton()
        makeGradientButton()
        addGesture()
        
        self.makeTextFieldBlank(textfield: passwordTextField)
        self.makeTextFieldBlank(textfield: usernameTextField)
        
        self.hideLabel(label: requirePasswordLabel)
        self.hideLabel(label: requireEmailLabel)
        
        if #available(iOS 13.0, *) {
            setupProviderLoginView()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func makeRoundedButton() {
        // make button rounded
        signInEmailView.makeItRounded(width:0.0, cornerRadius :signInEmailView.bounds.height / 2)
        signInFacebookView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius :signInFacebookView.bounds.height / 2)
        SignInGoogleView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius : SignInGoogleView.bounds.height / 2)
    }
    
    func makeGradientButton(){
        signInEmailView.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    func addGesture(){
        signInEmailView.isUserInteractionEnabled = true
        signInEmailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignInEmailPressed(_:))))
        
        signInFacebookView.isUserInteractionEnabled = true
        signInFacebookView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignInFacebookPressed(_:))))
        
        SignInGoogleView.isUserInteractionEnabled = true
        SignInGoogleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignInGooglePressed(_:))))
        
    }
    
    /// - Tag: add_appleid_button
    @available(iOS 13.0, *)
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(onAuthorizationAppleIDButtonPressed), for: .touchUpInside)
        authorizationButton.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius : loginProviderStackView.bounds.height / 2)
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    @objc func onSignInEmailPressed(_ sender: UITapGestureRecognizer){
        if (usernameTextField.text == ""){
            self.showLabel(label: requireEmailLabel)
        }
        
        if (passwordTextField.text == ""){
            self.showLabel(label: requirePasswordLabel)
        }
        
        if (usernameTextField.text != "" && passwordTextField.text != ""){
            self.delegate?.signInEmail(email: usernameTextField.text!, password: passwordTextField.text!)
        }
    }
    
    @objc func onSignInFacebookPressed(_ sender: UITapGestureRecognizer){
        self.delegate?.signInFacebook()
    }
    
    
    @objc func onSignInGooglePressed(_ sender: UITapGestureRecognizer){
        self.delegate?.signInGoogle()
    }
    
    @objc func onAuthorizationAppleIDButtonPressed() {
        self.delegate?.signInApple()
    }
    
    func showCloseButton(isHide:Bool) {
        if (isHide) {
            closeButton.alpha = 0.0
        } else {
            closeButton.alpha = 1.0
        }
    }
    
    func showSkipButton(isHide:Bool) {
        if (isHide) {
            skipButton.alpha = 0.0
        } else {
            skipButton.alpha = 1.0
        }
    }
    
    
    // -- END OF CUSTOMIZING VIEW

    // -- ACTION FOR BUTTON
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.delegate?.closeButtonPressed()
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
         self.delegate?.onForgetPressed()
    }
    
    @IBAction func signInEmailPressed(_ sender: Any) {
        if (usernameTextField.text == ""){
            self.showLabel(label: requireEmailLabel)
        }
        
        if (passwordTextField.text == ""){
            self.showLabel(label: requirePasswordLabel)
        }
        
        if (usernameTextField.text != "" && passwordTextField.text != ""){
            self.delegate?.signInEmail(email: usernameTextField.text!, password: passwordTextField.text!)
        }
    }
    
    @IBAction func signInFacebookPressed(_ sender: Any) {
        self.delegate?.signInFacebook()
    }
    
    @IBAction func signInGooglePressed(_ sender: Any) {
        self.delegate?.signInGoogle()
    }
    
    @IBAction func skipPressed(_ sender: Any) {
        self.delegate?.skip()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        self.delegate?.signUp()
    }
    
}
