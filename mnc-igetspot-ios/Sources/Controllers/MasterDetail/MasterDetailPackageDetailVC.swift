////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import MXParallaxHeader

class MasterDetailPackageDetailVC: MKViewController, MKTableViewDelegate {
    
    var headerView : MasterDetailImageHeaderView!
    var contentView : MKTableView!
    var infoCell: PackageDetailInfoCell!
    var panelCell: PackageDetailPanelCell!
    var descriptionCell: PackageDetailDescriptionCell!
    var packagePortofolioCell : PackageDetailPortofolioCell!
    var packageOrderCell : PackageDetailOrderCell!
    var emptyCell : IGSEmptyCell!
    var loadingCell: LoadingCell!
    var scrollView : MXScrollView!
    var contentSection: MKTableViewSection!
    var parallaxHeaderHeight:CGFloat = 140
    var mPresenter = MasterDetailPackageDetailPresenter()
    var masterId: String?
    var packageId:String?
    var masterUserName:String?
    var packageName: String?
    var isFavorite = false
    var isWishlist = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        adjustLayout()
        addScrollView()
        mPresenter.attachview(self)
        getPackageDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func tryAgainButtonDidClicked() {
        super.tryAgainButtonDidClicked()
        
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle("")
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = SearchTVC()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.push(viewController: searchVC)
        return false
    }
    
    // MARK: - MKTableViewDelegate
    func createRows() {
        createPackageInfoCell()
        createPackagePanelCell()
        createPackageDescriptionCell()
        createPackagePortofolioCell()
        createPackageOrderCell()
    }
    
    func createSections() {
        contentSection = MKTableViewSection()
        contentView.appendSection(contentSection)
    }
    
    func registerNibs() {
        contentView.registeredCellIdentifiers.append(contentsOf: [
            R.nib.packageDetailInfoCell.name,
            R.nib.packageDetailPortofolioCell.name,
            R.nib.packageDetailPanelCell.name,
            R.nib.packageDetailDescriptionCell.name,
            R.nib.packageDetailOrderCell.name,
            R.nib.igsEmptyCell.name,
            R.nib.loadingCell.name
            ])
    }
    
    // MARK: - Actions
    
    
    // MARK: - Private Methods
    private func createPackageDescriptionCell() {
        descriptionCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.packageDetailDescriptionCell.name) as? PackageDetailDescriptionCell
    }
    
    private func createPackagePortofolioCell() {
        packagePortofolioCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.packageDetailPortofolioCell.name) as? PackageDetailPortofolioCell
        packagePortofolioCell.loadView()
    }
    
    private func createPackagePanelCell() {
        panelCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.packageDetailPanelCell.name) as? PackageDetailPanelCell
        panelCell.delegate = self
    }
    
    private func createPackageInfoCell() {
        infoCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.packageDetailInfoCell.name) as? PackageDetailInfoCell
    }
    
    private func createPackageOrderCell() {
        packageOrderCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.packageDetailOrderCell.name) as? PackageDetailOrderCell
        packageOrderCell.delegate = self
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func addScrollView() {
        headerView = MasterDetailImageHeaderView()
        headerView.delegate = self
        
        contentView = MKTableView(frame: .zero)
        contentView.registerDelegate(delegate: self)
        
        parallaxHeaderHeight = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? parallaxHeaderHeight - 20 : parallaxHeaderHeight
        scrollView = MXScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = parallaxHeaderHeight
        scrollView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints{ (make) in
            make.left.right.equalTo(scrollView)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo((scrollView.parallaxHeader.view?.snp.bottom)!).offset(0)
            make.height.equalTo(self.view.frame.height - self.scrollView.frame.height - self.topbarHeight)
        }
    }
    
    // MARK: - Public Functions
    func getPackageDetail() {
        guard let masterId = self.masterId ,let packageId = self.packageId else {
            return
        }
        mPresenter.getPackageDetail(masterId: masterId, packageId: packageId)
    }
}

// MARK: - PackageDetailPanelCellDelegate
extension MasterDetailPackageDetailVC: PackageDetailPanelCellDelegate {
    func favoriteButtonDidClicked() {
        if (TokenManager.shared.isLogin()) {
            if let masterId = self.masterId {
                if masterId == TokenManager.shared.getUserId() {
                    showErrorMessageBanner(NSLocalizedString("Oops sorry, you can't favorite yourself", comment: ""))
                } else {
                    mPresenter.requestFavorite(forMasterId: masterId, isFavorite: isFavorite)
                }
            }
        } else {
            goToLoginScreen(afterLoginScreenType: .packageDetail)
        }
    }
    
    func shareButtonDidClicked() {
        guard let masterUserName = self.masterUserName, masterUserName.isEmpty == false else {
            showErrorMessageBanner(NSLocalizedString("Sorry cannot share this user right now. code (810)", comment: ""))
            return
        }
        let shareUrlString = "\(IGSEnv.IGetSpotShareUrl)/\(masterUserName)"
        shareMaster(withText: NSLocalizedString("Check out this master!", comment: ""), linkUrl: shareUrlString, sender: panelCell.favoriteShareChatView.shareButton)
    }
    
    func chatButtonDidClicked() {
        if let currentUserId = TokenManager.shared.getUserId() {
            if (currentUserId == masterId) {
                let chatListVC = ChatListTVC()
                navigationController?.pushViewController(chatListVC, animated: true)
            } else {
                guard let id = masterId else {
                    showErrorMessageBanner(NSLocalizedString("Ooops, something went wrong with this master. please try again", comment: ""))
                    return
                }
                mPresenter.getChannelRoom(currentUserId: currentUserId, opponentId: id)
            }
        } else {
            self.goToLoginScreen(afterLoginScreenType: .masterDetail)
        }
    }
    
