//
//  CategoryDetailVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/30/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import MXParallaxHeader
import SwiftMessages
import FloatingPanel
import Parchment

enum CategoryPageContentType {
    case package
    case master
}

class CategoryDetailVC : MKViewController {
    
    var scrollView : MXScrollView!
    var headerView : CategoryDetailParallaxHeader!
    var pagingViewController: FixedPagingViewController!
    var viewControllers: [UIViewController]!
    var tabFilterView : CategoryDetailFilterTab!
    var sortPanelVC: FloatingPanelController?
    var filterPanelVC: FloatingPanelController?
    var categoryDetailPackageTVC : CategoryDetailPackageTVC!
    var categoryDetailMasterTVC : CategoryDetailMasterTVC!
    
    var categoryId:String?
    var categoryName:String?
    var subcategoryId:String?
    var imageParallaxHeight: CGFloat = 185
    let bottomViewHeight: CGFloat = 57
    var categoryPageType:CategoryPageContentType = .package
    var packageCategorySort: CategoryOptionSort?
    var masterCategorySort: CategoryOptionSort?
    var packageFilterParameter:[String:String]?
    var masterFilterParameter:[String:String]?
    var isHeaderHasSet = false
    var searchKeyword = ""
    private let backButton = UIButton(type: .custom)
    
//    let border = UIView()
//    let bgwhite = UIView()
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableSwipeMenuView()
        initSwipeToBack()
        setupNavigationBar()
        initValue()
        addViews()
        setupConstraints()
        setContent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pagingViewController.reloadMenu()
            self.pagingViewController.select(index: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentTransparentNavigationBar()
        setStatusBarStyle(.lightContent)
        scrollViewDidScroll(scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.lt_reset()
        setStatusBarStyle(.default)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.parallaxHeader.minimumHeight = self.topbarHeight
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupSearchBar(withPlaceHolder: NSLocalizedString("I am looking for…", comment: ""))
        setupBarButtonItem()
    }
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = SearchWithTabVC()
        searchVC.categoryId = self.categoryId
        self.navigationController?.push(viewController: searchVC)
        return false
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.searchKeyword = searchText
//        if (self.categoryPageType == .package){
//            categoryDetailPackageTVC.parameters = buildParameters(categoryPageType: .package)
//            categoryDetailPackageTVC.getListPackageWithParameters(parameters: categoryDetailPackageTVC.parameters)
//            self.view.setNeedsLayout()
//            self.view.layoutIfNeeded()
//        } else {
//            categoryDetailMasterTVC.parameters = buildParameters(categoryPageType: .master)
//            categoryDetailMasterTVC.getListMaster(parameters: categoryDetailMasterTVC.parameters)
//            self.view.setNeedsLayout()
//            self.view.layoutIfNeeded()
//        }
//        requestResult(text: searchText)
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
    
    private func addViews(){
        
        headerView = UINib(nibName: "CategoryDetailParallaxHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CategoryDetailParallaxHeader
        
        scrollView = MXScrollView()
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        imageParallaxHeight = UIDevice.current.hasTopNotch ? imageParallaxHeight + 44 : imageParallaxHeight
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = imageParallaxHeight
        scrollView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.view.addSubview(scrollView)
        
        setupPagerViews()
        
        tabFilterView = CategoryDetailFilterTab()
        tabFilterView.delegate = self
        self.view.addSubview(tabFilterView)
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
        scrollView.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
    }
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints{ (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(tabFilterView.snp.top)
        }
        
        tabFilterView.snp.makeConstraints{ (make) in
            make.right.left.equalTo(self.view)
            make.bottom.equalTo(self.view.safeArea.bottom)
            make.top.equalTo(scrollView.snp.bottom)
            make.height.equalTo(bottomViewHeight)
        }
        
        let adjustDeviceHasNotch: CGFloat = UIDevice.current.hasTopNotch ? 24 : 0
        pagingViewController.view.snp.makeConstraints{ (make) in
            make.left.right.equalTo(scrollView)
            make.bottom.width.equalToSuperview()
            make.top.equalTo((scrollView.parallaxHeader.view?.snp.bottom)!).offset(0)
            make.height.equalTo(self.view.frame.height - self.scrollView.frame.height - bottomViewHeight - self.topbarHeight - adjustDeviceHasNotch)
        }
    }
    
    private func initValue(){
        packageCategorySort = CategoryOptionSort.buildListSortCategory(forCategory: .package)[0]
        masterCategorySort = CategoryOptionSort.buildListSortCategory(forCategory: .package)[0]
        self.packageFilterParameter = [String:String]()
        self.masterFilterParameter = [String:String]()
        self.packageFilterParameter?[CategoryFilterView.paramKeyRate] = ""
        self.masterFilterParameter?[CategoryFilterView.paramKeyRate] = ""
    }
    
    private func setContent() {
        headerView.setTitle(title: categoryName ?? "")
    }
    
    private func hideSortVC() {
        if let sortPanelVC = self.sortPanelVC {
            sortPanelVC.dismiss(animated: true, completion: nil)
        }
    }
    
    private func hideFilterVC() {
        if let filterPanelVC = self.filterPanelVC {
            filterPanelVC.dismiss(animated: true, completion: nil)
        }
    }
    
    private func getDataWithFilterAndSort(categoryPageType:CategoryPageContentType, parameters:[String:String]?) {
        if viewControllers != nil {
            if categoryPageType == .package {
                if let categoryDetailPackageTVC = viewControllers[0] as? CategoryDetailPackageTVC {
                    categoryDetailPackageTVC.getListPackageWithParameters(parameters: parameters)
                }
            } else {
                if let categoryDetailMasterTVC = viewControllers[1] as? CategoryDetailMasterTVC {
                    categoryDetailMasterTVC.getListMaster(parameters: parameters)
                }

            }
        }
    }
    
    private func buildParameters(categoryPageType:CategoryPageContentType) -> [String:String] {
        var parameters = [String:String]()
        if let categoryId = self.categoryId {
            parameters["categoryID"] = categoryId
        }
        if let subcategoryId = self.subcategoryId {
            parameters["subcategoryid"] = subcategoryId
        }
        if self.searchKeyword != "" {
            parameters["search"] = self.searchKeyword
        }
        
        if categoryPageType == .package {
            if let packageCategorySort = self.packageCategorySort, let key = packageCategorySort.key, let value = packageCategorySort.value {
                parameters[key] = value
            }
            if let packageFilterParameter = self.packageFilterParameter {
                parameters.merge(packageFilterParameter) { (_, second) in second }
            }
        } else {
            if let masterCategorySort = self.masterCategorySort, let key = masterCategorySort.key, let value = masterCategorySort.value {
                parameters[key] = value
            }
            if let masterFilterParameter = self.masterFilterParameter {
                parameters.merge(masterFilterParameter) { (_, second) in second }
            }
        }
        
        return parameters
    }
    
}

extension CategoryDetailVC : CategoryDetailFilterTabDelegate {
    func onSharePressed() {
        
    }
    
    func onFilterPressed() {
        filterPanelVC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        filterPanelVC?.surfaceView.cornerRadius = 8.0
        filterPanelVC?.surfaceView.shadowHidden = false
        filterPanelVC?.isRemovalInteractionEnabled = false
        filterPanelVC?.delegate = self
        
        let contentVC = CategoryFilterVC()
        contentVC.delegate = self
        contentVC.categoryType = categoryPageType
        contentVC.parameters = categoryPageType == .package ? packageFilterParameter : masterFilterParameter
    
        // Set a content view controller
        filterPanelVC?.set(contentViewController: contentVC)
        
        //  Add FloatingPanel to self.view
        self.present(filterPanelVC!, animated: true, completion: nil)

    }
    
    func onSortPressed() {
        sortPanelVC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        sortPanelVC?.surfaceView.cornerRadius = 8.0
        sortPanelVC?.surfaceView.shadowHidden = false
        sortPanelVC?.isRemovalInteractionEnabled = true
        sortPanelVC?.delegate = self
        
        let contentVC = CategorySortVC()
        contentVC.delegate = self
        contentVC.categoryType = categoryPageType
        contentVC.selectedOptionSort = categoryPageType == .package ? packageCategorySort : masterCategorySort
        // Set a content view controller
        sortPanelVC?.set(contentViewController: contentVC)
        
        self.present(sortPanelVC!, animated: true, completion: nil)
    }
    
    func handleSortAndFilter(categoryPageType:CategoryPageContentType) {
        let parameters = buildParameters(categoryPageType: categoryPageType)
        getDataWithFilterAndSort(categoryPageType: categoryPageType, parameters: parameters)
    }
}

// MARK:- MXScrollViewDelegate
extension CategoryDetailVC: MXScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        addBorder()
//        border.backgroundColor = Colors.inputTextGray
//        bgwhite.backgroundColor = .white
//        self.view.addSubview(bgwhite)
//        self.view.addSubview(border)
//        border.translatesAutoresizingMaskIntoConstraints = false
//        if #available(iOS 11.0, *) {
//            let guide = self.view.safeAreaLayoutGuide
//            bgwhite.snp.makeConstraints{ make in
//                make.left.top.right.equalTo(guide)
//                make.height.equalTo(3)
//            }
//            border.snp.makeConstraints { make in
//                make.left.right.equalTo(guide)
//                make.top.equalTo(bgwhite.snp.bottom)
//                make.height.equalTo(0.5)
//            }
//        } else {
//            bgwhite.snp.makeConstraints{ make in
//                make.left.top.right.equalTo(view)
//                make.height.equalTo(3)
//            }
//            border.snp.makeConstraints { make in
//                make.left.right.equalTo(view)
//                make.top.equalTo(bgwhite.snp.bottom)
//                make.height.equalTo(0.5)
//            }
//        }
        
        if (scrollView == self.scrollView) {
            let colorNavBar = UIColor.white
            let navbarChangePoint:CGFloat = -(imageParallaxHeight)
            let offsetY = scrollView.contentOffset.y
            if (offsetY > navbarChangePoint) {
                let alpha = min(1, 1 - ((navbarChangePoint + 64 - offsetY) / 64))
                self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: colorNavBar.withAlphaComponent(alpha))
                if (alpha < 0.5) {
                    setStatusBarStyle(.lightContent)
                    navigationController?.navigationBar.shadowImage = UIImage()
                    backButton.setImage(R.image.backWhite(), for: .normal)
                } else {
                    setStatusBarStyle(.default)
                    navigationController?.navigationBar.shadowImage = UIImage()
                    backButton.setImage(R.image.backBlack(), for: .normal)
                    bgwhite.isHidden = false
                    border.isHidden = false
                }
            } else {
                self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: colorNavBar.withAlphaComponent(0))
                navigationController?.navigationBar.shadowImage = UIImage()
                backButton.setImage(R.image.backWhite(), for: .normal)
                hideBorder()
            }
        }
        
    }
    
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView){
        hideBorder()
    }
}

