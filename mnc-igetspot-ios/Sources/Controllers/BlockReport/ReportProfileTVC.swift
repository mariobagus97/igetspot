//
//  ReportProfileTVC.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 03/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import UIKit

class ReportProfileTVC: MKTableViewController {
    
    var contentSection = MKTableViewSection()
    var headerCell: ReportProfileHeaderCell!
    var emptyCell: EmptyCell!
    var loadingCell: LoadingCell!
    
    var mPresenter = ReportProfilePresenter()
    var isReportPackage = false
    var userId: String?
    var packageId: String?
    
    // MARK:- Init
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        setupNavigationBarTitle(title)
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.attachview(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.isReportPackage {
                self.mPresenter.getReportPackageItem()
            } else {
                self.mPresenter.getReportProfileItem()
            }
        }
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
        contentView.registeredCellIdentifiers.append(R.nib.reportProfileHeaderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.reportProfileItemCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.emptyCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.removeAllSection()
        let headerSection = MKTableViewSection()
        headerSection.appendRow(cell: headerCell)
        contentView.appendSection(headerSection)
        contentView.appendSection(contentSection)
        contentView.reloadData()
    }
    
    override func createRows() {
        super.createRows()
        createReportProfileHeaderCell()
    }
    
     // MARK: - Private Functions
    private func createReportProfileHeaderCell() {
        headerCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.reportProfileHeaderCell.name) as? ReportProfileHeaderCell
    }
    
    private func createReportProfileItemCell() -> ReportProfileItemCell {
        let itemCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.reportProfileItemCell.name) as! ReportProfileItemCell
        itemCell.delegate = self
        return itemCell
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.emptyCell.name) as? EmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
}

extension ReportProfileTVC: ReportProfileView {
    func showLoadingView() {
        contentSection.removeAllRows()
        createLoadingCell()
        contentSection.appendRow(cell: loadingCell)
        loadingCell.updateHeight(300)
        loadingCell.loadingIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.contentView.reloadData()
        }
    }
    
    func hideLoadingView() {
        contentSection.removeAllRows()
    }
    
    func showEmptyView(withMessage message: String) {
        createEmptyCell()
        emptyCell.setupCell(withDescription: message)
        contentSection.appendRow(cell: emptyCell)
        
        contentView.reloadData()
    }
    
    func setContent(itemLists: [String]) {
        contentSection.removeAllRows()
        for index in 0..<itemLists.count {
            let item = itemLists[index]
            let itemCell = createReportProfileItemCell()
            itemCell.content = item
            contentSection.appendRow(cell: itemCell)
        }
        contentView.reloadData()
    }
}

extension ReportProfileTVC: ReportProfileItemCellDelegate {
    func didItemViewPressed(title: String?) {
        let reportProfileFormVC = ReportProfileDetailVC()
        reportProfileFormVC.titleString = title
        reportProfileFormVC.isReportPackage = isReportPackage
        if isReportPackage {
            reportProfileFormVC.id = self.packageId ?? ""
        } else {
            reportProfileFormVC.id = self.userId ?? ""
        }
        navigationController?.pushViewController(reportProfileFormVC, animated: true)
    }
    
}
