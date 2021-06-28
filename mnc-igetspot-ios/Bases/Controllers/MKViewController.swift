//
//  MKViewController.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 10/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit
import SafariServices
import SwiftMessages
import SnapKit
import SVProgressHUD

enum BarButtonItemType {
    case hamburgerMenu
    case backButton
    case closeButton
    case titleButtonModal
}

protocol CantRotate {
    
}

enum AfterLoginScreenType : Int {
    case mySpotRegistration
    case favorite
    case wishlist
    case chatTab
    case transactionsTab
    case orderTab
    case masterDetail
    case packageDetail
    case home
    case none
}

class MKViewController: UIViewController, UIGestureRecognizerDelegate {
    
    fileprivate var isWillFirstAppear: Bool = true
    var searchBar:UISearchBar = UISearchBar()
    var errorView: ErrorView?
    let bgwhite = UIView()
    let border = UIView()
    
    static let NAV_HIDE = 0
    static let NAV_TRANSPARENT = 1
    static let NAV_WHITE = 2
    
    var navType: Int = 1
    
    deinit {
        PrintDebug.printDebugGeneral(self, message: "deinit triggered")
    }
    
    func setupNavigationBar() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isWillFirstAppear {
            viewWillFirstAppear()
        }
        isWillFirstAppear = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if (navType == MKViewController.NAV_WHITE){
//            addBorder()
//        }
    }
    
    // I get spot
    func adjustLayout() {
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    func addBorder(){
        border.backgroundColor = Colors.inputTextGray
        bgwhite.backgroundColor = .white
        self.view.addSubview(bgwhite)
        self.view.addSubview(border)
        
        bgwhite.layer.zPosition = .greatestFiniteMagnitude
        border.layer.zPosition = .greatestFiniteMagnitude
        
        border.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            bgwhite.snp.makeConstraints{ make in
                make.left.top.right.equalTo(guide)
                make.height.equalTo(3)
            }
            border.snp.makeConstraints { make in
                make.left.right.equalTo(guide)
                make.top.equalTo(bgwhite.snp.bottom)
                make.height.equalTo(0.5)
            }
        } else {
            bgwhite.snp.makeConstraints{ make in
                make.left.top.right.equalTo(view)
                make.height.equalTo(3)
            }
            border.snp.makeConstraints { make in
                make.left.right.equalTo(view)
                make.top.equalTo(bgwhite.snp.bottom)
                make.height.equalTo(0.5)
            }
        }
        
    }
    
    func hideBorder(){
        bgwhite.isHidden = true
        border.isHidden = true
    }
    
    func createHamburgerBarButtonItem() -> UIBarButtonItem {
        let hamburgerButtonImage = R.image.hamburgerBlack()
        let hamburgerBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(self.showLeftViewAnimated(_:)), image: hamburgerButtonImage, width: 16)
        return hamburgerBarButtonItem
    }
    
    func createCloseBarButtonItem() -> UIBarButtonItem {
        let closeButtonImage = R.image.closeBlack()
        let closeBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(self.closeButtonDidClicked), image: closeButtonImage, width: 30)
        return closeBarButtonItem
    }
    
    func createBackBarButtonItem() -> UIBarButtonItem {
        let backButtonImage = R.image.backBlack()
        let backBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(self.backButtonDidClicked), image: backButtonImage, width: 30)
        return backBarButtonItem
    }
    

    
    func setupRightBarButtonItems() {
        var barButtonItems = [UIBarButtonItem]()
        let emptyBarButtonItem = UIBarButtonItem.menuButton(self, action:nil, image: nil, width: 0)
        barButtonItems.append(emptyBarButtonItem)
        self.navigationItem.rightBarButtonItems = barButtonItems
    }
    
    func setupSearchBar(withPlaceHolder placeholder:String) {
        searchBar.placeholder = placeholder
        searchBar.delegate = self
//        self.searchBar(self.searchBar, textDidChange: "co")
        let searchBarContainer = IGSSearchBarContainerView(customSearchBar: searchBar)
        if (UIDevice.current.screenType == .iPhones_5_5s_5c_SE ) {
            searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: 40)
        } else {
            searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width - 85, height: 40)
        }
        navigationItem.titleView = searchBarContainer
    }
    
    func setupLeftBackBarButtonItems(barButtonType type:BarButtonItemType) {
        var barButtonItem:UIBarButtonItem!
        switch type {
        case .hamburgerMenu:
            barButtonItem = createHamburgerBarButtonItem()
        case .closeButton:
            barButtonItem = createCloseBarButtonItem()
        default:
            barButtonItem = createBackBarButtonItem()
        }
        
        
        if (type == .hamburgerMenu) {
            enableSwipeMenuView()
        } else {
            disableSwipeMenuView()
        }
        
        if (type == .backButton) {
            self.initSwipeToBack()
        }
        
        var barButtonItems = [UIBarButtonItem]()
        barButtonItems.append(barButtonItem)
        self.navigationItem.leftBarButtonItems = barButtonItems
        
        addBorder()
    }
    
    func setupNavigationBarTitle(_ title:String) {
        self.navigationItem.title = title
        addBorder()
    }
    
    func showErrorView() {
        
        errorView = ErrorView()
        errorView?.delegate = self
        self.view.addSubview(errorView!)
        errorView?.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(self.view)
        }
    }
    
    func disableSwipeMenuView() {
        sideMenuController?.isLeftViewSwipeGestureEnabled = false
    }
    
    func enableSwipeMenuView() {
        sideMenuController?.isLeftViewSwipeGestureEnabled = true
    }
    
    // MARK: - Actions
    @objc func backButtonDidClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func closeButtonDidClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    func viewWillFirstAppear() {
        // initial data and get data from server
    }
    
    func canRotate() -> Void {}
    
    @objc func onBackPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func initSwipeToBack(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    static let startLoadingOffset: CGFloat = 20.0
    
    static func isNearTheBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        return contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height
    }
    
    func showAlert(title: String, message: String, alertStyle: UIAlertController.Style, actions: [UIAlertAction]){
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSignInAlert() {
        var actions = [UIAlertAction]()
        
        actions.append(UIAlertAction(title: "Sign In", style: .default, handler: showSignInPage))
        actions.append(UIAlertAction(title: "Cancel", style: .default, handler: hideAlert))
        
        showAlert(title: "", message: "You haven't signed in, or your previous session has expired", alertStyle: UIAlertController.Style.alert, actions: actions)
    }
    
    func hideAlert(action: UIAlertAction) {
        dismiss(animated: true, completion: nil)
    }
    
    func showSignInPage(action: UIAlertAction) {
        
    }
    
    func showStatusAlert(message: String){
        let status = MessageView.viewFromNib(layout: .statusLine)
        status.backgroundView.backgroundColor = UIColor.purple
        status.bodyLabel?.textColor = UIColor.white
        status.configureContent(body: message)
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: .statusBar)
        
        SwiftMessages.show(config: statusConfig, view: status)
    }
    
    func hideMessage(){
        SwiftMessages.hide()
    }
}


// MARK: - UISearchBarDelegate
extension MKViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text search \(searchText)")
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //
    }
}

extension MKViewController : ErrorViewDelegate {
    @objc func tryAgainButtonDidClicked() {
        
        guard let errorView = self.errorView else {
            return
        }
        UIView.animate(withDuration: 0.2) {
            errorView.alpha = 0
            errorView.removeFromSuperview()
        }
        
    }
}
