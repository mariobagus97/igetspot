//
//  DeleteOrderVC.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 04/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol DeleteOrderVCDelegate:class {
    func deleteOrderCloseButtonDidClicked()
    func deleteOrderAndSaveToFavorites(packageId:String, masterId:String)
    func deleteOrder(packageId:String, masterId:String)
}


class DeleteOrderVC: MKViewController {
    
    var headerView: FloatingPanelHeaderView!
    var deleteOrderView: DeleteOrderView!
    var packageId:String?
    var masterId:String?
    weak var delegate: DeleteOrderVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    // MARK: - Private Funtions
    private func addViews() {
        headerView = FloatingPanelHeaderView()
        headerView.delegate = self
        headerView.titleLabel.text = NSLocalizedString("Delete Item", comment: "")
        headerView.setIconTitle(image: R.image.deleteColorSmall())
        view.addSubview(headerView)
        
        deleteOrderView = DeleteOrderView()
        deleteOrderView.delegate = self
        view.addSubview(deleteOrderView)
        
        headerView.snp.makeConstraints{ (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        deleteOrderView.snp.makeConstraints{ (make) in
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo((headerView?.snp.bottom)!).offset(0)
        }
    }
}

// MARK: - FloatingPanelHeaderViewDelegate
extension DeleteOrderVC: FloatingPanelHeaderViewDelegate {
    func panelHeaderCloseButtonDidClicked() {
        delegate?.deleteOrderCloseButtonDidClicked()
    }
}


// MARK: - DeleteOrderViewDelegate
extension DeleteOrderVC: DeleteOrderViewDelegate {
    func deleteAndSaveFavoriteButtonDidClicked() {
        guard let masterId = self.masterId, let packageId = self.packageId else{
            return
        }
        delegate?.deleteOrderAndSaveToFavorites(packageId: packageId, masterId: masterId)
    }
    
    func deleteButtonDidClicked() {
        guard let masterId = self.masterId, let packageId = self.packageId else{
            return
        }
        delegate?.deleteOrder(packageId: packageId, masterId: masterId)
    }
    
    
}
