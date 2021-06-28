//
//  PrivacyPolicyVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/18/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class PrivacyPolicyVC: MKViewController {
    
    var mPresenter = PrivacyPolicyPresenter()
    var policyPage : PrivacyPolicyView!
    var emptyLoadingView = EmptyLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        adjustLayout()
        setupNavigationBar()
        self.mPresenter.attachview(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.presentIGSNavigationBar()
        self.mPresenter.getPolicy()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Privacy Policy", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    func addView(){
        policyPage = UINib(nibName: "PrivacyPolicyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? PrivacyPolicyView
        
        self.view.addSubview(policyPage)
        
        policyPage.snp.makeConstraints{ (make) in
            make.top.left.right.bottom.equalTo(self.view)
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

// MARK: - EmptyLoadingViewDelegate
extension PrivacyPolicyVC: EmptyLoadingViewDelegate {
    func errorTryAgainButtonDidClicked() {
        self.mPresenter.getPolicy()
    }
}

extension PrivacyPolicyVC : PrivacyView{
    func showLoading() {
        emptyLoadingView.alpha = 1.0
        emptyLoadingView.showLoadingView()
    }
    
    func hideLoading() {
         emptyLoadingView.alpha = 0.0
    }
    
    func showErrorMessage(_ message: String) {
        emptyLoadingView.setEmptyErrorContent(withMessage: message, buttonTitle: NSLocalizedString("Try Again", comment: ""), forDisplay: .subview)
    }
    
    func setContent(policy : String){
        self.policyPage.setPrivacyPolicy(text: policy)
    }
    
}
