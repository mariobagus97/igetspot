////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MasterDetailPackageDetailView:class {
    func showLoadingView()
    func hideLoadingView()
    func showPackageDetailLoadingHUD()
    func hidePackageDetailLoadingHUD()
    func setContent(packageDetail : PackageDetail)
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func setLoadingFavoriteButton(isLoading:Bool)
    func setLoadingWishlistButton(isLoading:Bool)
    func setWishlist(isWishlist:Bool)
    func setFavorite(isFavorite:Bool)
    func showMessageError(message:String)
    func goToOrderDetail(packageId: String, orderDetail:OrderDetail)
    func goToChatRoom(channelUrl:String, opponentId:String, profileImageUrl:String, nickName:String, phoneNumber:String)
}

class MasterDetailPackageDetailPresenter: MKPresenter {
    
    private weak var masterPackageDetailView: MasterDetailPackageDetailView?
    private var masterService: MasterService?
    private var wishlistService: WishlistService?
    private var favoriteService: FavoriteService?
    private var orderService: OrderService?
    private var chatService: ChatService?
    
    override init() {
        super.init()
        masterService = MasterService()
        wishlistService = WishlistService()
        favoriteService = FavoriteService()
        orderService = OrderService()
        chatService = ChatService()
    }
    
    func attachview(_ view: MasterDetailPackageDetailView) {
        self.masterPackageDetailView = view
    }
    
    func getPackageDetail(masterId:String, packageId:String) {
        let userId = TokenManager.shared.getUserId() ?? ""
        masterPackageDetailView?.showLoadingView()
        masterService?.requestMasterPackageDetail(userId: userId, masterId: masterId, packageId: packageId, success: { [weak self] (apiResponse) in
            self?.masterPackageDetailView?.hideLoadingView()
            let packageDetail = PackageDetail.with(json: apiResponse.data)
            self?.masterPackageDetailView?.setContent(packageDetail: packageDetail)
            }, failure: { [weak self] (error) in
                self?.masterPackageDetailView?.hideLoadingView()
                let errorMessage = error.statusCode == 400 ? NSLocalizedString("Package details not found", comment: "") : error.message
                self?.masterPackageDetailView?.showEmptyView(withMessage: errorMessage, description: nil,
                    buttonTitle: NSLocalizedString("Try Again", comment: ""),
                    emptyCellButtonType:.error)
        })
    }
    
    func requestFavorite(forMasterId masterId:String, isFavorite:Bool) {
        let editType:FavoriteEditType = isFavorite ? .remove : .save
        self.masterPackageDetailView?.setLoadingFavoriteButton(isLoading: true)
        favoriteService?.requestEditFavorites(masterId: masterId, favoriteEditType: editType, success: { [weak self] (apiResponse) in
            self?.masterPackageDetailView?.setFavorite(isFavorite: !isFavorite)
            }, failure: { [weak self] (error) in
                self?.masterPackageDetailView?.setLoadingFavoriteButton(isLoading: false)
        })
    }
    
    func requestWishlist(packageId:String, isWishlist:Bool) {
        let editType:WishlistEditType = isWishlist ? .remove : .save
        masterPackageDetailView?.setLoadingWishlistButton(isLoading: true)
        wishlistService?.requestEditWishlist(packageId: packageId, wishlistEditType: editType, success: { [weak self] (apiResponse) in
            self?.masterPackageDetailView?.setWishlist(isWishlist: !isWishlist)
            }, failure: { [weak self] (error) in
               self?.masterPackageDetailView?.setLoadingWishlistButton(isLoading: false)
        })
    }
    
    func requestOrderPackage(packageId:String) {
        masterPackageDetailView?.showPackageDetailLoadingHUD()
        orderService?.requestOrderDraft(packageId: packageId, success: { [weak self] (apiResponse) in
            self?.masterPackageDetailView?.hidePackageDetailLoadingHUD()
            let orderDetail = OrderDetail.with(json: apiResponse.data)
            self?.masterPackageDetailView?.goToOrderDetail(packageId: packageId, orderDetail: orderDetail)
            }, failure: { [weak self] (error) in
                self?.masterPackageDetailView?.hidePackageDetailLoadingHUD()
                self?.masterPackageDetailView?.showMessageError(message:error.message)
        })
    }
    
    
    func getChannelRoom(currentUserId:String, opponentId:String) {
        masterPackageDetailView?.showPackageDetailLoadingHUD()
        chatService?.requestChannelRoom(currentUserId: currentUserId, opponentId: opponentId, success: { [weak self] (apiResponse) in
            self?.masterPackageDetailView?.hidePackageDetailLoadingHUD()
            let responseData = apiResponse.data
            if let channelUrl = responseData["channel_url"].string, channelUrl.isEmptyOrWhitespace() == false {
                let phoneNumber = responseData["phone_number"].stringValue
                let opponentId = responseData["user_id"].stringValue
                let profileImageUrl = responseData["profile_url"].stringValue
                let nickName = responseData["nickname"].stringValue
                self?.masterPackageDetailView?.goToChatRoom(channelUrl: channelUrl, opponentId: opponentId, profileImageUrl: profileImageUrl, nickName: nickName, phoneNumber: phoneNumber)
            } else {
                self?.masterPackageDetailView?.showMessageError(message: NSLocalizedString("Oops, something went wrong, please try again", comment: ""))
            }
            
            }, failure: { [weak self] (error) in
                self?.masterPackageDetailView?.hidePackageDetailLoadingHUD()
                self?.masterPackageDetailView?.showMessageError(message: error.message)
        })
    }
}
