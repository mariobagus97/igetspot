//
//  FavoriteTVC.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 27/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import CRRefresh


class FavoriteTVC : MKTableViewController {

    var mPresenter = FavoritePresenter()
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var favoriteList: [Favorite]?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        mPresenter.attachview(self)
        
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getFavorite()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
        getFavorite()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Favorite", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }

    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.favoriteListCell.name)
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
    
    // MARK: - Private Funtions
    private func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func addFavorite(favorite : Favorite, highlighted: Bool = false) {
        let favoriteCell = createFavoriteListCell()
        favoriteCell.delegate = self
        favoriteCell.setContent(withFavorite: favorite)
        favoriteCell.setBackground(highlighted)
        contentSection.appendRow(cell: favoriteCell)
    }
    
    private func getFavorite() {
        mPresenter.getFavorite()
    }
    
    private func createFavoriteListCell() -> FavoriteListCell {
        let favoriteListCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.favoriteListCell.name) as? FavoriteListCell
        return favoriteListCell!
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
}

// MARK: - FavoriteView
extension FavoriteTVC: FavoriteView {
    func showMessageError(message: String) {
        showErrorMessageBanner(message)
    }
    
    func goToChatRoom(channelUrl:String, opponentId:String, profileImageUrl:String, nickName:String, phoneNumber:String) {
        let chatVC = ChatVC(chatterName:nickName , chatterUserId: opponentId, sendbirdChannelUrl: channelUrl, chatterImageUrl: profileImageUrl, phoneNumber:phoneNumber)
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    func showFavoriteLoadingHUD() {
        showLoadingHUD()
    }
    
    func hideFavoriteLoadingHUD() {
        hideLoadingHUD()
    }
    
    func showLoadingView() {
        if contentSection.numberOfRows() == 0 {
            contentView.scrollEnabled(false)
            contentSection.removeAllRows()
            createLoadingCell()
            contentSection.appendRow(cell: loadingCell)
            loadingCell.updateHeight(view.bounds.height - topbarHeight)
            loadingCell.loadingIndicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.contentView.reloadData()
            }
        }
    }
    
    func hideLoadingView() {
        contentView.scrollEnabled(true)
        contentSection.removeAllRows()
        hideCRRefresh()
    }
    
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?) {
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(favoriteArray : [Favorite]) {
        contentSection.removeAllRows()
        self.favoriteList = favoriteArray
        for i in 0...favoriteArray.count-1 {
            if (i%2 == 0){
                addFavorite(favorite: favoriteArray[i], highlighted: true)
            } else {
                addFavorite(favorite: favoriteArray[i])
            }
        }
        contentView.reloadData()
    }
    
    func updateFavoriteButton(masterId:String, isFavorite:Bool) {
        guard let favoriteList = self.favoriteList else {
            return
        }
        favoriteList.first(where: { $0.masterId == masterId })?.isFavorite = isFavorite
        setContent(favoriteArray: favoriteList)
        contentView.reloadData()
    }
    
}

// MARK: - IGSEmptyCellDelegate
extension FavoriteTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            getFavorite()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - FavoriteListCellDelegate
extension FavoriteTVC: FavoriteListCellDelegate {

    func favoriteButtonDidClicked(cell:FavoriteListCell, favorite: Favorite) {
        guard let masterId = favorite.masterId else {
            return
        }
        cell.setLoadingFavoriteButton(isLoading: true)
        mPresenter.editFavorite(masterId: masterId, isFavorite: favorite.isFavorite)
    }
    
    func chatButtonDidClicked(favorite: Favorite) {
        if let currentUserId = TokenManager.shared.getUserId() {
            guard let masterId = favorite.masterId else {
                showErrorMessageBanner(NSLocalizedString("Ooops, something went wrong with this master. please try again", comment: ""))
                return
            }
            if (currentUserId == masterId) {
                let chatListVC = ChatListTVC()
                navigationController?.pushViewController(chatListVC, animated: true)
            } else {
                mPresenter.getChannelRoom(currentUserId: currentUserId, favorite: favorite)
            }
        } else {
            self.goToLoginScreen(afterLoginScreenType: .masterDetail)
        }
    }
    
    func favoriteCellDidClicked(favorite: Favorite) {
        let masterDetailVC = MasterDetailVC()
        masterDetailVC.masterId = favorite.masterId
        masterDetailVC.masterName = favorite.masterName
        masterDetailVC.masterProfileImageUrl = favorite.masterImageUrl
        self.navigationController?.pushViewController(masterDetailVC, animated: true)
    }

}
