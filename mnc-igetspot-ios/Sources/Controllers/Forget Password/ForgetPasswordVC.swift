//
//  ForgetPasswordVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/21/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class ForgetPasswordVC: MKViewController {
    
    var forgetPasswordView : ForgetPasswordView!
    var mPresenter = ForgetPasswordPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mPresenter.attachview(self)
        addView()
    }
    
    func addView(){
        
        forgetPasswordView = (UINib(nibName: "ForgetPasswordView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ForgetPasswordView)
        
        forgetPasswordView.delegate = self
        
        self.view.addSubview(forgetPasswordView)
        
        forgetPasswordView.snp.makeConstraints{ (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }

}


extension ForgetPasswordVC : ForgetPasswordViewDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func onForgetPressed(email: String){
        self.mPresenter.sendForgetPassword(email: email)
    }
}

extension ForgetPasswordVC : ForgetPasswordPresenterView {
    func showLoading() {
        showLoadingHUD()
    }
    
    func hideLoading() {
        hideLoadingHUD()
    }
    
    func showErrorMessage(_ message: String) {
        showErrorMessageBanner(message)
    }
    
    func showSuccessMessage(_ message: String) {
        showSuccessMessageBanner(message)
    }
}
