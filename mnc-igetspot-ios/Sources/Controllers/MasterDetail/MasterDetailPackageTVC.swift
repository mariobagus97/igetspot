//
//  MasterDetailPackageTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/15/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//
import UIKit

protocol MasterDetailPackageTVCDelegate {
    func packageDidPressed(packageDetailList : PackageDetailList)
    func setHeaderBackgroundImagePackage(withUrlString urlString:String)
}

class MasterDetailPackageTVC : MKTableViewController {
    
    var packageSection : MKTableViewSection!
    var loadingEmptySection : MKTableViewSection!
    var loadingCell: LoadingCell!
    var emptyCell: EmptyCell!
    
    var mPresenter = MasterDetailPackagePresenter()
    var delegate: MasterDetailPackageTVCDelegate?
    var masterId: String?
    
    // MARK:- Init
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.attachview(self)
        if let masterId = self.masterId {
            getPackages(forMasterId: masterId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.reloadData()
    }
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.masterDetailPackageTableViewCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.emptyCell.name)
    }
    
    override func createSections() {
        super.createSections()
        loadingEmptySection = MKTableViewSection()
        contentView.appendSection(loadingEmptySection)
    }
    
    override func createRows() {
        super.createRows()
    }
    
    // MARK: - Private Functions
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.emptyCell.name) as? EmptyCell
    }
    
    private func createMasterDetailPackageCell() -> MasterDetailPackageTableViewCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.masterDetailPackageTableViewCell.name) as! MasterDetailPackageTableViewCell
        cell.loadView()
        cell.cellDelegate = self
        return cell
    }
    
    private func getFirstPackageImage(withPackageList packageList:PackageList) {
        guard let packageDetailListArray = packageList.packageDetailList, packageDetailListArray.count > 0 else {
            return
        }
        let packageDetailList = packageDetailListArray[0]
        guard let imageUrlArray = packageDetailList.imageUrls, imageUrlArray.count > 0 else  {
            return
        }
        let imageUrlString = imageUrlArray[0]
        delegate?.setHeaderBackgroundImagePackage(withUrlString: imageUrlString)
    }
    
    // MARK: - Public Functions
    func getPackages(forMasterId masterId:String) {
        mPresenter.getDetailPackage(forMasterId: masterId)
    }
    
}

// MARK: - MasterDetailPackageView
extension MasterDetailPackageTVC : MasterDetailPackageView {
    func showLoadingView() {
        loadingEmptySection.removeAllRows()
        createLoadingCell()
        loadingEmptySection.appendRow(cell: loadingCell)
        loadingCell.updateHeight(100)
        loadingCell.loadingIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.contentView.reloadData()
        }
    }
    
    func hideLoadingView() {
        contentView.removeAllSection()
    }
    
    func showEmptyView(withMessage message:String) {
        loadingEmptySection.removeAllRows()
        createEmptyCell()
        emptyCell.setupCell(withDescription: message)
        loadingEmptySection.appendRow(cell: emptyCell)
        
        contentView.reloadData()
    }
    
    func setContent(packageLists : [PackageList]) {
        packageSection = MKTableViewSection()
        contentView.appendSection(packageSection)
        for index in 0..<packageLists.count {
            let package = packageLists[index]
            if (index == 0) {
                getFirstPackageImage(withPackageList: package)
            }
            if let packageDetailList = package.packageDetailList, packageDetailList.count > 0 {
                let listPackageCell = createMasterDetailPackageCell()
                listPackageCell.titleLabel.text = package.title
                listPackageCell.setContent(packageDetailLists: packageDetailList)
                packageSection.appendRow(cell: listPackageCell)
            }
        }
        contentView.reloadData()
    }
}

// MARK: - MasterDetailPackageTableViewCellDelegate
extension MasterDetailPackageTVC : MasterDetailPackageTableViewCellDelegate {
    func onCellPressed(packageDetailList: PackageDetailList) {
        delegate?.packageDidPressed(packageDetailList: packageDetailList)
    }
}
