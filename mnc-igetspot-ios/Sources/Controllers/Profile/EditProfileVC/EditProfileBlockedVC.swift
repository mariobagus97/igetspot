//
//  EditProfileBlockedVC.swift
//  mnc-igetspot-ios
//
//  Created by Handi Deyana on 02/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//


import UIKit
import SwiftMessages



class EditProfileBlockedVC : MKTableViewController{
    
    var section = MKTableViewSection()
    var emptyCell: IGSEmptyCell!
    var blockedCell: BlockedCell!
    let blockedHeader = UINib(nibName: "BlockedHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BlockedHeader
    
    var editBlockedPresenter = EditBlockedPresenter()
    let editBlockedView = UINib(nibName: "EditBlockedPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditBlockedPage
    
    var listBlockedCell = [BlockedCell]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        editBlockedPresenter.attachview(self)
        editBlockedPresenter.getListBlocked()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Edit Blocked Account", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func setupTableViewStyles() {
        super.setupTableViewStyles()
    }
    
    override func registerNibs() {
        contentView.registeredCellIdentifiers.append(R.nib.blockedCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
    }
    
    override func createSections() {
        super.createSections()
        section.header = blockedHeader
        section.headerHeight = blockedHeader.bounds.height
        contentView.sections.append(section)
    }
    
    override func createRows() {
        super.createRows()        
    }
    
    func addView(){
        self.view.addSubview(editBlockedView)
    }
    
    func createBlockedCell(items: [BlockedMaster]){
        for item in items {
            blockedCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.blockedCell.name) as? BlockedCell
            blockedCell.delegate = self
            blockedCell.setContent(master: item)
            listBlockedCell.append(blockedCell)
            section.appendRow(cell: blockedCell)
        }
        contentView.reloadData()
    }
    
    // MARK:- Private Functions
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    
    
    func showSuccess(){
        
        var config = SwiftMessages.Config()
        
        // Slide up from the bottom.
        config.presentationStyle = .bottom
        
        // Display in a window at the specified window level: UIWindow.Level.statusBar
        // displays over the status bar while UIWindow.Level.normal displays under.
        config.presentationContext = .window(windowLevel: .init(100))
        
        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: 4)
        
        // Dim the background like a popover view. Hide when the background is tapped.
        config.dimMode = .gray(interactive: true)
        
        // Disable the interactive pan-to-hide gesture.
        config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        config.eventListeners.append() { event in
            if case .didHide = event { print("Success!") }
        }
        
        SwiftMessages.show(config: config, view: view)
    }
    
    
    func hideAlert() {
        dismiss(animated: true, completion: nil)
    }
    
    func removeSelf(){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func unblockUser(master: BlockedMaster){
       
    }
    
}

extension EditProfileBlockedVC : EditBlockedView {
    func showLoading() {
        showLoadingHUD()
    }
    
    func hideLoading() {
        hideLoadingHUD()
    }
    
    func showSuccessMessage(_ message: String) {
        showSuccessMessageBanner(message)
    }
    
    func showErrorMessage(_ message: String) {
        showErrorMessageBanner(message)
    }
    
    func showEmpty() {
        section.removeAllRows()
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: "", description: "Hooray there's no blocked master", buttonTitle: "", buttonType: .error)
        emptyCell.button.isHidden = true
        emptyCell.titleLabel.isHidden = true
        section.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(data: [BlockedMaster]){
        createBlockedCell(items: data)
    }
}

extension EditProfileBlockedVC: BlockedCellDelegate {
    func cellDidSelect(master: BlockedMaster) {
        guard let mastername = master.mastername else{
            return
        }
        showAlertMessage(title: "Unblock \(mastername)?", message: nil, iconImage: nil, okButtonTitle:"Unblock", okAction: { [weak self] in
            SwiftMessages.hide()
            guard let masterid = master.userID else{
                return
            }
            self?.editBlockedPresenter.unblockMaseter(id: masterid)
            }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
                SwiftMessages.hide()
        })
    }
}

extension EditProfileBlockedVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        debugPrint("Clicked")
    }
}
