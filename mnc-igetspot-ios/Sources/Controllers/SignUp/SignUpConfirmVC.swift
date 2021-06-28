//
//  SignUpConfirmVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/15/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol SignUpConfirmVCDelegate {
    func hideConfirmVCPanel()
}

class SignUpConfirmVC: MKViewController {
    
    var signUpConfirmPage: SignUpConfirmPage!
    
    var delegate : SignUpConfirmVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    
    func addView() {
        signUpConfirmPage = UINib(nibName: "SignUpConfirmPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? SignUpConfirmPage
        signUpConfirmPage.delegate = self
        
        self.view.addSubview(signUpConfirmPage)
        signUpConfirmPage.snp.makeConstraints { (make) in
            make.bottom.top.left.right.equalTo(self.view)
        }
    }
    
}


extension SignUpConfirmVC : SignUpConfirmPageDelegate {
    func didHidePressed(){
        self.delegate?.hideConfirmVCPanel()
    }
}
