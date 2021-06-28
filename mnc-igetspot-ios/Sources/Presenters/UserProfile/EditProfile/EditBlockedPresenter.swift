//
//  EditBlockedPresenter.swift
//  mnc-igetspot-ios
//
//  Created by Handi Deyana on 02/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//


import Alamofire

protocol EditBlockedView: ParentProtocol {
    func removeSelf()
    func setContent(data: [BlockedMaster])
    func showEmpty()
    func showLoading()
    func hideLoading()
}

class EditBlockedPresenter : MKPresenter {
    
    private weak var blockedView: EditBlockedView?
    private var masterService: MasterService?

    
    override init() {
        super.init()
        masterService = MasterService()
    }
    
    func attachview(_ view: EditBlockedView) {
        self.blockedView = view
    }
    
    func unblockMaseter(id: String) {
        self.blockedView?.showLoading()
        masterService?.unblockMaster(masterID:id,
        success: { [weak self] (apiResponse) in
            self?.blockedView?.hideLoading()
            self?.self.getListBlocked()
        },
        failure:{[weak self] (error) in
            self?.blockedView?.hideLoading()
        })
    }
    
    func getListBlocked() {
        self.blockedView?.showLoading()
        masterService?.listBlockedMaster(
            success: { [weak self] (apiResponse) in
                self?.blockedView?.hideLoading()
                
                let blockedMaster :[BlockedMaster]? = try? JSONDecoder().decode([BlockedMaster].self, from: apiResponse.data.rawData())
                
                if blockedMaster?.count == 0 || blockedMaster == nil {
                    self?.blockedView?.showEmpty()
                } else  {
                    self?.blockedView?.setContent(data: blockedMaster!)
                }
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(kLoginNotificationName), object: nil)
                }
            },
            failure:{[weak self] (error) in
                self?.blockedView?.hideLoading()
                self?.blockedView?.showErrorMessage?("Cannot Get Data")
        })
    }
}

