////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import Alamofire

protocol WishlistView: class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func setContent(wishListArray : [Wishlist])
    func updateWishlist(packageId:String, isWishlist:Bool)
}

class WishlistPresenter : MKPresenter {
    
    private weak var view: WishlistView?
    private var wishlistService: WishlistService?
    
    override init() {
        super.init()
        wishlistService = WishlistService()
    }
    
    func attachview(_ view: WishlistView) {
        self.view = view
    }
    
    func getWishlist() {
        view?.showLoadingView()
        wishlistService?.requestAllWishlist(success: { [weak self] (apiResponse) in
            self?.view?.hideLoadingView()
            let wishlistArray = Wishlist.with(jsons: apiResponse.data.arrayValue)
            if wishlistArray.count == 0 {
                self?.handleNoWishlist()
            } else {
                self?.view?.setContent(wishListArray: wishlistArray)
            }
            }, failure: { [weak self] (error) in
                self?.view?.hideLoadingView()
                if error.statusCode == 400 {
                    self?.handleNoWishlist()
                } else {
                    self?.view?.showEmptyView(withMessage: "\(error.message)", description: nil,
                        buttonTitle: NSLocalizedString("Try Again", comment: ""), emptyCellButtonType:.error)
                }
        })
    }
    
    func requestWishlist(packageId:String, isWishlist:Bool) {
        let editType:WishlistEditType = isWishlist ? .remove : .save
        wishlistService?.requestEditWishlist(packageId: packageId, wishlistEditType: editType, success: { [weak self] (apiResponse) in
            self?.view?.updateWishlist(packageId: packageId, isWishlist: !isWishlist)
            }, failure: { [weak self] (error) in
                self?.view?.updateWishlist(packageId: packageId, isWishlist: isWishlist)
        })
    }
    
    func handleNoWishlist() {
        view?.showEmptyView(withMessage: NSLocalizedString("You don’t have any wish list", comment: ""),
                           description: NSLocalizedString("Start searching and save your wishlist", comment: ""),
                           buttonTitle: NSLocalizedString("Start Browsing", comment: ""), emptyCellButtonType:.start)
    }
}
