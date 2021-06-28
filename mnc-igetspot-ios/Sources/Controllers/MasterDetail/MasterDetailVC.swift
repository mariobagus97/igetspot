//
//  MasterDetailVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/13/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import MXParallaxHeader
import Parchment

class MasterDetailVC : MKViewController {
    
    var imageHeaderView : MasterDetailImageHeaderView!
    var headerPanelView : MasterDetailPanelHeaderView!
    var pagingViewController: FixedPagingViewController!
    var viewControllers: [UIViewController]!
    var scrollView : MXScrollView!
    var mPresenter = MasterDetailProfilePresenter()
    var masterId: String?
    var masterName: String?
    var masterProfileImageUrl: String?
    var parallaxHeaderHeight:CGFloat = 140
    var masterDetail:MasterDetail?
    var isFavorite = false
    var loadingIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        adjustLayout()
        setupNavigationBar()
        addViews()
        setMaster()
        setupConstraints()
        mPresenter.attachview(self)
        getMasterDetail()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                   self.pagingViewController.reloadMenu()
                   self.pagingViewController.select(index: 0)
               }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func tryAgainButtonDidClicked() {
        super.tryAgainButtonDidClicked()
        getMasterDetail()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupSearchBar(withPlaceHolder: NSLocalizedString("Browse for package or master", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = SearchTVC()
        searchVC.hidesBottomBarWhenPushed = true
        searchVC.fromMasterDetail = true
        searchVC.masterId = self.masterId ?? ""
        navigationController?.push(viewController: searchVC)
        return false
    }
    
    // MARK: - Actions
    
    // MARK: - Private Methods
    private func setMaster() {
        if let masterName = self.masterName {
            headerPanelView.setMasterName(masterName)
        }
        
        if let masterImageUrl = self.masterProfileImageUrl {
            imageHeaderView.setImage(imageUrl: masterImageUrl)
        }
    }
    
    private func addViews(){
        // Header Image
        imageHeaderView = MasterDetailImageHeaderView()
        imageHeaderView.wishlistButton.alpha = 0.0
        
        // Header Panel
        headerPanelView = MasterDetailPanelHeaderView()
        headerPanelView.delegate = self
        
        scrollView = MXScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.parallaxHeader.view = imageHeaderView
        parallaxHeaderHeight = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? parallaxHeaderHeight - 20 : parallaxHeaderHeight
        scrollView.parallaxHeader.height = parallaxHeaderHeight
        scrollView.parallaxHeader.mode = .fill
        view.addSubview(scrollView)
        
        scrollView.addSubview(headerPanelView)
        
        loadingIndicatorView = UIActivityIndicatorView(style: .gray)
        loadingIndicatorView.hidesWhenStopped = true
        scrollView.addSubview(loadingIndicatorView)
        
        // Content View
        setupPagerViews()
    }
    
    private func setupPagerViews() {
        let masterDetailAboutTVC = MasterDetailAboutTVC(title:NSLocalizedString("About", comment: ""))
        masterDetailAboutTVC.masterId = masterId
        
        let masterDetailPackageTVC = MasterDetailPackageTVC(title:NSLocalizedString("Package", comment: ""))
        masterDetailPackageTVC.masterId = masterId
        masterDetailPackageTVC.delegate = self
        
        let masterDetailReviewTVC = MasterDetailReviewTVC(title:NSLocalizedString("Review", comment: ""))
        masterDetailReviewTVC.masterId = masterId
        
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
        
        headerPanelView.snp.makeConstraints { (make) in
            make.left.right.equalTo(scrollView)
            make.width.equalToSuperview()
            make.top.equalTo((scrollView.parallaxHeader.view?.snp.bottom)!).offset(0)
            make.bottom.equalTo(pagingViewController.view.snp.top)
        }
        
        loadingIndicatorView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo((headerPanelView.snp.bottom)).offset(20)
        }
        
        headerPanelView.layoutIfNeeded()
        let headerPanelHeight = headerPanelView.frame.height > 0 ? headerPanelView.frame.height : 80
        pagingViewController.view.snp.makeConstraints{ (make) in
            make.left.right.equalTo(scrollView)
            make.bottom.equalToSuperview()
            make.top.equalTo(headerPanelView.snp.bottom)
            make.height.equalTo(self.view.frame.height - self.scrollView.frame.height - self.topbarHeight - headerPanelHeight)
        }
    }
    
    // MARK: - Public Functions
    func getMasterDetail() {
        guard let masterId = self.masterId else {
            self.showErrorView()
            return
        }
        mPresenter.getMasterDetail(forMasterId: masterId)
    }
}

