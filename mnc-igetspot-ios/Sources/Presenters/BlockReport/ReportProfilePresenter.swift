//
//  ReportProfilePresenter.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 03/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol ReportProfileView:class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView(withMessage message:String)
    func setContent(itemLists : [String])
}

class ReportProfilePresenter: MKPresenter {
    
    private weak var reportProfileView: ReportProfileView?
    
    let contentReportProfile = ["Fake Name / Account",
                                "Posting inappropriate thing",
                                "Something Else"]
    let contentReportPackage = ["Copyright",
                                "Posting inappropriate thing",
                                "Package description",
                                "Something else"]
    
    override init() {
        super.init()
        
    }
    
    func attachview(_ view: ReportProfileView) {
        self.reportProfileView = view
    }
    
    func getReportProfileItem() {
        reportProfileView?.showLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.contentReportProfile.count == 0 {
                self.reportProfileView?.showEmptyView(withMessage: NSLocalizedString("No Report Item Available", comment: ""))
            } else {
                self.reportProfileView?.hideLoadingView()
                self.reportProfileView?.setContent(itemLists: self.contentReportProfile)
            }
        }
    }
    
    func getReportPackageItem() {
        reportProfileView?.showLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.contentReportPackage.count == 0 {
                self.reportProfileView?.showEmptyView(withMessage: NSLocalizedString("No Report Item Available", comment: ""))
            } else {
                self.reportProfileView?.hideLoadingView()
                self.reportProfileView?.setContent(itemLists: self.contentReportPackage)
            }
        }
    }
}
