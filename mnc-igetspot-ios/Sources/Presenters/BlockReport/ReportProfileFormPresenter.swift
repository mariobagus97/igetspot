//
//  ReportProfileFormPresenter.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 03/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol ReportProfileFormView: ParentProtocol {
    func removeSelf()
}

class ReportProfileFormPresenter : MKPresenter {
    
    private weak var reportProfileFormView: ReportProfileFormView?
    private var reportService: BlockReportService?
    
    override init() {
        super.init()
        reportService = BlockReportService()
    }
    
    func attachview(_ view: ReportProfileFormView) {
        self.reportProfileFormView = view
    }
    
    func submitReportUser(idUser: String, title: String, reason: String) {
        self.reportProfileFormView?.showLoading()
        if reason.count > 30 {
            reportService?.reportUser(userId: idUser, title: title, desc: reason, success: { [weak self] (apiResponse) in
                self?.reportProfileFormView?.hideLoading()
                self?.reportProfileFormView?.showSuccessMessage?(NSLocalizedString("Your report has been sent", comment: ""))
                self?.reportProfileFormView?.removeSelf()
                }, failure: { [weak self] (error) in
                    self?.reportProfileFormView?.hideLoading()
                    self?.reportProfileFormView?.showErrorMessage?(NSLocalizedString("\(error.message)", comment: ""))
            })
        } else {
            self.reportProfileFormView?.hideLoading()
            self.reportProfileFormView?.showErrorMessage?(NSLocalizedString("Your reason must have at least 30 character.", comment: ""))
        }
    }
    
    func submitReportPackage(packageId: String,title: String, reason: String) {
        self.reportProfileFormView?.showLoading()
        if reason.count > 30 {
            reportService?.reportPackage(packageId: packageId, title: title, desc: reason, success: { [weak self] (apiResponse) in
                self?.reportProfileFormView?.hideLoading()
                self?.reportProfileFormView?.showSuccessMessage?(NSLocalizedString("Your report has been sent", comment: ""))
                self?.reportProfileFormView?.removeSelf()
                }, failure: { [weak self] (error) in
                    self?.reportProfileFormView?.hideLoading()
                    self?.reportProfileFormView?.showErrorMessage?(NSLocalizedString("\(error.message)", comment: ""))
            })
        } else {
            self.reportProfileFormView?.hideLoading()
            self.reportProfileFormView?.showErrorMessage?(NSLocalizedString("Your reason must have at least 30 character.", comment: ""))
        }
    }
}
