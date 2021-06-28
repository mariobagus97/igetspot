//
//  FavoritePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/19/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol FavoriteView: class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func setContent(favoriteArray : [Favorite])
    func updateFavoriteButton(masterId:String, isFavorite:Bool)
    func showFavoriteLoadingHUD()
    func hideFavoriteLoadingHUD()
    func showMessageError(message:String)
    func goToChatRoom(channelUrl:String, opponentId:String, profileImageUrl:String, nickName:String, phoneNumber:String)
}

class FavoritePresenter : MKPresenter {
    
    private weak var favoriteView: FavoriteView?
    private var favoriteService:FavoriteService?
    private var chatService:ChatService?
    
    override init() {
        super.init()
        favoriteService = FavoriteService()
        chatService = ChatService()
    }
    
    func attachview(_ view: FavoriteView) {
        self.favoriteView = view
    }
    
    func getFavorite() {
        favoriteView?.showLoadingView()
        favoriteService?.requestAllFavorites(success: { [weak self] (apiResponse) in
            self?.favoriteView?.hideLoadingView()
            let favorites = Favorite.with(jsons: apiResponse.data.arrayValue)
            if favorites.count == 0 {
                self?.handleNoFavorites()
            } else {
                self?.favoriteView?.setContent(favoriteArray: favorites)
            }
            }, failure: { [weak self] (error) in
                self?.favoriteView?.hideLoadingView()
                if error.statusCode == 400 {
                    self?.handleNoFavorites()
                } else {
                    self?.favoriteView?.showEmptyView(withMessage: "\(error.message)", description: nil,
                        buttonTitle: NSLocalizedString("Try Again", comment: ""),
                        emptyCellButtonType:.error)
                }
        })
    }
    
    func editFavorite(masterId:String, isFavorite:Bool) {
        let editType:FavoriteEditType = isFavorite ? .remove : .save
        favoriteService?.requestEditFavorites(masterId: masterId, favoriteEditType: editType, success: { [weak self] (apiResponse) in
            self?.favoriteView?.updateFavoriteButton(masterId: masterId, isFavorite: !isFavorite)
            }, failure: { [weak self] (error) in
                 self?.favoriteView?.updateFavoriteButton(masterId: masterId, isFavorite: isFavorite)
        })
    }
    
    func handleNoFavorites() {
        favoriteView?.showEmptyView(withMessage: NSLocalizedString("You don’t have any favorite", comment: ""),
                                    description: NSLocalizedString("Start searching and saved your favorites here", comment: ""),
                                    buttonTitle: NSLocalizedString("Start Browsing", comment: ""), emptyCellButtonType:.start)
    }
    
    func getChannelRoom(currentUserId:String, favorite:Favorite) {
        guard let opponentId = favorite.masterId else {
            return
        }
        favoriteView?.showFavoriteLoadingHUD()
        chatService?.requestChannelRoom(currentUserId: currentUserId, opponentId: opponentId, success: { [weak self] (apiResponse) in
            self?.favoriteView?.hideFavoriteLoadingHUD()
            let responseData = apiResponse.data
            if let channelUrl = responseData["channel_url"].string, channelUrl.isEmptyOrWhitespace() == false {
                let phoneNumber = responseData["phone_number"].stringValue
                let opponentId = responseData["user_id"].stringValue
                let profileImageUrl = responseData["profile_url"].stringValue
                let nickName = responseData["nickname"].stringValue
                self?.favoriteView?.goToChatRoom(channelUrl: channelUrl, opponentId: opponentId, profileImageUrl: profileImageUrl, nickName: nickName, phoneNumber: phoneNumber)
            } else {
                self?.favoriteView?.showMessageError(message: NSLocalizedString("Oops, something went wrong, please try again", comment: ""))
            }
            }, failure: { [weak self] (error) in
                self?.favoriteView?.hideFavoriteLoadingHUD()
                self?.favoriteView?.showMessageError(message: error.message)
        })
    }
}
