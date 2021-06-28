//
//  SearchWithTabTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 03/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import MXParallaxHeader
import SwiftMessages
import FloatingPanel
import Parchment

class SearchWithTabVC : MKViewController {
    
    var pagingViewController: FixedPagingViewController!
    var viewControllers: [UIViewController]!
    var categoryDetailPackageTVC : CategoryDetailPackageTVC!
    var categoryDetailMasterTVC : CategoryDetailMasterTVC!
    
    var categoryId:String?
    var categoryName:String?
    var searchKeyword = ""
    var categoryPageType:CategoryPageContentType = .package
    private let backButton = UIButton(type: .custom)
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableSwipeMenuView()
        setupNavigationBar()
        hideKeyboardWhenTappedAround()
        if let vc = pagingViewController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                vc.reloadMenu()
                vc.select(index: 0)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.lt_reset()
        setStatusBarStyle(.default)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupSearchBar(withPlaceHolder: NSLocalizedString("I am looking for…", comment: ""))
        setupRightBarButtonItems()
    }
    
    override func setupRightBarButtonItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action:nil, image: nil, width: 0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action:nil, image: nil, width: 0)
        
        let btnSend = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        btnSend.setTitle( "Cancel", for: .normal)
        btnSend.backgroundColor = UIColor.white
        btnSend.setTitleColor(Colors.blueTwo, for: .normal)
        btnSend.titleLabel?.font = R.font.barlowMedium(size: 14)
        btnSend.layer.cornerRadius = 4.0
        btnSend.layer.masksToBounds = true
        btnSend.addTarget(self, action:#selector(handleCancel(sender:)), for: .touchUpInside)
        
        let sendItem = UIBarButtonItem(customView: btnSend)
        self.navigationItem.rightBarButtonItem  = sendItem
    }
    
    @objc func handleCancel(sender: UIButton){
        self.navigationController?.pop()
    }
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setupRightBarButtonItems()
        self.searchKeyword = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.requestResult(_:)), object: searchBar)
        perform(#selector(self.requestResult(_:)), with: searchBar, afterDelay: 1.0)
    }
    
    
    deinit {
        PrintDebug.printDebugGeneral(self, message: "deinit triggered")
    }
    
    // MARK:- Private Functions
    private func setupBarButtonItem() {
        backButton.setImage(R.image.backWhite(), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidClicked), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupPagerViews() {
        categoryDetailPackageTVC = CategoryDetailPackageTVC(title:NSLocalizedString("Package", comment: ""))
        categoryDetailPackageTVC.parameters = buildParameters(categoryPageType: .package)
        categoryDetailPackageTVC.delegate = self
        
        categoryDetailMasterTVC = CategoryDetailMasterTVC(title:NSLocalizedString("Master", comment: ""))
        categoryDetailMasterTVC.parameters = buildParameters(categoryPageType: .master)
        categoryDetailMasterTVC.delegate = self
        
        viewControllers = [categoryDetailPackageTVC, categoryDetailMasterTVC]
        pagingViewController = FixedPagingViewController(viewControllers: viewControllers)
        pagingViewController.dataSource = self
        pagingViewController.delegate = self
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 30, height: 54)
        pagingViewController.borderColor = Colors.tealBlue
        pagingViewController.indicatorColor = .black
        pagingViewController.font = R.font.barlowRegular(size: 14)!
        pagingViewController.textColor = Colors.brownishGrey
        pagingViewController.selectedFont = R.font.barlowMedium(size: 14)!
        pagingViewController.selectedTextColor = UIColor.black
        
        pagingViewController.indicatorOptions = .visible(
            height: 2,
            zIndex: Int.max,
            spacing: UIEdgeInsets.zero,
            insets: UIEdgeInsets.zero
        )
        
        pagingViewController.borderOptions = .visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets.zero
        )
        
        // Make sure you add the PagingViewController as a child view
        // controller and constrain it to the edges of the view.
        addChild(pagingViewController)
        self.view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
    }
    
    private func setupConstraints() {
        pagingViewController.view.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    private func buildParameters(categoryPageType:CategoryPageContentType) -> [String:String] {
        var parameters = [String:String]()
        if let categoryId = self.categoryId {
            parameters["categoryID"] = categoryId
        }
        
        if self.searchKeyword != "" {
            parameters["search"] = self.searchKeyword.lowercased()
        }
        
        return parameters
    }
    
    @objc func requestResult(_ searchBar: UISearchBar){
        if (pagingViewController == nil){
            setupPagerViews()
            setupConstraints()
        }
        if (searchKeyword != ""){
            categoryDetailPackageTVC.parameters = buildParameters(categoryPageType: .package)
            categoryDetailPackageTVC.getListPackageWithParameters(parameters: categoryDetailPackageTVC.parameters)
            
            categoryDetailMasterTVC.parameters = buildParameters(categoryPageType: .master)
            categoryDetailMasterTVC.getListMaster(parameters: categoryDetailMasterTVC.parameters)
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK:- CategoryDetailMasterTVCDelegate
extension SearchWithTabVC: CategoryDetailMasterTVCDelegate {
    func masterListDidSelect(masterList: MasterList) {
        let masterDetailVC = MasterDetailVC()
        masterDetailVC.masterId = masterList.masterId
        masterDetailVC.masterName = masterList.name
        masterDetailVC.masterProfileImageUrl = masterList.imageUrl
        self.navigationController?.pushViewController(masterDetailVC, animated: true)
    }
}

// MARK:- CategoryDetailPackageTVCDelegate
extension SearchWithTabVC: CategoryDetailPackageTVCDelegate {
    func setHeaderBackground(imageUrl: String) {
        //
    }
    
    func packageDidSelect(package: Package) {
        let masterPackageDetailVC = MasterDetailPackageDetailVC()
        masterPackageDetailVC.masterId = package.masterId
        masterPackageDetailVC.packageId = package.packageId
        self.navigationController?.pushViewController(masterPackageDetailVC, animated: true)
    }
}

// MARK: - PagingViewControllerDataSource
extension SearchWithTabVC: PagingViewControllerDataSource {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        return PagingIndexItem(index: index, title: viewControllers[index].title ?? "") as! T
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }
    
    func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int {
        return viewControllers.count
    }
}

// MARK: - PagingViewControllerDelegate
extension SearchWithTabVC: PagingViewControllerDelegate {
    func pagingViewController<T>(
        _ pagingViewController: PagingViewController<T>,
        didScrollToItem pagingItem: T,
        startingViewController: UIViewController?,
        destinationViewController: UIViewController,
        transitionSuccessful: Bool) {
        
        let pagingIndexItem = pagingItem as! PagingIndexItem
        let currentIndex = pagingIndexItem.index
        print("paginIndexItem :\(currentIndex)")
        categoryPageType = currentIndex == 0 ? .package : .master
    }
}
