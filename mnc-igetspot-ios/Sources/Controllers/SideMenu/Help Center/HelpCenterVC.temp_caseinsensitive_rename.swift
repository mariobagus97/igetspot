//
//  HelpCenterVc.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/15/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit
import SwiftMessages

class HelpCenterVc : MKViewController {
    
    var helpCenterPage: HelpCenterPage!
    
    var emptyLoadingView = EmptyLoadingView()
    
    // MARK:-  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.presentIGSNavigationBar()
    }
    
    override func setupNavigationBar() {
        setupSearchBar(withPlaceHolder: NSLocalizedString("I want to know about", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    func addViews() {
        helpCenterPage  = UINib(nibName: "HelpCenterPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HelpCenterPage
        helpCenterPage.delegate = self
        view.addSubview(helpCenterPage)
        helpCenterPage.snp.makeConstraints{ (make) in
            make.bottom.top.left.right.equalTo(self.view)
        }
//        helpCenterPage.setContent()
    }
    
    func showContactUs(){
        // Instantiate MessageView from a named nib.
        let contactUs: ContactUsPage = try! SwiftMessages.viewFromNib(named: "ContactUsPage")
        
        contactUs.setSize(height: self.view.frame.size.height-20, width: self.view.frame.size.width-20)
        
        SwiftMessages.defaultConfig.presentationStyle = .bottom
        SwiftMessages.defaultConfig.duration = .forever
        SwiftMessages.defaultConfig.dimMode = .color(color: UIColor(red: 0, green: 0, blue:0, alpha: 0.75), interactive: true)
        // Show message with default config.
        SwiftMessages.show(view: contactUs)
    }
}

extension HelpCenterVc : HelpCenterPageDelegate {
    
    func onContactUsPressed(){
        self.showContactUs()
    }
}
