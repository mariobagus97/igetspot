//
//  ReportProfileDetailVC.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 03/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftMessages

class ReportProfileDetailVC: MKViewController {
    
    var mPresenter = ReportProfileFormPresenter()
    let formView = UINib(nibName: R.nib.reportProfileFormPage.name, bundle: nil)
        .instantiate(withOwner: nil, options: nil).first as! ReportProfileFormPage
    var titleString: String?
    var isReportPackage: Bool = false
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addView()
        mPresenter.attachview(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Report Profile", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    func addView(){
        formView.setContent(title: titleString, subtitle: nil)
        self.view.addSubview(formView)

        formView.delegate = self

        formView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    func removeSelf(){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

extension ReportProfileDetailVC: ReportProfileFormView {
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

extension ReportProfileDetailVC: ReportProfileFormPageDelegate {
    func onReportButtonPressed(reasonString: String) {
        showAlertMessage(title: NSLocalizedString("Are you sure want to report?", comment: ""), message: NSLocalizedString("", comment:""), iconImage: nil, okButtonTitle: NSLocalizedString("Report", comment: ""), okAction: { [weak self] in
            SwiftMessages.hide()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if self!.isReportPackage {
                    self?.mPresenter.submitReportPackage(packageId: self!.id, title: self!.titleString!, reason: reasonString)
                } else {
                    self?.mPresenter.submitReportUser(idUser: self!.id, title: self!.titleString!, reason: reasonString)
                }
            }
            }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
                SwiftMessages.hide()
        })
    }
}
