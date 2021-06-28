//
//  AboutVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/4/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SafariServices

class AboutVC: MKViewController {

    var aboutPage : AboutPage!
    var mPresenter = AboutPresenter()
    var emptyLoadingView = EmptyLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mPresenter.attachview(self)
        addView()
        adjustLayout()
        setupNavigationBar()
        mPresenter.getAbouttext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.presentIGSNavigationBar()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("About i Get Spot", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    func addView(){
        aboutPage = UINib(nibName: "AboutPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? AboutPage
        aboutPage.delegate = self
        self.view.addSubview(aboutPage)
        
        aboutPage.snp.makeConstraints{ (make) in
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
extension AboutVC: EmptyLoadingViewDelegate {
    func errorTryAgainButtonDidClicked() {
        mPresenter.getAbouttext()
    }
}

extension AboutVC : AboutView {
    func showLoading() {
        emptyLoadingView.alpha = 1.0
        emptyLoadingView.showLoadingView()
    }
    
    func hideLoading() {
        emptyLoadingView.alpha = 0.0
    }
    
    func setAbout(text: String){
        print("about in vc : \(text)")
        self.aboutPage.setAboutText(text: text)
    }
    
    func showErrorMessage(_ message: String) {
        emptyLoadingView.setEmptyErrorContent(withMessage: message, buttonTitle: NSLocalizedString("Try Again", comment: ""), forDisplay: .subview)
    }
    
}

extension AboutVC : AboutPageDelegate {
    func openIg() {
        let appScheme = "\(URLConstants.socmedname.instagram)://user?username=igetspot"
        openApp(gotoUrl: URLConstants.socmed.instagram, appScheme: appScheme)
    }
    
    func openTwitter() {
        let appScheme = "\(URLConstants.socmedname.twitter)://user?screen_name=igetspot"
        openApp(gotoUrl: URLConstants.socmed.twitter, appScheme: appScheme)
    }

    func openFB(){
        let appScheme = "\(URLConstants.socmedname.facebook)://page?id=2046644008760106"
        openApp(gotoUrl: URLConstants.socmed.facebook, appScheme: appScheme)
    }
}
