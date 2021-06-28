////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import Alamofire

protocol RequestOrderView: class {
    func showLoadingView()
    func hideLoadingView()
    func showOrderLoadingHUD()
    func hideOrderLoadingHUD()
    func showMessageSuccess(message:String)
    func showMessageError(message:String)
    func setContent(orderRequestArray : [OrderRequest])
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func handleOrderSuccess()
}

class RequestOrderPresenter: MKPresenter {
    
    private weak var requestOrderView: RequestOrderView?
    private var orderService: OrderService?
    private var favoriteService: FavoriteService?
    
    override init() {
        super.init()
        orderService = OrderService()
        favoriteService = FavoriteService()
    }
    
    func attachview(_ view: RequestOrderView) {
        self.requestOrderView = view
    }
    
    func getRequestOrderList() {
        requestOrderView?.showLoadingView()
        orderService?.requestOrderDraftList(success: { [weak self] (apiResponse) in
            self?.requestOrderView?.hideLoadingView()
            let orderRequestArray = OrderRequest.with(jsons: apiResponse.data.arrayValue)
            if orderRequestArray.isEmpty {
                self?.handleNoRequestOrder()
            } else {
                self?.requestOrderView?.setContent(orderRequestArray: orderRequestArray)
            }
            }, failure: { [weak self] (error) in
                self?.requestOrderView?.hideLoadingView()
                if error.statusCode == 400 {
                    self?.handleNoRequestOrder()
                } else {
                    self?.requestOrderView?.showEmptyView(withMessage: "\(error.message)", description: nil,
                        buttonTitle: NSLocalizedString("Try Again", comment: ""),
                        emptyCellButtonType:.error)
                }
        })
    }
    
    func deletePackageOrder(packageId:String) {
        requestOrderView?.showOrderLoadingHUD()
        orderService?.requestDeleteOrderPackage(packageId: packageId, success: { [weak self] (apiResponse) in
            self?.requestOrderView?.hideOrderLoadingHUD()
            self?.requestOrderView?.showMessageSuccess(message: NSLocalizedString("Package has been deleted", comment: ""))
            self?.getRequestOrderList()
            }, failure: { [weak self] (error) in
                self?.requestOrderView?.hideOrderLoadingHUD()
                self?.requestOrderView?.showMessageError(message: error.message)
        })
    }
    
    func deletePackageOrderAndSaveToFavorite(packageId:String, masterId:String) {
        requestOrderView?.showOrderLoadingHUD()
        orderService?.requestDeleteOrderPackage(packageId: packageId, success: { [weak self] (apiResponse) in
            self?.getRequestOrderList()
            self?.favoriteService?.requestEditFavorites(masterId: masterId, favoriteEditType: .save, success: { [weak self] (apiResponse) in
                self?.requestOrderView?.hideOrderLoadingHUD()
                self?.requestOrderView?.showMessageSuccess(message: NSLocalizedString("Package has been deleted and add to favorites", comment: ""))
                }, failure: { [weak self] (error) in
                    self?.requestOrderView?.hideOrderLoadingHUD()
                    self?.requestOrderView?.showMessageError(message:error.message)
            })
            }, failure: { [weak self] (error) in
                self?.requestOrderView?.hideOrderLoadingHUD()
                self?.requestOrderView?.showMessageError(message:error.message)
        })
    }
    
    func requestSubmitOrder(orderRequestArray:[OrderRequest]) {
        let parameters = buildParameters(orderRequestArray: orderRequestArray)
        requestOrderView?.showOrderLoadingHUD()
        orderService?.requestSubmitOrder(parameters: parameters, success: { [weak self] (apiResponse) in
            self?.requestOrderView?.hideOrderLoadingHUD()
            self?.requestOrderView?.handleOrderSuccess()
            }, failure: { [weak self] (error) in
                self?.requestOrderView?.hideOrderLoadingHUD()
                self?.requestOrderView?.showMessageError(message:error.message)
        })
    }
    
    func buildParameters(orderRequestArray : [OrderRequest]) -> Parameters {
        var parameters = [String]()
        
        for orderRequest in orderRequestArray {
            if let packageArray = orderRequest.orderPackageArray {
                for package in packageArray {
                    if let packageId = package.packageId, package.isSelected {
                        parameters.append(packageId)
                    }
                }
            }
        }
        
        return parameters.asParameters()
    }
    
    func handleNoRequestOrder() {
        requestOrderView?.showEmptyView(withMessage: NSLocalizedString("You don't have any order request yet", comment: ""),
                                    description: NSLocalizedString("Need a creative service?", comment: ""),
                                    buttonTitle: NSLocalizedString("Start Order", comment: ""), emptyCellButtonType:.start)
    }
}
