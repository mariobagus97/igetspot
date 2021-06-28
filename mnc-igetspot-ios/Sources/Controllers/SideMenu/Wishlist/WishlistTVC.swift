//
//  WishlistTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/13/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import CRRefresh

class WishlistTVC: MKTableViewController {
    
    var contentSection = MKTableViewSection()
    var presenter = WishlistPresenter()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var wishlistArray:[Wishlist]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        presenter.attachview(self)
        
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getWishlist()
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Wishlist", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
        getWishlist()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    deinit {
        PrintDebug.printDebugGeneral(self, message: "deinit triggered")
    }
    
    
    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.wishlistCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
    
    }
    
    override func showSignInPage(action: UIAlertAction) {
        navigationController?.pushViewController(SignInVC(), animated: true)
    }
    
    // MARK: - Private Funtions
    private func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func addWishlist(wishlist : Wishlist) {
        let wishlistCell = createWishListCell()
        wishlistCell.delegate = self
        wishlistCell.setContent(wishlist: wishlist)
        contentSection.appendRow(cell: wishlistCell)
    }
    
    private func getWishlist() {
        presenter.getWishlist()
    }
    
    private func createWishListCell() -> WishlistCell {
        let wishlistCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.wishlistCell.name) as? WishlistCell
        return wishlistCell!
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func addRows(){
        contentView.reloadData()
    }
    
}

// MARK: - WishlistView
extension WishlistTVC: WishlistView {
    func showLoadingView() {
        if contentSection.numberOfRows() == 0 {
            contentView.scrollEnabled(false)
            contentSection.removeAllRows()
            createLoadingCell()
            contentSection.appendRow(cell: loadingCell)
            loadingCell.updateHeight(self.view.bounds.height - self.topbarHeight)
            loadingCell.loadingIndicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.contentView.reloadData()
            }
        }
    }
    
    func hideLoadingView() {
        contentView.scrollEnabled(true)
        contentSection.removeAllRows()
        hideCRRefresh()
    }
    
    func showEmptyView(withMessage message:String, description:String? = "", buttonTitle:String? = nil, emptyCellButtonType:EmtypCellButtonType? = .error) {
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(wishListArray : [Wishlist]) {
        contentSection.removeAllRows()
        self.wishlistArray = wishListArray
        for wishlist in wishListArray {
            addWishlist(wishlist: wishlist)
        }
        contentView.reloadData()
    }
    
    func updateWishlist(packageId:String, isWishlist:Bool) {
        guard let wishlistArray = self.wishlistArray else {
            return
        }
        wishlistArray.first(where: { $0.packageId == packageId })?.isWishlist = isWishlist
        setContent(wishListArray: wishlistArray)
        contentView.reloadData()
    }
}

// MARK: - IGSEmptyCellDelegate
extension WishlistTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            getWishlist()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - WishlistCellDelegate
extension WishlistTVC: WishlistCellDelegate {
    func wishlistDidClicked(wishlist:Wishlist) {
        let masterDetailPackageDetailVC = MasterDetailPackageDetailVC()
        masterDetailPackageDetailVC.masterId = wishlist.masterId
        masterDetailPackageDetailVC.packageId = wishlist.packageId
        navigationController?.pushViewController(masterDetailPackageDetailVC, animated: true)
    }
    
    func wishlistButtonDidClicked(wishlist: Wishlist, cell:WishlistCell) {
        if let packageId = wishlist.packageId {
            cell.setLoadingWishlistButton(isLoading: true)
            presenter.requestWishlist(packageId: packageId, isWishlist: wishlist.isWishlist)
        }
    }
    
    func meetingButtonDidClicked(wishlist: Wishlist) {
        print("meetingButtonDidClicked")
    }
    
    
}
