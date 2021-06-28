//
//  MasterDetailAboutTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/16/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class MasterDetailAboutTVC : MKTableViewController {
    
    var section: MKTableViewSection!
    var descriptionCell: MasterDetailAboutDescriptionCell!
    var titleSectionCell : MasterDetailSectionTitleTableViewCell!
    var emptyCell: EmptyCell!
    var servicesCell: MasterDetailServiceCell!
    var loadingCell: LoadingCell!
    var servicesHeader: ServicesHeaderView!
    var mPresenter = MasterDetailServicePresenter()
    var serviceSection: MKTableViewSection!
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
            getServices(forMasterId: masterId)
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
        contentView.registeredCellIdentifiers.append(R.nib.masterDetailAboutDescriptionCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.masterDetailSectionTitleTableViewCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.masterDetailServiceCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.emptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
    }
    
    override func createSections() {
        super.createSections()
        section = MKTableViewSection()
        contentView.appendSection(section)
        contentView.reloadData()
    }
    
    override func createRows() {
        super.createRows()
        createSectionTitleCell()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    // MARK: - Public Functions
    func setContentMasterDescription(_ description : String)  {
        createDescriptionCell()
        section.appendRow(cell: descriptionCell)
        descriptionCell.setDescription(description: description)
        contentView.reloadData()
    }
    
    func getServices(forMasterId masterId:String) {
        mPresenter.getMasterService(forMasterId: masterId)
    }
    
    // MARK: - Private Functions
    private func showLoadingView() {
        createLoadingCell()
        section.removeAllRows()
        section.appendRow(cell: loadingCell)
        loadingCell.updateHeight(100)
        loadingCell.loadingIndicatorView.startAnimating()
        contentView.reloadData()
    }
    
    private func hideLoadingView() {
        section.removeAllRows()
    }
    
    private func showErrorView(withMessage message:String) {
        section.removeAllRows()
        createEmptyCell()
        emptyCell.setupCell(withDescription: message)
        section.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createDescriptionCell() {
        descriptionCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.masterDetailAboutDescriptionCell.name) as? MasterDetailAboutDescriptionCell
    }
    
    private func createServicesCell() {
        servicesCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.masterDetailServiceCell.name) as? MasterDetailServiceCell
        servicesCell.loadView()
    }
    
    private func createSectionTitleCell() {
        titleSectionCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.masterDetailSectionTitleTableViewCell.name) as? MasterDetailSectionTitleTableViewCell
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.emptyCell.name) as? EmptyCell
    }
    
    private func createServiceHeaderView(withService service:ServiceCategory) {
        servicesHeader = UINib(nibName: "ServicesHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ServicesHeaderView
        servicesHeader.expandButton.alpha = 0
        servicesHeader.serviceLabel.text = service.title
        servicesHeader.serviceImageView.loadIGSImage(link: service.iconUrl ?? "")
    }
    
    private func setSectionTitle(_ title:String) {
        titleSectionCell.titleLabel.addCharactersSpacing(spacing: 0.25, text: title)
    }
    
    private func addServiceSections(service: ServiceCategory) {
        serviceSection = MKTableViewSection()
        createServicesCell()
        createServiceHeaderView(withService: service)
        serviceSection.header = servicesHeader
        serviceSection.headerHeight = servicesHeader.bounds.height
        contentView.appendSection(serviceSection)
        serviceSection.appendRow(cell: servicesCell)
        
        guard let serviceSubCategories = service.serviceDetail else {
            return
        }
        servicesCell.setContent(services: serviceSubCategories)
    }
}

// MARK: - MasterDetailView
extension MasterDetailAboutTVC: MasterDetailServiceView {
    func handleServiceEmpty() {
        
    }
    
    func setContentServices(serviceList : [ServiceCategory]) {
        if (serviceList.count > 0) {
            let titleSection = MKTableViewSection()
            contentView.appendSection(titleSection)
            titleSection.appendRow(cell: titleSectionCell)
            setSectionTitle(NSLocalizedString("Service(s)", comment: ""))
            
            for index in 0...serviceList.count-1 {
                addServiceSections(service: serviceList[index])
            }
        }
        contentView.reloadData()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
}
