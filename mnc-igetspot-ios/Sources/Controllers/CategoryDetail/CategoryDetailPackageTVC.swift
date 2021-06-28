//
//  CategoryDetailPackageTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/30/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//


import UIKit
import SnapKit

protocol CategoryDetailPackageTVCDelegate:class {
    func packageDidSelect(package:Package)
    func setHeaderBackground(imageUrl:String)
}

class CategoryDetailPackageTVC : MKTableViewController {
    
    var contentSection = MKTableViewSection()
    var mPresenter = CategoryDetailPackagePresenter()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var parameters: [String:String]?
    weak var delegate: CategoryDetailPackageTVCDelegate?
    
    // MARK:- Init
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mPresenter.attachview(self)
        getListPackageWithParameters(parameters: parameters)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.categoryDetailPackageCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    // MARK:- Private Functions
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createPackageCell() -> CategoryDetailPackageCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.categoryDetailPackageCell.name) as! CategoryDetailPackageCell
        return cell
    }
    
    // MARK: - Public Funtions
    
    
    
    func getListPackageWithParameters(parameters:[String:String]?) {
        self.parameters = parameters
        self.mPresenter.getPackage(parameters: parameters)
    }
    
    func setPackageList(packageArray: [Package]) {
        self.contentSection.removeAllRows()
        for package in packageArray {
            addPackageList(package: package)
        }
        contentView.reloadData()
    }
    
    func addPackageList(package: Package){
        let cell = createPackageCell()
        cell.delegate = self
        cell.setContent(package: package)
        contentSection.appendRow(cell: cell)
    }
}

// MARK: - IGSEmptyCellDelegate
extension CategoryDetailPackageTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            self.getListPackageWithParameters(parameters: self.parameters)
        }
    }
}


// MARK: - CategoryDetailPackageCellDelegate
extension CategoryDetailPackageTVC: CategoryDetailPackageCellDelegate {
    func packageSearchCellDidSelect(package: MasterSearch) {
        //
    }
    
    func packageCellDidSelect(package: Package) {
        delegate?.packageDidSelect(package: package)
    }
}

extension CategoryDetailPackageTVC : CategoryDetailPackageView {
    func showLoading() {
        self.contentView.scrollEnabled(false)
        contentSection.removeAllRows()
        createLoadingCell()
        contentSection.appendRow(cell: loadingCell)
        loadingCell.updateHeight(300)
        loadingCell.loadingIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.contentView.reloadData()
        }
    }
    
    func hideLoading() {
        self.contentView.scrollEnabled(true)
        contentSection.removeAllRows()
    }
    
    
    func showEmpty(_ message: String, _ buttonTitle: String?) {
        contentSection.removeAllRows()
        createEmptyCell()
        contentSection.appendRow(cell: emptyCell)
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: "", description: message, buttonTitle: "", buttonType: .error)
        emptyCell.button.isHidden = true
        emptyCell.titleLabel.isHidden = true
        contentView.reloadData()
    }
    
    func setContent(categoryPackage: CategoryPackage) {
        if let backgroundImageUrl = categoryPackage.categoryBackgroundImageUrl {
            delegate?.setHeaderBackground(imageUrl: backgroundImageUrl)
        }
        guard let packages = categoryPackage.packageArray, packages.count > 0 else {
            showEmpty(NSLocalizedString("No package available for this category", comment: ""), nil)
            return
        }
        setPackageList(packageArray: packages)
    }
}
