//
//  MasterPreviewVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/24/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import CRRefresh

class MasterPreviewVC: MKViewController{
    
    var collectionView: MasterPreviewCollectionView?
    var previewPresenter = MasterPreviewPresenter()
    var emptyLoadingView: EmptyLoadingView?
    var searchKeyword = ""
    let startPage = 1 // page start from 1
    var page:Int!
    var masterlist = [MasterPreview]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        page = startPage
        collectionView?.collectionView.keyboardDismissMode = .onDrag
        setupNavigationBar()
        addViews()
        previewPresenter.attachview(self)
        addHeaderRefresh()
        handlingPagination()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
        getMaster()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupSearchBar(withPlaceHolder: NSLocalizedString("Browse for package or master", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action:nil, image: nil, width: 0)
    }
    
    deinit {
        PrintDebug.printDebugGeneral(self, message: "deinit triggered")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Private Functions
    private func getMaster() {
        previewPresenter.getAllMaster(withPage: self.page, andSearch:self.searchKeyword)
    }
    
    private func addViews() {
        collectionView = MasterPreviewCollectionView()
        collectionView?.commonInit()
        collectionView?.delegate = self
        collectionView?.celldelegate = self
        self.view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        
        emptyLoadingView = EmptyLoadingView()
        self.view.addSubview(emptyLoadingView!)
        emptyLoadingView?.snp.makeConstraints { make in
            make.left.right.top.equalTo(view)
            make.height.equalTo(self.view.frame.height - self.topbarHeight)
        }
        emptyLoadingView?.delegate = self
        emptyLoadingView?.alpha = 0.0
    }
    
    func handlingPagination(){
        collectionView?.collectionView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            self?.page += 1
            self?.getMaster()
        }
    }
    
    func addHeaderRefresh(){
        collectionView?.collectionView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            guard let weakSelf = self else {
                return
            }
            weakSelf.collectionView?.removeContent()
            weakSelf.collectionView?.removeAllSections()
            weakSelf.collectionView?.addSection()
            weakSelf.page = weakSelf.startPage
            weakSelf.getMaster()
        }
    }
    
    func resetEmptyData(){
        self.collectionView?.removeContent()
        self.collectionView?.setContent(masters: self.masterlist)
        collectionView?.alpha = 1.0
    }
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.navigationController?.push(viewController: MasterPreviewSearchVC())
        return false
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchKeyword = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.requestResult(_:)), object: searchBar)
        perform(#selector(self.requestResult(_:)), with: searchBar, afterDelay: 1.0)
    }
    
    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.collectionView?.collectionView.cr.footer?.alpha = 0.0
        let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField
        self.searchKeyword = searchTextField?.text ?? ""
        self.page = startPage
        self.collectionView?.removeContent()
        self.collectionView?.removeAllSections()
        self.collectionView?.addSection()
        getMaster()
        self.searchBar.endEditing(true)
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
        page = startPage
        searchKeyword = ""
        collectionView?.collectionView.cr.resetNoMore()
        setupNavigationBar()
        collectionView?.removeContent()
        collectionView?.removeAllSections()
        collectionView?.addSection()
        getMaster()
    }
    
    @objc func requestResult(_ searchBar: UISearchBar){
        page = startPage
        if (searchKeyword != ""){
            self.collectionView?.removeContent()
            self.collectionView?.removeAllSections()
            self.collectionView?.addSection()
            getMaster()
        } else {
            self.collectionView?.collectionView.cr.footer?.alpha = 0.0
            self.collectionView?.removeAllSections()
            self.collectionView?.reloadData()
            self.collectionView?.layoutIfNeeded()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - MKCollectionViewDelegate
extension MasterPreviewVC: MKCollectionViewDelegate {
    func collectionViewDidSelectedItemAtIndexPath(indexPath: IndexPath) {
        if let master = collectionView?.getItem(indexPath: indexPath) as? MasterPreview {
            let masterVC = MasterDetailVC()
            masterVC.masterId = master.id
            masterVC.masterName = master.masterName
            masterVC.masterProfileImageUrl = master.imageUrl
            self.navigationController?.pushViewController(masterVC, animated: true)
        }
    }
}

// MARK: - EmptyLoadingViewDelegate
extension MasterPreviewVC: EmptyLoadingViewDelegate {
    func errorTryAgainButtonDidClicked() {
        getMaster()
    }
}

extension MasterPreviewVC: MasterPreviewCollectionViewDelegate {
    
    func hideThisKeyboard(){
        self.searchBar.endEditing(true)
    }
}

extension MasterPreviewVC : MasterPreviewView {
    func showErrorMessage(_ message: String) {
        
    }
    
    func showEmpty(_ message: String,_ buttonTitle: String?) {
        if (masterlist.count == 0) {
            emptyLoadingView?.setEmptyErrorContent(withMessage: message, buttonTitle:buttonTitle, forDisplay: .fullpage)
            collectionView?.alpha = 0.0
            emptyLoadingView?.alpha = 1.0
        }
    }
    
    func setContent(masters: [MasterPreview]){
        collectionView?.collectionView.cr.endLoadingMore()
        collectionView?.collectionView.cr.endHeaderRefresh()
        collectionView?.collectionView.cr.footer?.alpha = 1.0
        masterlist.append(contentsOf: masters)
        collectionView?.setContent(masters: masters)
        collectionView?.alpha = 1.0
    }
    
    func noMoreData(){
        collectionView?.collectionView.cr.noticeNoMoreData()
        collectionView?.collectionView.cr.footer?.alpha = 0.0
        view.layoutIfNeeded()
    }
    
    func showLoading() {
        emptyLoadingView?.showLoadingView()
        emptyLoadingView?.alpha = 1.0
        collectionView?.alpha = 0.0
    }
    
    func hideLoading() {
        emptyLoadingView?.alpha = 0.0
    }
    
}