    func moreButtonDidClicked() {
        let alertController = UIAlertController(title: packageName, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Report Package", style: .default, handler: { _ in
            let reportProfileTVC = ReportProfileTVC(title: "Report Package")
            reportProfileTVC.isReportPackage = true
            reportProfileTVC.packageId = self.packageId
            if (TokenManager.shared.isLogin()) {
                self.navigationController?.pushViewController(reportProfileTVC, animated: true)
            } else {
                self.goToLoginScreen()
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }
}

// MARK: - MasterDetailPackageDetailView
extension MasterDetailPackageDetailVC: MasterDetailPackageDetailView {
    func showMessageError(message: String) {
        showErrorMessageBanner(message)
    }
    
    func showPackageDetailLoadingHUD() {
        showLoadingHUD()
    }
    
    func hidePackageDetailLoadingHUD() {
        hideLoadingHUD()
    }
    
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?) {
        scrollView.isScrollEnabled = false
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func showLoadingView() {
        scrollView.isScrollEnabled = false
        contentSection.removeAllRows()
        createLoadingCell()
        contentSection.appendRow(cell: loadingCell)
        loadingCell.updateHeight(300)
        loadingCell.loadingIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.contentView.reloadData()
        }
    }
    
    func hideLoadingView() {
        contentSection.removeAllRows()
    }
    
    func setLoadingFavoriteButton(isLoading:Bool) {
        panelCell.loadingFavoriteButton(isLoading: isLoading)
    }
    
    func setLoadingWishlistButton(isLoading:Bool) {
        headerView.setLoadingWishlistButton(isLoading: isLoading)
    }
    
    func setFavorite(isFavorite:Bool) {
        self.isFavorite = isFavorite
        panelCell.setFavorite(isFavorite: self.isFavorite)
    }
    
    func setWishlist(isWishlist:Bool) {
        self.isWishlist = isWishlist
        headerView.setupWishlistButton(isWishlist: self.isWishlist)
    }
    
    func setContent(packageDetail : PackageDetail) {
        scrollView.isScrollEnabled = true
        setupNavigationBarTitle(packageDetail.packageName ?? "")
        packageName = packageDetail.packageName ?? ""
        contentSection.appendRow(cell: infoCell)
        contentSection.appendRow(cell: panelCell)
        contentSection.appendRow(cell: descriptionCell)
        
        headerView.setImage(imageUrl: packageDetail.profileImageUrl ?? "")
        infoCell.setContent(packageDetail: packageDetail)
        panelCell.setContent(packageDetail: packageDetail)
        descriptionCell.titleLabel.addCharactersSpacing(spacing: 1.0, text: NSLocalizedString("Description", comment: ""))
        descriptionCell.setDescription(description: packageDetail.about ?? "")
        descriptionCell.setDuration(duration: packageDetail.duration)
        
        setFavorite(isFavorite: packageDetail.isFavorite)
        setWishlist(isWishlist: packageDetail.isWishlist)
        
        createPackagePortofolioCell()
        packagePortofolioCell.delegate = self
        packagePortofolioCell.titleLabel.text = NSLocalizedString("Package Portfolio", comment: "")
        contentSection.appendRow(cell: packagePortofolioCell)
        contentSection.appendRow(cell: packageOrderCell)
        
        if let imageUrlArray = packageDetail.packagePortofolioImages, imageUrlArray.count > 0  {
            let imageUrlString = imageUrlArray[0]
            headerView.setImageHeader(withUrlString: imageUrlString)
            packagePortofolioCell.setContent(imageUrls: imageUrlArray)
        }
        contentView.reloadData()
    }
    
    func goToOrderDetail(packageId: String, orderDetail:OrderDetail) {
        let orderDetailTVC = OrderDetailTVC()
        orderDetailTVC.packageId = packageId
        orderDetailTVC.orderDetail = orderDetail
        navigationController?.pushViewController(orderDetailTVC, animated: true)
    }
    
    func goToChatRoom(channelUrl:String, opponentId:String, profileImageUrl:String, nickName:String, phoneNumber:String) {
        let chatVC = ChatVC(chatterName:nickName , chatterUserId: opponentId, sendbirdChannelUrl: channelUrl, chatterImageUrl: profileImageUrl, phoneNumber:phoneNumber)
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

// MARK: - IGSEmptyCellDelegate
extension MasterDetailPackageDetailVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            getPackageDetail()
        }
    }
}

// MARK: - PackageDetailPortofolioCellDelegate
extension MasterDetailPackageDetailVC: PackageDetailPortofolioCellDelegate {
    func packagePortofolioDidClicked(imageUrls: [String], index: Int) {
        IGSLightbox.show(imageSrcs: imageUrls, index: index)
    }
}

// MARK: - MasterDetailImageHeaderViewDelegate
extension MasterDetailPackageDetailVC: MasterDetailImageHeaderViewDelegate {
    func wishlistButtonDidClicked() {
        if (TokenManager.shared.isLogin()) {
            if let masterId = self.masterId {
                if masterId == TokenManager.shared.getUserId() {
                    showErrorMessageBanner(NSLocalizedString("Oops sorry, you can't wishlist yourself", comment: ""))
                    return
                }
            }
            if let packageId = self.packageId {
                mPresenter.requestWishlist(packageId: packageId, isWishlist: isWishlist)
            }
        } else {
            goToLoginScreen(afterLoginScreenType: .packageDetail)
        }
    }
}

// MARK: - PackageDetailOrderCellDelegate
extension MasterDetailPackageDetailVC: PackageDetailOrderCellDelegate {
    func orderButtonDidClicked() {
        if let packageId = self.packageId, TokenManager.shared.isLogin() {
            mPresenter.requestOrderPackage(packageId: packageId)
        } else {
            goToLoginScreen()
        }
    }
}