// MARK:- CategoryDetailMasterTVCDelegate
extension CategoryDetailVC: CategoryDetailMasterTVCDelegate {
    func masterListDidSelect(masterList: MasterList) {
        let masterDetailVC = MasterDetailVC()
        masterDetailVC.masterId = masterList.masterId
        masterDetailVC.masterName = masterList.name
        masterDetailVC.masterProfileImageUrl = masterList.imageUrl
        self.navigationController?.pushViewController(masterDetailVC, animated: true)
    }
}

// MARK:- CategoryDetailPackageTVCDelegate
extension CategoryDetailVC: CategoryDetailPackageTVCDelegate {
    func packageDidSelect(package: Package) {
        let masterPackageDetailVC = MasterDetailPackageDetailVC()
        masterPackageDetailVC.masterId = package.masterId
        masterPackageDetailVC.packageId = package.packageId
        self.navigationController?.pushViewController(masterPackageDetailVC, animated: true)
    }
    
    func setHeaderBackground(imageUrl:String) {
        if isHeaderHasSet == false {
            isHeaderHasSet = true
            headerView.setBackgroundImage(urlString: imageUrl)
        }
    }
}

// MARK:- FloatingPanelControllerDelegate
extension CategoryDetailVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return IntrinsicPanelLayout()
    }
}

