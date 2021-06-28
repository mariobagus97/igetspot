//
//  BlockProfilePresenter.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 10/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol BlockProfileView: ParentProtocol {
    func removeSelf()
}

class BlockProfilePresenter: MKPresenter {
    private weak var blockProfileView: BlockProfileView?
    private var blockService: BlockReportService?
    
    override init() {
        super.init()
        blockService = BlockReportService()
    }
    
    func attachview(_ view: BlockProfileView) {
        self.blockProfileView = view
    }
    
    func submitBlockUser(userId: String, name: String) {
        self.blockProfileView?.showLoading()
        blockService?.blockUser(userId: userId, success: { [weak self] (apiResponse) in
            self?.blockProfileView?.hideLoading()
            self?.blockProfileView?.showSuccessMessage?(NSLocalizedString("\(name) has been blocked", comment: ""))
            self?.blockProfileView?.removeSelf()
            }, failure: { [weak self] (error) in
                self?.blockProfileView?.hideLoading()
                self?.blockProfileView?.showErrorMessage?(NSLocalizedString("\(error.message)", comment: ""))
        })
    }
}
