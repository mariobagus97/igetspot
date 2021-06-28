//
//  ContactUsVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/18/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol ContactUsVCDelegate:class {
    func onCloseContactPressed()
}

class ContactUsVC: MKViewController {
    var contactUs: ContactUsPage!
    var emptyLoadingView = EmptyLoadingView()
    weak var delegate : ContactUsVCDelegate!
    
    
    // MARK:-  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.presentIGSNavigationBar()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupNavigationBar() {
        setupSearchBar(withPlaceHolder: NSLocalizedString("I want to know about", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    func addViews() {
        contactUs  = UINib(nibName: "ContactUsPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ContactUsPage
        contactUs.delegate = self
        view.addSubview(contactUs)
        contactUs.snp.makeConstraints{ (make) in
            make.bottom.top.left.right.equalTo(self.view)
        }
        //        helpCenterPage.setContent()
    }
    
    
}

extension ContactUsVC : ContactUsPageDelegate {
    func closeContactUs(){
        delegate?.onCloseContactPressed()
    }
}
