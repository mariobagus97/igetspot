//
//  MasterDetailProfilePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/16/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol MasterDetailView:class {
    func showLoadingView()
    func hideLoadingView()
    func setContent(masterDetail: MasterDetail)
    func showEmptyView()
    func setLoadingFavoriteButton(isLoading:Bool)
    func setFavorite(isFavorite:Bool)
    func showMasterDetailLoadingHUD()
    func hideMasterDetailLoadingHUD()
    func showMessageError(message:String)
    func goToChatRoom(channelUrl:String, opponentId:String, profileImageUrl:String, nickName:String, phoneNumber:String)
}

class MasterDetailProfilePresenter : MKPresenter {
    
    private weak var masterView: MasterDetailView?
    private var masterService: MasterService?
    private var favoriteService: FavoriteService?
    private var chatService: ChatService?
    
    override init() {
        super.init()
        masterService = MasterService()
        favoriteService = FavoriteService()
        chatService = ChatService()
    }
    
    func attachview(_ view: MasterDetailView) {
        self.masterView = view
    }
    
    func getMasterDetail(forMasterId masterId: String) {
        let userId = TokenManager.shared.getUserId() ?? ""
        masterView?.showLoadingView()
        masterService?.requestMasterDetail(userId: userId, masterId: masterId, success: { [weak self] (apiResponse) in
            self?.masterView?.hideLoadingView()
            let masterDetail = MasterDetail.with(json: apiResponse.data)
            self?.masterView?.setContent(masterDetail: masterDetail)
            }, failure: { [weak self] (error) in
                self?.masterView?.hideLoadingView()
                self?.masterView?.showEmptyView()
        })
    }
    
    func requestFavorite(forMasterId masterId:String, isFavorite:Bool) {
        let editType:FavoriteEditType = isFavorite ? .remove : .save
        self.masterView?.setLoadingFavoriteButton(isLoading: true)
        favoriteService?.requestEditFavorites(masterId: masterId, favoriteEditType: editType, success: { [weak self] (apiResponse) in
                self?.masterView?.setFavorite(isFavorite: !isFavorite)
            }, failure: { [weak self] (error) in
                self?.masterView?.setLoadingFavoriteButton(isLoading: false)
        })
    }
    
    func getChannelRoom(currentUserId:String, opponentId:String) {
        masterView?.showMasterDetailLoadingHUD()
        chatService?.requestChannelRoom(currentUserId: currentUserId, opponentId: opponentId, success: { [weak self] (apiResponse) in
                self?.masterView?.hideMasterDetailLoadingHUD()
                let responseData = apiResponse.data
            if let channelUrl = responseData["channel_url"].string, channelUrl.isEmptyOrWhitespace() == false {
                let phoneNumber = responseData["phone_number"].stringValue
                let opponentId = responseData["user_id"].stringValue
                let profileImageUrl = responseData["profile_url"].stringValue
                let nickName = responseData["nickname"].stringValue
                self?.masterView?.goToChatRoom(channelUrl: channelUrl, opponentId: opponentId, profileImageUrl: profileImageUrl, nickName: nickName, phoneNumber: phoneNumber)
            } else {
                self?.masterView?.showMessageError(message: NSLocalizedString("Oops, something went wrong, please try again", comment: ""))
            }
            
            }, failure: { [weak self] (error) in
                self?.masterView?.hideMasterDetailLoadingHUD()
                self?.masterView?.showMessageError(message: error.message)
        })
    }
}
