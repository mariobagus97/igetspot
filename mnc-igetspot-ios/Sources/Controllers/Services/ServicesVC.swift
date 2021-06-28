//
//  ServicesVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/11/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit

class ServicesVC : MKViewController {
    
    var servicesStack : ServicesStackView!
    var mPresenter = ServicesPresenter()
    var emptyLoadingView = EmptyLoadingView()
    
    // MARK:-  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addView()
        self.mPresenter.attachview(self)
        getAllServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.lt_reset()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupSearchBar(withPlaceHolder: NSLocalizedString("I am looking for...", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = SearchTVC()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.push(viewController: searchVC)
        return false
    }
    
    func getAllServices() {
        self.mPresenter.getServices(limit: 100)
    }
    
    func addView(){
        servicesStack = UINib(nibName: "ServicesStackView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ServicesStackView
        servicesStack.delegate = self
        view.addSubview(servicesStack)

        servicesStack.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self.view)
            make.left.equalTo(self.view).offset(10)
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
    
    // MARK: - Publics Functions
    
    func showEmptyView(withMessage message:String, buttonTitle:String? = nil) {
        emptyLoadingView.alpha = 1.0
        emptyLoadingView.setEmptyErrorContent(withMessage: message, buttonTitle: buttonTitle, forDisplay: .fullpage)
    }
}

// MARK: - EmptyLoadingViewDelegate
extension ServicesVC: EmptyLoadingViewDelegate {
    
    func errorTryAgainButtonDidClicked() {
        getAllServices()
    }
}

extension ServicesVC: SServicesStackViewDelegate {
    func serviceCategoryDidClicked(categoryId: String, categoryName: String, subcategoryId: String, subcategoryName: String) {
        let detailVC = CategoryDetailVC()
        detailVC.categoryId = categoryId
        if(subcategoryId != "" && subcategoryName != ""){
            detailVC.categoryName = subcategoryName
            detailVC.subcategoryId = subcategoryId
        } else {
            detailVC.categoryName = categoryName
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension ServicesVC : ServicesView {
    func showLoading() {
        emptyLoadingView.alpha = 1.0
        emptyLoadingView.showLoadingView()
    }
    
    func hideLoading() {
         emptyLoadingView.alpha = 0.0
    }
    
    func showErrorMessage(_ message: String) {
        //
    }

    func setContent(allServices: [AllServices]){
        servicesStack.setContent(allServices: allServices)
    }
    
    func showEmpty(withMessage message: String, _ buttonTitle: String?) {
        self.showEmptyView(withMessage: message, buttonTitle: buttonTitle)
    }
}
