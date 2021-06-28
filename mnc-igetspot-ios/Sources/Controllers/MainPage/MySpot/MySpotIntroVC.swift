//
//  MySpotIntroVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/29/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class MySpotIntroVC : MKViewController {
    
    let spotIntroView = UINib(nibName: "MySpotIntro", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MySpotIntro
    let scrollView = UIScrollView()
    let wrapper = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addView() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.presentIGSNavigationBar()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Agency Master", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .hamburgerMenu)
    }
    
    func addView(){
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(wrapper)
        wrapper.addSubview(spotIntroView)
        
        spotIntroView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        wrapper.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
            // only vertical scroll
            make.width.equalToSuperview()
            
            // only horizontal scroll
            //make.height.equalToSuperview()
        }
        spotIntroView.delegate = self
    }
}

extension MySpotIntroVC : MySpotIntroDelegate {
    func officialSpotMasterDidClicked() {
        
    }
    
    func joinButtonDidClicked() {
        if (TokenManager.shared.isLogin()){
            let termsConditionVC = MySpotRegisterTermsConditionVC()
            termsConditionVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(termsConditionVC, animated: true)
        } else {
            self.goToLoginScreen(afterLoginScreenType: .mySpotRegistration, afterLoginParameter: nil)
        }
    }
}
