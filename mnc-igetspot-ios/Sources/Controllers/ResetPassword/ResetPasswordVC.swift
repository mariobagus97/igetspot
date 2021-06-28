//
//  ResetPasswordVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 23/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordVC: MKViewController {
    
    var presenter = ResetPasswordPresenter()
    var emptyLoadingView = EmptyLoadingView()
    var resetPage : ResetPasswordPage!
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachview(self)
        presenter.handlingLoginUser()
        setupNavigationBar()
        addView()
    }
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func addView(){
        resetPage = UINib(nibName: "ResetPasswordPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ResetPasswordPage
        resetPage.delegate = self
        view.addSubview(resetPage)
        
        resetPage.snp.makeConstraints { (make) in
            make.right.top.bottom.left.equalTo(self.view)
        }
        
        self.view.layoutIfNeeded()
        self.view.addSubview(emptyLoadingView)
        emptyLoadingView.delegate = self
        emptyLoadingView.alpha = 0.0
        emptyLoadingView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(self.view.frame.height - self.topbarHeight)
        }
    }
}

extension ResetPasswordVC : ResetPasswordPageDelegate {
    func changePassword(password: String, confirmpassword: String){
        presenter.resetPassword(password: password, confirmPassword: confirmpassword, token: self.token)
    }
}

extension ResetPasswordVC : EmptyLoadingViewDelegate {
    func errorTryAgainButtonDidClicked() {
        //
    }
    
}

extension ResetPasswordVC : ResetPasswordView {
    
    func moveToHome(){
        self.navigationController?.push(viewController: PortalVC())
    }
    
    func moveVC() {
        showSuccessMessageBanner("Success update your password")
        self.navigationController?.push(viewController: SignInVC())
    }
    
    func showLoading() {
        emptyLoadingView.alpha = 1.0
        emptyLoadingView.showLoadingView()
    }
    
    func hideLoading() {
        emptyLoadingView.alpha = 0.0
    }
    
    
    func showLoadingProcess(){
        showLoadingHUD()
    }
    
    func hideLoadingProcess(){
        hideLoadingHUD()
    }
    
    
    func showErrorMessage(_ message: String) {
        showErrorMessageBanner(message)
    }
}
