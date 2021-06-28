//
//  HelpCenterVc.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/15/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class HelpCenterVC : MKViewController{
    var webView: WKWebView!
    var emptyLoadingView = EmptyLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addViews()
        loadContent()
    }
    
    override func setupNavigationBar() {
        setupNavigationBarTitle("Help Center")
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    func addViews() {
        let webConfiguration = WKWebViewConfiguration()
        let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 0.0, height: self.view.frame.size.height))
        self.webView = WKWebView (frame: customFrame , configuration: webConfiguration)
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        webView.snp.makeConstraints{ (make) in
            make.bottom.top.left.right.equalTo(self.view)
        }
        
        self.view.addSubview(emptyLoadingView)
        showLoading()
        emptyLoadingView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(self.view.frame.height - self.topbarHeight)
        }
    }
    
    func loadContent(){
        let myURL = URL(string: IGSEnv.IGetSpotFAQUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func showLoading() {
        emptyLoadingView.alpha = 1.0
        emptyLoadingView.showLoadingView()
    }
    
    func hideLoading() {
        emptyLoadingView.alpha = 0.0
    }
    
}

extension HelpCenterVC : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoading()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoading()
    }
    
}

//class HelpCenterVC : MKViewController {
//
//    var helpCenterPage: HelpCenterPage!
//
//    var emptyLoadingView = EmptyLoadingView()
//    var contactUsVC : FloatingPanelController!
//
//    // MARK:-  Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupNavigationBar()
//        addViews()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.presentIGSNavigationBar()
//    }
//
//    override func setupNavigationBar() {
//        setupSearchBar(withPlaceHolder: NSLocalizedString("I want to know about", comment: ""))
//        setupLeftBackBarButtonItems(barButtonType: .backButton)
//    }
//
//    func addViews() {
//        helpCenterPage  = UINib(nibName: "HelpCenterPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HelpCenterPage
//        helpCenterPage.delegate = self
//        view.addSubview(helpCenterPage)
//        helpCenterPage.snp.makeConstraints{ (make) in
//            make.bottom.top.left.right.equalTo(self.view)
//        }
//        //        helpCenterPage.setContent()
//    }
//
//    func showContactUs(){
//        contactUsVC = FloatingPanelController()
//
//        // Initialize FloatingPanelController and add the view
//        contactUsVC?.surfaceView.cornerRadius = 8.0
//        contactUsVC?.surfaceView.shadowHidden = false
//        contactUsVC?.isRemovalInteractionEnabled = true
////        contactUsVC?.delegate = self
//
//        let contactVC = ContactUsVC()
//        //        moreVC.delegate = self
//        contactUsVC?.set(contentViewController: contactVC)
//
//
//        self.present(contactUsVC!, animated: true, completion: nil)
//
//        // Instantiate MessageView from a named nib.
//        //        let contactUs: ContactUsPage = try! SwiftMessages.viewFromNib(named: "ContactUsPage")
//        //
//        //        contactUs.setSize(height: self.view.frame.size.height-20, width: self.view.frame.size.width-20)
//        //
//        //        SwiftMessages.defaultConfig.presentationStyle = .bottom
//        //        SwiftMessages.defaultConfig.duration = .forever
//        //        SwiftMessages.defaultConfig.dimMode = .color(color: UIColor(red: 0, green: 0, blue:0, alpha: 0.75), interactive: true)
//        //        // Show message with default config.
//        //        SwiftMessages.show(view: contactUs)
//    }
//
//    private func hideContactUs() {
//        if let contactUsVC = self.contactUsVC {
//            contactUsVC.dismiss(animated: true, completion: nil)
//        }
//    }
//}
//
//extension HelpCenterVC : HelpCenterPageDelegate {
//
//    func onContactUsPressed(){
//        self.showContactUs()
//    }
//}
