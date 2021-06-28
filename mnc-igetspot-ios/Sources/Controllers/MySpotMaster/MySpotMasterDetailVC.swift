////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import MXParallaxHeader
import Parchment

class MySpotMasterDetailVC: MKViewController {

    var headerView : MySpotMasterDetailHeaderView!
    var balanceOrderView : MySpotMasterInfoView!
    var pagingViewController: FixedPagingViewController!
    var viewControllers: [UIViewController]!
    var scrollView : MXScrollView!
    var mPresenter = MySpotMasterDetailPresenter()
    var ratingDetail:RatingDetail?
    var parallaxHeaderHeight:CGFloat = 140
    var masterDetail:MySpotMasterDetail?
    var loadingIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleRequestWithdrawalSuccesNotification), name:NSNotification.Name(kRequestWithdrawalSuccesNotificationName), object: nil)
        adjustLayout()
        setupNavigationBar()
        addViews()
        setupConstraints()
        mPresenter.attachview(self)
        getMySpotDetail()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                   self.pagingViewController.reloadMenu()
                   self.pagingViewController.select(index: 0)
               }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func tryAgainButtonDidClicked() {
        super.tryAgainButtonDidClicked()
        getMySpotDetail()
    }
    
    override func setupNavigationBar() {
        setupNavigationBarTitle(NSLocalizedString("MySpot", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .hamburgerMenu)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    // MARK: - Private Methods
    private func addViews(){
        // Header Image
        headerView = MySpotMasterDetailHeaderView()
        
        // Header Panel
        balanceOrderView = MySpotMasterInfoView()
        balanceOrderView.setupTitleLabel(leftTitle: NSLocalizedString("Balance", comment: ""), rightTitle: NSLocalizedString("Order Request", comment: ""))
        balanceOrderView.delegate = self
        
        scrollView = MXScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.parallaxHeader.view = headerView
        parallaxHeaderHeight = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? parallaxHeaderHeight - 20 : parallaxHeaderHeight
        scrollView.parallaxHeader.height = parallaxHeaderHeight
        scrollView.parallaxHeader.mode = .fill
        view.addSubview(scrollView)
        
        scrollView.addSubview(balanceOrderView)
        
        loadingIndicatorView = UIActivityIndicatorView(style: .gray)
        loadingIndicatorView.hidesWhenStopped = true
        scrollView.addSubview(loadingIndicatorView)
        
        setupPagerViews()
    }
    
    private func setupPagerViews() {
        let masterDetailAboutTVC = MySpotMasterAboutTVC(title:NSLocalizedString("About", comment: ""))
        
        let masterDetailPackageTVC = MySpotMasterPackageTVC(title:NSLocalizedString("Package", comment: ""))
        masterDetailPackageTVC.delegate = self
        
        let masterDetailReviewTVC = MySpotMasterReviewTVC(title:NSLocalizedString("Review", comment: ""))
        
        viewControllers = [masterDetailAboutTVC, masterDetailPackageTVC, masterDetailReviewTVC]
        pagingViewController = FixedPagingViewController(viewControllers: viewControllers)
        pagingViewController.dataSource = self
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
            make.left.right.bottom.top.equalTo(view)
        }
        
        balanceOrderView.snp.makeConstraints { (make) in
            make.left.right.equalTo(scrollView)
            make.width.equalToSuperview()
            make.bottom.equalTo(pagingViewController.view.snp.top)
        }
        
        loadingIndicatorView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo((balanceOrderView.snp.bottom)).offset(20)
        }
        
        balanceOrderView.layoutIfNeeded()
        let balanceOrderViewHeight = balanceOrderView.frame.height
        pagingViewController.view.snp.makeConstraints{ (make) in
            make.left.right.bottom.equalTo(scrollView)
            make.top.equalTo((scrollView.parallaxHeader.view?.snp.bottom)!).offset(balanceOrderViewHeight)
            make.height.equalTo(self.view.frame.height - self.scrollView.frame.height - self.topbarHeight - balanceOrderViewHeight - self.tabbarHeight)
        }
    }
    
    @objc func handleRequestWithdrawalSuccesNotification() {
        getMySpotDetail()
    }
    
    // MARK: - Public Functions
    func getMySpotDetail() {
        guard let masterId = TokenManager.shared.getUserId() else {
            return
        }
        mPresenter.getMasterDetail(forMasterId: masterId)
    }
    
}

// MARK: - MySpotMasterDetailView
extension MySpotMasterDetailVC: MySpotMasterDetailView {
    func setContent(mySpotMasterDetail: MySpotMasterDetail) {
        self.masterDetail = mySpotMasterDetail
        headerView.setContent(mySpotMasterDetail: mySpotMasterDetail)
        let balance = "\(mySpotMasterDetail.masterBalance)".currency
        let orderRequest = "\(mySpotMasterDetail.masterOrderRequest)"
        balanceOrderView.setupValueLabele(leftValue: balance, rightValue: orderRequest)
    }
    
    func showLoadingView() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        balanceOrderView.alpha = 0.0
        pagingViewController.collectionView.alpha = 0.0
        loadingIndicatorView.startAnimating()
    }
    
    func hideLoadingView() {
        UIApplication.shared.endIgnoringInteractionEvents()
        balanceOrderView.alpha = 1.0
        pagingViewController.collectionView.alpha = 1.0
        loadingIndicatorView.stop()
    }
    
    func showEmptyView() {
        showErrorView()
    }
}

// MARK: - MySpotMasterInfoViewDelegate
extension MySpotMasterDetailVC: MySpotMasterInfoViewDelegate {
    func leftViewDidTapped() {
        let mySpotBalanceTVC = MySpotBalanceTVC()
        mySpotBalanceTVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mySpotBalanceTVC, animated: true)
    }
    
    func rightViewDidTapped() {
        let mySpotRequestOrderPagerVC = MySpotRequestOrderPagerVC()
        mySpotRequestOrderPagerVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mySpotRequestOrderPagerVC, animated: true)
    }
}

// MARK: - PagingViewControllerDataSource
extension MySpotMasterDetailVC: PagingViewControllerDataSource {
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

// MARK: - MySpotMasterAboutTVCDelegate
extension MySpotMasterDetailVC: MySpotMasterAboutTVCDelegate {
    func showEditPage(contentString: String) {
        
    }
}

// MARK: - MySpotMasterPackageTVCDelegate
extension MySpotMasterDetailVC: MySpotMasterPackageTVCDelegate {
    func packageDidPressed(package: MySpotPackage) {
        let mySpotEditPackageDetailVC = MySpotEditPackageDetailVC()
        mySpotEditPackageDetailVC.packageId = package.id
        mySpotEditPackageDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mySpotEditPackageDetailVC, animated: true)
    }
}