// MARK:- CategorySortVCDelegate
extension CategoryDetailVC: CategorySortVCDelegate {
    func closeCategorySortVC() {
        hideSortVC()
    }
    
    func categorySortDidSelect(selectedSort:CategoryOptionSort, categoryType:CategoryPageContentType) {
        hideSortVC()
        if categoryType == .package {
            packageCategorySort = selectedSort
        } else {
            masterCategorySort = selectedSort
        }
        handleSortAndFilter(categoryPageType: categoryType)
    }
}

// MARK: - PagingViewControllerDataSource
extension CategoryDetailVC: PagingViewControllerDataSource {
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
extension CategoryDetailVC: PagingViewControllerDelegate {
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


// MARK:- CategorySortVCDelegate
extension CategoryDetailVC: CategoryFilterVCDelegate {
    func categoryFilterDidApplied(categoryType:CategoryPageContentType, parameters: [String : String]?) {
        hideFilterVC()
        if categoryType == .package {
            packageFilterParameter = parameters
        } else {
            masterFilterParameter = parameters
        }
        handleSortAndFilter(categoryPageType: categoryType)
        
    }
    
    func closeCategoryFilterVC() {
        hideFilterVC()
    }
    
}

class IntrinsicPanelLayout: FloatingPanelIntrinsicLayout { }
