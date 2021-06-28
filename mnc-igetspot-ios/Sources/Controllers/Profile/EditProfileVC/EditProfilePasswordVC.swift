//
//  EditProfilePasswordVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/13/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//


import UIKit
import SwiftMessages

class EditProfilePasswordVC : MKViewController {
    
    
    var editPasswordPresenter = EditPasswordPresenter()
    let editProfileView = UINib(nibName: R.nib.editProfilePhonePassword.name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditProfilePasswordPage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addView()
        editPasswordPresenter.attachview(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Edit Password", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func showSignInPage(action: UIAlertAction) {
        self.navigationController?.pushViewController(SignInVC(), animated: true)
    }
    
    func addView(){
        self.view.addSubview(editProfileView)
        
        editProfileView.delegate = self
        
        editProfileView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    
    func showSuccess(){
        
        var config = SwiftMessages.Config()
        
        // Slide up from the bottom.
        config.presentationStyle = .bottom
        
        // Display in a window at the specified window level: UIWindow.Level.statusBar
        // displays over the status bar while UIWindow.Level.normal displays under.
        config.presentationContext = .window(windowLevel: .init(100))
        
        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: 4)
        
        // Dim the background like a popover view. Hide when the background is tapped.
        config.dimMode = .gray(interactive: true)
        
        // Disable the interactive pan-to-hide gesture.
        config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        config.eventListeners.append() { event in
            if case .didHide = event { print("Success Update Profile!") }
        }
        
        SwiftMessages.show(config: config, view: view)
    }
    
    func removeSelf(){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func matches(password: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d@_\\-$!%*#?&]{8,}$"
        return password.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension EditProfilePasswordVC : EditProfilePasswordPageDelegate {
    func onUpdatePressed(currentPasword: String, password: String, password2: String) {
        if currentPasword == "" {
            showErrorMessage("Current password is required")
        }
        else if matches(password: password) {
            showLoadingHUD()
            editPasswordPresenter.editProfile(currentPassword: currentPasword, newPassword: password, newPassword2: password2)
        }
        else {
            showErrorMessage("Minimum 8 chars, at least one uppercase, one lowercase, and one number")
        }
    }
}

extension EditProfilePasswordVC : EditPasswordView {
    func showLoading() {
        showLoadingHUD()
    }
    
    func hideLoading() {
        hideLoadingHUD()
    }
    
    func showSuccessMessage(_ message: String) {
        showSuccessMessageBanner(message)
    }
    
    func showErrorMessage(_ message: String) {
        showErrorMessageBanner(message)
    }
}
