////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MySpotRegisterTermsConditionVC: MKViewController {
    
    var mySpotTermsView: MySpotRegisterTermsConditionView = {
        let mySpotTermsView = MySpotRegisterTermsConditionView()
        return mySpotTermsView
    }()
    
    var mPresenter = MySpotTermsPresenter()
    var emptyLoadingView = EmptyLoadingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        self.mPresenter.attachview(self)
        setupNavigationBar()
        
        self.mPresenter.getPolicy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.presentIGSNavigationBar()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Agency Master", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    func addViews() {
        mySpotTermsView.delegate = self
        view.addSubview(mySpotTermsView)
        mySpotTermsView.snp.makeConstraints{ (make) in
            make.bottom.top.left.right.equalTo(self.view)
        }
        self.view.layoutIfNeeded()
        self.view.addSubview(emptyLoadingView)
        emptyLoadingView.delegate = self
        emptyLoadingView.alpha = 0.0
        emptyLoadingView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(self.view.frame.height - self.topbarHeight)
        }
//        mySpotTermsView.setContent(text: <#String#>)
    }
    
    func setContent(text : String){
        addViews()
        mySpotTermsView.setContent(text: text)
    }
    
    func showTermsErrorView(message: String) {
        emptyLoadingView.setEmptyErrorContent(withMessage: message, buttonTitle: NSLocalizedString("Try Again", comment: ""), forDisplay: .subview)
    }
    
    // MARK: - Publics Functions
    func showTermsLoadingView() {
        emptyLoadingView.alpha = 1.0
        emptyLoadingView.showLoadingView()
    }
    
    func hideTermsLoadingView() {
        emptyLoadingView.alpha = 0.0
    }
}

extension MySpotRegisterTermsConditionVC: MySpotRegisterTermsConditionViewDelegate {
    func continueButtonDidClicked() {
        let tellUsMore = MySpotTellUsMore()
        tellUsMore.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(tellUsMore, animated: true)

    }
}

// MARK: - EmptyLoadingViewDelegate
extension MySpotRegisterTermsConditionVC: EmptyLoadingViewDelegate {
    func errorTryAgainButtonDidClicked() {
        self.mPresenter.getPolicy()
    }
}
