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
import FloatingPanel

class SettingsVC : MKViewController {
    
    var settingPage: SettingPage!
    var currencyPanelVC : FloatingPanelController!
    var emptyLoadingView = EmptyLoadingView()
    var presenter = SettingPresenter()
    
    // MARK:-  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustLayout()
        setupNavigationBar()
        addViews()
        presenter.attachview(self)
        presenter.initCurrency()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.presentIGSNavigationBar()
    }
    
   
    override func setupNavigationBar() {
        setupNavigationBarTitle(NSLocalizedString("Setting", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    
    func addViews() {
        settingPage  = UINib(nibName: "SettingPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SettingPage
        view.addSubview(settingPage)
        settingPage.delegate = self
        settingPage.snp.makeConstraints{ (make) in
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
    
    func showCurrency(){
        currencyPanelVC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        currencyPanelVC?.surfaceView.cornerRadius = 8.0
        currencyPanelVC?.surfaceView.shadowHidden = false
        currencyPanelVC?.isRemovalInteractionEnabled = true
        currencyPanelVC?.delegate = self
        
        let currencyVC = CurrencyVC()
        currencyVC.delegate = self
        currencyPanelVC?.set(contentViewController: currencyVC)
        
        self.present(currencyPanelVC!, animated: true, completion: nil)
    }
}

extension SettingsVC : FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return IntrinsicPanelLayout()
    }
}

extension SettingsVC : SettingPageDelegate{
    func didCurrencyViewPresed(){
        self.showCurrency()
    }
}

extension SettingsVC : CurrencyVCDelegate {
    
    func onSelected(currency: String){
        settingPage.setCurrency(currency: currency)
        hideThisPanel()
    }
    
    func hideThisPanel() {
        if let currencyPanelVC = self.currencyPanelVC {
            currencyPanelVC.dismiss(animated: true, completion: nil)
        }
    }
}

extension SettingsVC : SettingView {
    func showLoading() {
        //
    }
    
    func hideLoading() {
        //
    }
    
    func setCurrency(currency: CurrencyObject){
        settingPage.setCurrency(currency: currency.currencyName)
    }
}
