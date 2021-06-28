//
//  HelpCenterVc.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/15/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit
import SwiftMessages
import FloatingPanel

class HelpCenterTVC : MKTableViewController {
    
    var section: MKTableViewSection!
    var browseHelpCell : BrowseHelpCell!
    var questionHelpCell : QuestionHelpCell!
    var mPresenter = HelpCenterPresenter()
    var loadingCell: LoadingCell!
    var helpContactUs: HelpContactUs!
    var contactUsVC : FloatingPanelController!
    var emptyCell: IGSEmptyCell!
    
    // MARK: - Lifecycle
    override func setupTableViewStyles() {
        super.setupTableViewStyles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mPresenter.attachview(self)
        
        setupNavigationBar()
        requestHelp()
        
        addFooter()
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
    }
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.questionHelpCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.browseHelpCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.helpContactUs.name)
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    override func setupNavigationBar() {
        setupSearchBar(withPlaceHolder: NSLocalizedString("I want to know about", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    
    private func createBrowseHelp() {
        browseHelpCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.browseHelpCell.name) as? BrowseHelpCell
//        browseHelpCell.delegate = self
        section.appendRow(cell: browseHelpCell)
    }

    
    func createQuestionCell(){
        questionHelpCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.questionHelpCell.name) as? QuestionHelpCell
        section.appendRow(cell: questionHelpCell)
    }
    
    func setQuestionContent(list : [String]){
        createQuestionCell()
        questionHelpCell.setResultContent(questionList: list)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func removeSelf(){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    // MARK: - Publics Functions
    func showEmptyView(withMessage message:String, description:String? = "", buttonTitle:String? = nil, emptyCellButtonType:EmtypCellButtonType? = .error) {
        section.removeAllRows()
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        section.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    func requestHelp(){
        self.mPresenter.getHelpList()
    }
    
    func addFooter(){
        helpContactUs  = UINib(nibName: "HelpContactUs", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? HelpContactUs
        helpContactUs.delegate = self
        view.addSubview(helpContactUs)
        helpContactUs.snp.makeConstraints{ (make) in
            make.bottom.left.right.equalTo(self.view)
            make.height.equalTo(50)
        }
    }
    
    func showContactUs(){
        contactUsVC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        contactUsVC?.surfaceView.cornerRadius = 8.0
        contactUsVC?.surfaceView.shadowHidden = false
        contactUsVC?.isRemovalInteractionEnabled = true
        contactUsVC?.delegate = self
        
        let contactVC = ContactUsVC()
        contactVC.delegate = self
        contactUsVC?.set(contentViewController: contactVC)
        
        
        self.present(contactUsVC!, animated: true, completion: nil)
    }
    
    private func hideContactUs() {
        if let contactUsVC = self.contactUsVC {
            contactUsVC.dismiss(animated: true, completion: nil)
        }
    }
}

extension HelpCenterTVC : HelpContactUsDelegate {
    func onContactUsPressed() {
        showContactUs()
    }
}

// MARK:- FloatingPanelControllerDelegate
extension HelpCenterTVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return IntrinsicPanelLayout()
    }
}

extension HelpCenterTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            requestHelp()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension HelpCenterTVC : HelpCenterView {
    func setBrowseHelpContent(list: [String]) {
        createBrowseHelp()
        browseHelpCell.setContent(content: list)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func showLoading() {
        if section.numberOfRows() == 0 {
            //            section.scrollEnabled(false)
            section.removeAllRows()
            createLoadingCell()
            section.appendRow(cell: loadingCell)
            loadingCell.updateHeight(self.view.bounds.height - self.topbarHeight)
            loadingCell.loadingIndicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.contentView.reloadData()
            }
        }
    }
    
    func hideLoading() {
        self.contentView.scrollEnabled(true)
        section.removeAllRows()
    }
    
    func createContactUs() {
        //        helpContactUs = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.helpContactUs.name) as? HelpContactUs
        //        section.appendRow(cell: helpContactUs)
        //        helpContactUs.delegate = self
    }
    
}

extension HelpCenterTVC : ContactUsVCDelegate {
    func onCloseContactPressed(){
        hideContactUs()
    }
}
