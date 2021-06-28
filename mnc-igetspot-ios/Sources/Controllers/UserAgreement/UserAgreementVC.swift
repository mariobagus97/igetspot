//
//  UserAgreementVC.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 09/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import UIKit

class UserAgreementVC: MKViewController {
    var mPresenter = UserAgreementPresenter()
    var agreementPage: AgreementPage!
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
        self.mPresenter.getUserAgreement()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("User Agreement", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    func addView(){
        agreementPage = UINib(nibName: "AgreementPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? AgreementPage
        
        self.view.addSubview(agreementPage)
        
        agreementPage.snp.makeConstraints{ (make) in
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
extension UserAgreementVC: EmptyLoadingViewDelegate {
    func errorTryAgainButtonDidClicked() {
        self.mPresenter.getUserAgreement()
    }
}

extension UserAgreementVC: UserAgreementView{
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
    
    func setContent(agreement : String){
        self.agreementPage.setUserAgreement(text: agreement)
    }
    
}
