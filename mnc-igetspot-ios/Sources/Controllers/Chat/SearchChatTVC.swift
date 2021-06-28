//
//  SearchChatTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 01/07/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class SearchChatTVC: MKTableViewController {
    
    var emptyCell: IGSEmptyCell!
    var loadingCell: LoadingCell!
    var searchKeyword = ""
    var presenter = ChatListPresenter()
    var contentSection = MKTableViewSection()
    
    // MARK: - Lifecycle
    override func setupTableViewStyles() {
        super.setupTableViewStyles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableSwipeMenuView()
        
        presenter.attachview(self)
        
        self.edgesForExtendedLayout = .all
        self.automaticallyAdjustsScrollViewInsets = false
        self.contentView.tableView.contentInset = UIEdgeInsets.zero
        setupNavigationBar()
        contentView.tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupSearchBar(withPlaceHolder: NSLocalizedString("I am looking for...", comment: ""))
        setupRightBarButtonItems()
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
    }
    
    override func setupRightBarButtonItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action:nil, image: nil, width: 0)
        
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
    
    
    // Register and create cell
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.recentChatCell.name)
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
    
    // Searchbar
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchKeyword = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.requestResult(_:)), object: searchBar)
        perform(#selector(self.requestResult(_:)), with: searchBar, afterDelay: 1.0)
    }
    
    @objc func requestResult(_ searchBar: UISearchBar){
        getChatList()
    }
    
    // function call api
    func getChatList(){
        presenter.getRecentChats(keyword: searchKeyword)
    }

}


extension SearchChatTVC : ChatListView {
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
    }
    
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?) {
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        emptyCell.button.isHidden = true
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

extension SearchChatTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            getChatList()
        }
    }
}

extension SearchChatTVC: RecentChatCellDelegate {
    func recentChatDidClicked(recentChat: RecentChat) {
        guard let chatterUserId = recentChat.member?.userId, let channelUrl = recentChat.channelUrl else {
            return
        }
        let chatVC = ChatVC(chatterName:recentChat.member?.nickName ?? "" , chatterUserId: chatterUserId, sendbirdChannelUrl: channelUrl, chatterImageUrl: recentChat.member?.profileUrl ?? "", phoneNumber: recentChat.member?.phoneNumber ?? "")
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
