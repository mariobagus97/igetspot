//
//  MasterDetailMoreVC.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 02/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit
import SwiftMessages

class MasterDetailMoreVC: MKViewController {
    
    var morePage: MorePage!
    var masterDetail:MasterDetail?
    
    var mPresenter = BlockProfilePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustLayout()
        setupNavigationBar()
        addViews()
        mPresenter.attachview(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationController?.presentIGSNavigationBar()
     }
     
    
     override func setupNavigationBar() {
         setupNavigationBarTitle(NSLocalizedString("Manage", comment: ""))
         setupLeftBackBarButtonItems(barButtonType: .backButton)
     }
    
    func addViews() {
        morePage  = UINib(nibName: R.nib.morePage.name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MorePage
        view.addSubview(morePage)
        morePage.delegate = self
        morePage.snp.makeConstraints{ (make) in
            make.bottom.top.left.right.equalTo(self.view)
        }
    }
    
    func removeSelf(){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

extension MasterDetailMoreVC: MorePageDelegate {
    func didReportProfileViewPressed() {
        let reportProfileTVC = ReportProfileTVC(title: "Report Profile")
        reportProfileTVC.userId = self.masterDetail?.masterId
        navigationController?.pushViewController(reportProfileTVC, animated: true)
    }
    
    func didBlockProfileViewPressed() {
        if let name = masterDetail?.masterName {
            showAlertMessage(title: NSLocalizedString("Block \(name)?", comment: ""), message: NSLocalizedString("You can unblock users through the menu on your profile page", comment:""), iconImage: nil, okButtonTitle: NSLocalizedString("Block", comment: ""), okAction: { [weak self] in
                SwiftMessages.hide()
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(kLoginNotificationName), object: nil)
                }
                self?.mPresenter.submitBlockUser(userId: (self?.masterDetail?.masterId)!, name: name)
                }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
                    SwiftMessages.hide()
            })
        }
    }
}

extension MasterDetailMoreVC: BlockProfileView {
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
}
