//
//  PaymentInstructionVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 17/07/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class PaymentInstructionVC: MKViewController {
    var webView: WKWebView!
    var emptyLoadingView = EmptyLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addViews()
        loadContent()
    }
    
    override func setupNavigationBar() {
        setupNavigationBarTitle("Payment Instruction")
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

extension PaymentInstructionVC : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoading()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoading()
    }
    
}
