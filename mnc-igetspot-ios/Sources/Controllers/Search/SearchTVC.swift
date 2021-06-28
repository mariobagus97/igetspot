//
//  SearchVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/5/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class SearchTVC: MKTableViewController {
    var section: MKTableViewSection!
    var popularSearchCell : PopularSearchCell!
//    var resultCell : PopularResultCell!
    var emptyCell: IGSEmptyCell!
    var mPresenter = SearchPresenter()
    var searchKeyword = ""
    var loadingCell: LoadingCell!
    var emptyLoadingView = EmptyLoadingView()
    var fromMasterDetail = false
    var masterId = ""
    
    
    // MARK: - Lifecycle
    override func setupTableViewStyles() {
        super.setupTableViewStyles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableSwipeMenuView()
        self.mPresenter.attachview(self)
        
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
    
    override func registerNibs() {
        super.registerNibs()
//        contentView.registeredCellIdentifiers.append(R.nib.popularSearchCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.popularResultCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.categoryDetailPackageCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
    }
    
    override func createSections() {
        super.createSections()
        section = MKTableViewSection()
        contentView.appendSection(section)
        
        self.contentView.reloadData()
    }
    
    override func createRows() {
        super.createRows()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupSearchBar(withPlaceHolder: NSLocalizedString("I am looking for...", comment: ""))
        setupRightBarButtonItems()
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
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createPopularSearchCell() {
        popularSearchCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.popularSearchCell.name) as? PopularSearchCell
        popularSearchCell.delegate = self
        section.appendRow(cell: popularSearchCell)
    }
    
    private func createPopularResultCell() {
        section.removeAllRows()
//        resultCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.popularResultCell.name) as? PopularResultCell
//        section.appendRow(cell: resultCell)
//        resultCell.delegate = self
    }
    
    func setPopularSearch(list : [String]){
        createPopularSearchCell()
        popularSearchCell.setContent(content: list)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func setResult(resultList : [MasterSearch]){
        print("total rows items here1 \(section.numberOfRows())")
        contentView.removeAllSection()
        createSections()
        print("total rows items here2 \(resultList.count)")
        print("total rows \(section.numberOfRows())")
        let resultCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.popularResultCell.name) as! PopularResultCell
        resultCell.delegate = self
        resultCell.setResultContent(package: resultList)
        if (resultList.count == 0) {
            showEmpty(NSLocalizedString("No package available for keyword \"\(self.searchKeyword)\"", comment: ""), nil)
            return
        }
        section.appendRow(cell: resultCell)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.contentView.reloadData()
        }
    }
    
    func setSearchResult(resultList : [MasterSearch]){
        section.removeAllRows()
        for item in resultList {
            createSearchResultCell(package: item)
        }
        print("total rows items\(resultList.count)")
        contentView.reloadData()
    }
    
    func createSearchResultCell(package: MasterSearch) {
        let searchResultCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.categoryDetailPackageCell.name) as! CategoryDetailPackageCell
        searchResultCell.setSearchContent(package: package)
        searchResultCell.delegate = self
        section.appendRow(cell: searchResultCell)
    }
    
    override func backButtonDidClicked() {
        navigationController?.pop()
    }
    
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchKeyword = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.requestResult(_:)), object: searchBar)
        perform(#selector(self.requestResult(_:)), with: searchBar, afterDelay: 1.0)
    }
    
     @objc func requestResult(_ searchBar: UISearchBar){
        if (searchKeyword != ""){
            if (fromMasterDetail){
                self.mPresenter.searchInMaster(masterId: self.masterId, keyword: self.searchKeyword)
            } else {
                self.mPresenter.search(keyword: searchKeyword)
            }
        }
    }
}

extension SearchTVC : PopularSearchCellDelegate{
    func refreshTable() {
        DispatchQueue.main.async{
            self.contentView.reloadData()
            self.contentView.setNeedsLayout()
            self.contentView.layoutIfNeeded()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func onCellPressed(text: String) {
        //
    }
    

    func onClearAllPressed(){

    }
}

extension SearchTVC : PopularResultCellDelegate{
    
    func onFilterPressed(){
        
    }
    
    func onResultPressed(package: MasterSearch){
        let categoryVC = MasterDetailPackageDetailVC()
        categoryVC.packageId = package.packageId
        categoryVC.masterId = package.masterId
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
}

extension SearchTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            self.mPresenter.search(keyword: self.searchKeyword ?? "")
        }
    }
}

extension SearchTVC : CategoryDetailPackageCellDelegate {
    func packageCellDidSelect(package: Package) {
        //
    }
    
    func packageSearchCellDidSelect(package: MasterSearch) {
        if (!fromMasterDetail){
            let masterDetailPackageDetailVC = MasterDetailPackageDetailVC()
            masterDetailPackageDetailVC.masterId = package.masterId
            masterDetailPackageDetailVC.packageId = package.packageId
            self.navigationController?.pushViewController(masterDetailPackageDetailVC, animated: true)
        } else {
            let masterDetailPackageDetailVC = MasterDetailPackageDetailVC()
            masterDetailPackageDetailVC.masterId = self.masterId
            masterDetailPackageDetailVC.packageId = package.packageId
            self.navigationController?.pushViewController(masterDetailPackageDetailVC, animated: true)
        }
    }
}

extension SearchTVC : SearchPresenterView {
    func showLoading() {
        section.removeAllRows()
        createLoadingCell()
        section.appendRow(cell: loadingCell)
        loadingCell.updateHeight(self.view.bounds.height - self.topbarHeight)
        loadingCell.loadingIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.contentView.reloadData()
        }
    }
    
    func hideLoading() {
        self.contentView.scrollEnabled(true)
        section.removeAllRows()
    }
    
    func showErrorMessage(_ message: String) {
        //
    }
    
    func showEmpty(_ message: String, _ buttonTitle: String?) {
        section.removeAllRows()
        createEmptyCell()
        section.appendRow(cell: emptyCell)
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: "", description: message, buttonTitle: "", buttonType: .error)
        emptyCell.button.isHidden = true
        emptyCell.titleLabel.isHidden = true
        contentView.reloadData()
    }
    
}
