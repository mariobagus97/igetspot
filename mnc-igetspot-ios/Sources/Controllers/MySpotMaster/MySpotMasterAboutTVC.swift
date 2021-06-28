////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotMasterAboutTVCDelegate:class {
    func showEditPage(contentString:String)
}

class MySpotMasterAboutTVC: MKTableViewController {
    
    var section: MKTableViewSection!
    var serviceSection: MKTableViewSection!
    var descriptionCell = MySpotMasterDetailAboutCell()
    var titleSectionCell : MasterDetailSectionTitleTableViewCell!
    var emptyCell: EmptyCell!
    var servicesCell: MasterDetailServiceCell!
    var loadingCell: LoadingCell!
    var servicesHeader: ServicesHeaderView!
    var mPresenter = MySpotMasterAboutPresenter()
    weak var delegate: MySpotMasterAboutTVCDelegate?
    
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
        self.mPresenter.attachview(self)
        guard let masterId = TokenManager.shared.getUserId() else {
            return
        }
        getContentAbout(forMasterId: masterId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentView.reloadData()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.mySpotMasterDetailAboutCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.masterDetailSectionTitleTableViewCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.masterDetailServiceCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.emptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
    }
    
    override func createSections() {
        super.createSections()
        section = MKTableViewSection()
        contentView.appendSection(section)
        self.contentView.reloadData()
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
    
    
    // MARK: - Private Functions
    private func getContentAbout(forMasterId masterId:String) {
        mPresenter.getMasterService(forMasterId: masterId)
        mPresenter.getMySpotMasterAbout(masterId: masterId)
    }
    
    private func createDescriptionCell() {
        descriptionCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotMasterDetailAboutCell.name) as! MySpotMasterDetailAboutCell
        descriptionCell.delegate = self
    }
    
    private func createServicesCell() {
        servicesCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.masterDetailServiceCell.name) as? MasterDetailServiceCell
        servicesCell.loadView()
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
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
        titleSectionCell.titleLabel.text = title
    }
    
    private func addServiceSections(service: ServiceCategory) {
        serviceSection = MKTableViewSection()
        createServicesCell()
        createServiceHeaderView(withService: service)
        serviceSection.header = servicesHeader
        serviceSection.headerHeight = servicesHeader.bounds.height
        contentView.appendSection(serviceSection)
        serviceSection.appendRow(cell: servicesCell)
        
//        servicesCell.setContent(services: [service])
        guard let serviceSubCategories = service.serviceDetail else {
                            return
                        }
        servicesCell.setContent(services: serviceSubCategories)

    }
}

// MARK: - MySpotMasterAboutView
extension MySpotMasterAboutTVC: MySpotMasterAboutView {
    func showMySpotLoadingHUD() {
        showLoadingHUD()
    }
    
    func hideMySpotLoadingHUD() {
        hideLoadingHUD()
    }
    
    func showMessageError(message: String) {
        showErrorMessageBanner(message)
    }
    
    func showMessageSuccess(message: String) {
        showSuccessMessageBanner(message)
    }
    
    func setContentMasterDescription(_ description : String)  {
        createDescriptionCell()
        section.appendRow(cell: descriptionCell)
        descriptionCell.setDescription(description: description)
        self.contentView.reloadData()
    }
    
    func showMasterService(serviceList : [ServiceCategory]) {
        if (serviceList.count > 0) {
            let titleSection = MKTableViewSection()
            contentView.appendSection(titleSection)
            titleSection.appendRow(cell: titleSectionCell)
            setSectionTitle(NSLocalizedString("Service", comment: ""))
            
            for index in 0...serviceList.count-1 {
                addServiceSections(service: serviceList[index])
            }
        }
        contentView.reloadData()
    }
    
    func showLoadingAboutView() {
        createLoadingCell()
        section.removeAllRows()
        section.appendRow(cell: loadingCell)
        loadingCell.updateHeight(100)
        loadingCell.loadingIndicatorView.startAnimating()
        self.contentView.reloadData()
    }
    
    func hideLoadingAboutView() {
        section.removeAllRows()
    }
    
    func showErrorView(withMessage message:String) {
        section.removeAllRows()
        createEmptyCell()
        emptyCell.setupCell(withDescription: message)
        section.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func handleServiceEmpty() {
        
    }
    
    func handleSuccessEditAboutMaster(about:String) {
        descriptionCell.setDescription(description: about)
        contentView.reloadData()
    }
}

// MARK: - MySpotMasterDetailAboutCellDelegate
extension MySpotMasterAboutTVC: MySpotMasterDetailAboutCellDelegate {
    func editButtonDidClicked(aboutString:String?) {
        let mySpotEditVC = MySpotEditVC()
        mySpotEditVC.aboutTextString = aboutString ?? ""
        mySpotEditVC.delegate = self
        mySpotEditVC.title = NSLocalizedString("Edit Introduction", comment: "")
        let navController = UINavigationController(rootViewController: mySpotEditVC)
        self.present(navController, animated: true, completion: nil)
    }
}

// MARK: - MySpotMasterDetailAboutCellDelegate
extension MySpotMasterAboutTVC: MySpotEditVCDelegate {
    func saveButtonDidClicked(content: String, editVC:MySpotEditVC) {
        editVC.dismiss(animated: true, completion: { [weak self] in
            self?.mPresenter.editAboutMaster(contentString: content)
        })
    }
}
