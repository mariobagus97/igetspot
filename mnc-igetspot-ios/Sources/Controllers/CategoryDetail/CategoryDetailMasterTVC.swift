//
//  CategoryDetailMasterTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/30/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//


import UIKit
import SnapKit

protocol CategoryDetailMasterTVCDelegate:class {
    func masterListDidSelect(masterList: MasterList)
}

class CategoryDetailMasterTVC : MKTableViewController {
    
    var contentSection = MKTableViewSection()
    var mPresenter = CategoryDetailMasterPresenter()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var parameters: [String:String]?
    weak var delegate: CategoryDetailMasterTVCDelegate?
    
    
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
        getListMaster(parameters: parameters)
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
        contentView.registeredCellIdentifiers.append(R.nib.categoryDetailMasterCell.name)
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
    
    // MARK: - Public Funtions
    func getListMaster(parameters:[String:String]?) {
        self.mPresenter.getMaster(parameters: parameters)
    }
    
    func addMasterList(master: MasterList){
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.categoryDetailMasterCell.name) as! CategoryDetailMasterCell
        cell.delegate = self
        contentSection.appendRow(cell: cell)
        cell.setContent(masterList: master)
    }
    
}

// MARK: - IGSEmptyCellDelegate
extension CategoryDetailMasterTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            self.getListMaster(parameters: parameters)
        }
    }
}

// MARK: - CategoryDetailMasterCellDelegate
extension CategoryDetailMasterTVC: CategoryDetailMasterCellDelegate {
    func masterCellDidSelect(masterList: MasterList) {
        delegate?.masterListDidSelect(masterList: masterList)
    }
}

extension CategoryDetailMasterTVC : CategoryDetailMasterView {
    
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
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: "", description: message, buttonTitle: "", buttonType: .error)
        emptyCell.button.isHidden = true
        emptyCell.titleLabel.isHidden = true
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(categoryMaster: CategoryMaster) {
        contentSection.removeAllRows()
        contentView.reloadData()
        guard let masterListArray = categoryMaster.masterList, masterListArray.count > 0 else {
            showEmpty(NSLocalizedString("No master available for this category", comment: ""), nil)
            return
        }
        
        for masterList in masterListArray {
            addMasterList(master: masterList)
        }
        contentView.reloadData()
    }
}
