////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol HistoryOrderView:class {
    func showLoadingView()
    func hideLoadingView()
    func setContent(orderHistoryArray : [OrderHistoryV2])
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType? )
}

class HistoryOrderPresenter: MKPresenter {
    private weak var historyOrderView: HistoryOrderView?
    private var orderService: OrderService?
    
    override init() {
        super.init()
        orderService = OrderService()
    }
    
    func attachview(_ view: HistoryOrderView) {
        self.historyOrderView = view
    }
    
    func getHistoryOrderList() {
        historyOrderView?.showLoadingView()
        orderService?.requestHistoryOrderList(success: { [weak self] (apiResponse) in
            self?.historyOrderView?.hideLoadingView()
            var orderResponseV2 :[OrderResponseV2]? = [OrderResponseV2]()
            
            orderResponseV2 = try? JSONDecoder().decode([OrderResponseV2].self, from: apiResponse.data.rawData())
            
            guard let res = orderResponseV2 else {
                return
            }
            
            if res.isEmpty {
                self?.handleNoHistoryOrder()
            } else {
                var history = [OrderHistoryV2]()
                
                for item in res {
                    item.masterList?.forEach{master in
                        let newObj = OrderHistoryV2(masterID: master.masterID, masterName:master.masterName, masterOf: master.masterOf, orderID: item.orderID, masterImageURL: master.masterImageURL, masterServicesList: master.masterServicesList )
                        history.append(newObj)
                    }
                }
                self?.historyOrderView?.setContent(orderHistoryArray: history)
            }
            }, failure: { [weak self] (error) in
                self?.historyOrderView?.hideLoadingView()
                if error.statusCode == 400 {
                    self?.handleNoHistoryOrder()
                } else {
                    self?.historyOrderView?.showEmptyView(withMessage: "\(error.message)",
                        description: nil,
                        buttonTitle: NSLocalizedString("Try Again", comment: ""),
                        emptyCellButtonType:.error)
                }
        })
    }
    
    func handleNoHistoryOrder() {
        historyOrderView?.showEmptyView(withMessage: NSLocalizedString("You don’t have any list of order history", comment: ""),
                                        description: NSLocalizedString("Start searching and doing business with us", comment: ""),
                                        buttonTitle: NSLocalizedString("Start Order", comment: ""), emptyCellButtonType:.start)
    }
    
}
