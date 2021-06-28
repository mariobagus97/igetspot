//
//  EditProfilePhoneVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/12/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

class EditProfilePhoneVC : MKViewController {
    
    var editPhonePresenter = EditPhonePresenter()
    let editProfileView = UINib(nibName: R.nib.editProfilePhoneView.name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditProfilePhonePage
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        addView()
        editPhonePresenter.attachview(self)
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
        setupNavigationBarTitle(NSLocalizedString("Edit Phone", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func showSignInPage(action: UIAlertAction) {
        self.navigationController?.pushViewController(SignInVC(), animated: true)
    }
    
    
    func addView() {
        self.view.addSubview(editProfileView)
        editProfileView.delegate = self
        editProfileView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    func setEditProfileData(currentPhone: String){
      editProfileView.showData(currentPhone: currentPhone)
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
    
    func hideAlert() {
        dismiss(animated: true, completion: nil)
    }
    
    func removeSelf(){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
}

extension EditProfilePhoneVC : EditProfilePhonePageDelegate {
    func onUpdatePressed(currentPhone: String, newPhone: String, passwordLogin: String) {
        editPhonePresenter.editProfile(currentPhone: currentPhone, newPhone: newPhone, password: passwordLogin)
    }
    
}

extension EditProfilePhoneVC : EditPhoneView {
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
