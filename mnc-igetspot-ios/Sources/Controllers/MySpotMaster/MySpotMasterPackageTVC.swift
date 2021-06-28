////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotMasterPackageTVCDelegate {
    func packageDidPressed(package: MySpotPackage)
}

class MySpotMasterPackageTVC: MKTableViewController {

    var contentSection : MKTableViewSection!
    var loadingCell: LoadingCell!
    var emptyCell: EmptyCell!
    var mySpotAddPackageCell: MySpotDetailAddPackageCell!
    var mPresenter = MySpotMasterPackagePresenter()
    var delegate: MySpotMasterPackageTVCDelegate?
    var masterId: String?
    
    // MARK:- Init
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.attachview(self)
        guard let masterId = TokenManager.shared.getUserId() else {
            return
        }
        getPackages(forMasterId: masterId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestPackages()
        self.contentView.reloadData()
    }
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.mySpotDetailPackageCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.mySpotDetailAddPackageCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.emptyCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentSection = MKTableViewSection()
        contentView.appendSection(contentSection)
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
    
    // MARK: - Private Functions
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.emptyCell.name) as? EmptyCell
    }
    
    private func createAddPackageCell() {
        mySpotAddPackageCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotDetailAddPackageCell.name) as? MySpotDetailAddPackageCell
    }
    private func addHeaderPackageCell() {
        createAddPackageCell()
        mySpotAddPackageCell.delegate = self
        mySpotAddPackageCell.addButton.setTitle(NSLocalizedString("Add Package Category", comment: ""), spacing: 0.86)
        contentSection.appendRow(cell: mySpotAddPackageCell)
    }
    
    private func openAddPackageServicePage(categoryId:String? = nil) {
        if let topVC = UIApplication.getTopMostViewController() {
            let whatToOffer = MySpotWhatToOfferVC()
            whatToOffer.isFromEdit = true
            whatToOffer.selectedCategoryId = categoryId
            whatToOffer.delegate = self
            let navController = UINavigationController(rootViewController: whatToOffer)
            navController.modalPresentationStyle = .fullScreen
            topVC.present(navController, animated: true, completion: nil)
        }
    }
    
    private func requestPackages() {
        guard let masterId = TokenManager.shared.getUserId() else {
            return
        }
        getPackages(forMasterId: masterId)
    }
    
    // MARK: - Public Functions
    func getPackages(forMasterId masterId:String) {
        self.masterId = masterId
        self.mPresenter.getDetailPackage(forMasterId: masterId)
    }
}

// MARK: - MySpotMasterPackageView
extension MySpotMasterPackageTVC: MySpotMasterPackageView {
    func showLoadingView() {
        createLoadingCell()
        contentSection.removeAllRows()
        contentSection.appendRow(cell: loadingCell)
        loadingCell.updateHeight(100)
        loadingCell.loadingIndicatorView.startAnimating()
        self.contentView.reloadData()
    }
    
    func hideLoadingView() {
        contentView.removeAllSection()
    }
    
    func showEmptyView(withMessage message:String) {
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.setupCell(withDescription: message)
        contentSection.appendRow(cell: emptyCell)
        addHeaderPackageCell()
        contentView.reloadData()
    }
    
    func showErrorView(withMessage message:String) {
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.setupCell(withDescription: message)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(packageLists : [MySpotPackages]) {
        contentSection.removeAllRows()
        for index in 0..<packageLists.count {
            let package = packageLists[index]
            if let packageArray = package.packageArray, packageArray.count > 0 {
                let listPackageCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotDetailPackageCell.name) as! MySpotDetailPackageCell
                contentSection.appendRow(cell: listPackageCell)
                listPackageCell.loadView()
                listPackageCell.delegate = self
                listPackageCell.titleLabel.addCharactersSpacing(spacing: 0.2, text: package.categoryTitle ?? "")
                listPackageCell.setContent(packageArray: packageArray, categoryId: package.categoryId)
            }
        }
        addHeaderPackageCell()
        contentView.reloadData()
    }
}

// MARK: - MySpotDetailPackageCellDelegate
extension MySpotMasterPackageTVC : MySpotDetailPackageCellDelegate {
    func addPackageButtonDidClicked(categoryId: String) {
        openAddPackageServicePage(categoryId: categoryId)
    }
    func editPackageButtonDidClicked(package:MySpotPackage) {
        if let tabBarViewController = UIApplication.getMainPageTabBarController(), let selectedNavController = UIApplication.getTopMostViewController(base: tabBarViewController) {
            let mySpotEditPackageDetailVC = MySpotEditPackageDetailVC()
            mySpotEditPackageDetailVC.packageId = package.id
            mySpotEditPackageDetailVC.delegate = self
            mySpotEditPackageDetailVC.hidesBottomBarWhenPushed = true
            selectedNavController.navigationController?.pushViewController(mySpotEditPackageDetailVC, animated: true)
        }
    }
}

// MARK: - MySpotDetailAddPackageCellDelegate
extension MySpotMasterPackageTVC : MySpotDetailAddPackageCellDelegate {
    func addPackageCategoryButtonDidClicked() {
        openAddPackageServicePage()
    }
}

// MARK: - MySpotWhatToOfferVCDelegate
extension MySpotMasterPackageTVC: MySpotWhatToOfferVCDelegate {
    func handleSuccess() {
        guard let masterId = self.masterId else {
            return
        }
        self.showSuccessMessageBanner(NSLocalizedString("Your package has successfully added", comment: ""))
        self.getPackages(forMasterId: masterId)
    }
}

// MARK: - MySpotEditPackageDetailVCDelegate
extension MySpotMasterPackageTVC: MySpotEditPackageDetailVCDelegate {
    func deletePackageSuccess() {
        guard let masterId = self.masterId else {
            return
        }
        self.showSuccessMessageBanner(NSLocalizedString("Your package has successfully deleted", comment: ""))
        self.getPackages(forMasterId: masterId)
    }
}