// MARK: - MasterDetailView
extension MasterDetailVC: MasterDetailView {
    func setContent(masterDetail: MasterDetail) {
        self.masterDetail = masterDetail
        isFavorite = masterDetail.isFavorite
        headerPanelView.setContent(masterDetail:masterDetail)
        if let masterDetailAboutTVC = viewControllers[0] as? MasterDetailAboutTVC  {
            if let about = masterDetail.about, about.isEmptyOrWhitespace() == false {
                masterDetailAboutTVC.setContentMasterDescription(about)
            }
        }
    }
    
    func showLoadingView() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        headerPanelView.alpha = 0.0
        pagingViewController.collectionView.alpha = 0.0
        loadingIndicatorView.startAnimating()
    }
    
    func hideLoadingView() {
        UIApplication.shared.endIgnoringInteractionEvents()
        headerPanelView.alpha = 1.0
        pagingViewController.collectionView.alpha = 1.0
        loadingIndicatorView.stop()
    }
    
    func showEmptyView() {
        showErrorView()
    }
    
    func setFavorite(isFavorite:Bool) {
        self.isFavorite = isFavorite
        headerPanelView.setFavorite(isFavorite: self.isFavorite)
    }
    
    func setLoadingFavoriteButton(isLoading:Bool) {
        headerPanelView.loadingFavoriteButton(isLoading: isLoading)
    }
    
    func showMasterDetailLoadingHUD() {
        showLoadingHUD()
    }
    
    func hideMasterDetailLoadingHUD() {
        hideLoadingHUD()
    }
    
    func showMessageError(message:String) {
        showErrorMessageBanner(message)
    }
    
    func goToChatRoom(channelUrl:String, opponentId:String, profileImageUrl:String, nickName:String, phoneNumber:String) {
        let chatVC = ChatVC(chatterName:nickName , chatterUserId: opponentId, sendbirdChannelUrl: channelUrl, chatterImageUrl: profileImageUrl, phoneNumber:phoneNumber)
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
}


// MARK: - MasterDetailPanelHeaderViewDelegate
extension MasterDetailVC: MasterDetailPanelHeaderViewDelegate {
    func favoriteButtonDidClicked() {
        if (TokenManager.shared.isLogin()) {
            if let masterId = masterDetail?.masterId {
                if masterId == TokenManager.shared.getUserId() {
                    showErrorMessageBanner(NSLocalizedString("Oops sorry, you can't favorite yourself", comment: ""))
                } else {
                    mPresenter.requestFavorite(forMasterId: masterId, isFavorite: isFavorite)
                }
            }
        } else {
            self.goToLoginScreen(afterLoginScreenType: .masterDetail)
        }
        
    }
    
    func shareButtonDidClicked() {
        guard let masterDetail = self.masterDetail, let masterslug = masterDetail.slug , masterslug.isEmpty == false else {
            return
        }
        let shareUrlString = "\(IGSEnv.IGetSpotShareUrl)/\(masterslug)"
        shareMaster(withText: NSLocalizedString("Check out this master!", comment: ""), linkUrl: shareUrlString, sender: headerPanelView.favoriteShareChatView.shareButton)
    }
    
    func chatButtonDidClicked() {
        if let currentUserId = TokenManager.shared.getUserId() {
            guard let masterDetail = self.masterDetail, let masterId = masterDetail.masterId else {
                showErrorMessageBanner(NSLocalizedString("Ooops, something went wrong with this master. please try again", comment: ""))
                return
            }
            if (currentUserId == masterId) {
                let chatListVC = ChatListTVC()
                navigationController?.pushViewController(chatListVC, animated: true)
            } else {
                mPresenter.getChannelRoom(currentUserId: currentUserId, opponentId: masterId)
            }
        } else {
            self.goToLoginScreen(afterLoginScreenType: .masterDetail)
        }
    }
    
    func moreButtonDidClicked() {
        let masterDetailMoreVC = MasterDetailMoreVC()
        masterDetailMoreVC.masterDetail = self.masterDetail
        if (TokenManager.shared.isLogin()) {
            self.navigationController?.pushViewController(masterDetailMoreVC, animated: true)
        } else {
            self.goToLoginScreen()
        }
    }
}


// MARK: - PagingViewControllerDataSource
extension MasterDetailVC: PagingViewControllerDataSource {
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

// MARK: - MasterDetailPackageTVCDelegate
extension MasterDetailVC: MasterDetailPackageTVCDelegate {
    
    func packageDidPressed(packageDetailList : PackageDetailList) {
        let masterDetailPackageDetailVC = MasterDetailPackageDetailVC()
        masterDetailPackageDetailVC.masterId = masterDetail?.masterId
        masterDetailPackageDetailVC.packageId = packageDetailList.packageId
        masterDetailPackageDetailVC.masterUserName = masterDetail?.slug
        self.navigationController?.pushViewController(masterDetailPackageDetailVC, animated: true)
    }
    
    func setHeaderBackgroundImagePackage(withUrlString urlString:String) {
        imageHeaderView.setImageHeader(withUrlString: urlString)
    }
}
