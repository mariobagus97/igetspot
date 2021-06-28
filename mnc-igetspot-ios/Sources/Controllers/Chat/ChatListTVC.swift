////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import CRRefresh
import SendBirdSDK

class ChatListTVC: MKTableViewController {
    
    var presenter = ChatListPresenter()
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    private var delegateIdentifier: String!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegateIdentifier = self.description
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name:NSNotification.Name(kLoginNotificationName), object: nil)
        setupNavigationBar()
        presenter.attachview(self)
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getRecentChatList()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
        if (navigationController?.viewControllers.count ?? 0 > 1) {
            disableSwipeMenuView()
        } else {
            enableSwipeMenuView()
        }
        getRecentChatList()
        
        SBDMain.add(self as SBDChannelDelegate, identifier: self.delegateIdentifier)
        ChatManager.shared.add(connectionObserver: self as ChatManagerConnectionDelegate)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SBDMain.removeChannelDelegate(forIdentifier: self.description)
        ChatManager.shared.remove(connectionObserver: self as ChatManagerConnectionDelegate)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupSearchBar(withPlaceHolder: NSLocalizedString("Search for ...", comment: ""))
        if (navigationController?.viewControllers.count ?? 0 > 1) {
            setupLeftBackBarButtonItems(barButtonType: .backButton)
        } else {
            setupLeftBackBarButtonItems(barButtonType: .hamburgerMenu)
        }
    }
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = SearchChatTVC()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.push(viewController: searchVC)
        return false
    }
    
    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.recentChatCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
    }
    
    // MARK: - Public Functions
    
    
    // MARK: - Private Functions
    @objc private func refreshData() {
        contentSection.removeAllRows()
        contentView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.getRecentChatList()
        }
    }
    
    private func getRecentChatList() {
        presenter.getRecentChats()
    }
    
    private func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createRecentChatCell() -> RecentChatCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.recentChatCell.name) as! RecentChatCell
        cell.delegate = self
        return cell
    }
}

// MARK: - ChatListView
extension ChatListTVC: ChatListView {
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
//        if (emptyCellButtonType != .error){
            emptyCell.button.isHidden = true
//        }
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(recentChatListArray: [RecentChat]) {
        contentSection.removeAllRows()
        for recentChat in recentChatListArray {
            let cell = createRecentChatCell()
            contentSection.appendRow(cell: cell)
            cell.setContent(recentChat: recentChat)
        }
        
        contentView.reloadData()
    }
}

// MARK: - RecentChatCellDelegate
extension ChatListTVC: RecentChatCellDelegate {
    func recentChatDidClicked(recentChat: RecentChat) {
        guard let chatterUserId = recentChat.member?.userId, let channelUrl = recentChat.channelUrl else {
            return
        }
        let chatVC = ChatVC(chatterName:recentChat.member?.nickName ?? "" , chatterUserId: chatterUserId, sendbirdChannelUrl: channelUrl, chatterImageUrl: recentChat.member?.profileUrl ?? "", phoneNumber: recentChat.member?.phoneNumber ?? "")
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

// MARK: - IGSEmptyCellDelegate
extension ChatListTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            getRecentChatList()
        } else {
            
        }
    }
}

// MARK: ChatManagerConnectionDelegate
extension ChatListTVC: ChatManagerConnectionDelegate {
    func didConnect(isReconnection: Bool) {
        
    }
    
    func didDisconnect() {
        
    }
}

// MARK: SBDChannelDelegate
extension ChatListTVC: SBDChannelDelegate {
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        getRecentChatList()
    }
    
    func channelDidUpdateReadReceipt(_ sender: SBDGroupChannel) {
        
    }
    
    func channelDidUpdateTypingStatus(_ sender: SBDGroupChannel) {
    
    }
    
    func channel(_ sender: SBDGroupChannel, userDidJoin user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDGroupChannel, userDidLeave user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDOpenChannel, userDidEnter user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDOpenChannel, userDidExit user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, userWasMuted user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, userWasUnmuted user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, userWasBanned user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, userWasUnbanned user: SBDUser) {
        
    }
    
    func channelWasFrozen(_ sender: SBDBaseChannel) {
        
    }
    
    func channelWasUnfrozen(_ sender: SBDBaseChannel) {
        
    }
    
    func channelWasChanged(_ sender: SBDBaseChannel) {
        
    }
    
    func channelWasDeleted(_ channelUrl: String, channelType: SBDChannelType) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, messageWasDeleted messageId: Int64) {
        
    }
}
