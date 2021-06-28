//
//  MenuItem.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/11/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class MenuItems {
    var item : String
    var icon : UIImage?
    
    init(item: String, icon: UIImage?) {
        self.item = item
        self.icon = icon
    }
    
    func getItem() -> String{
        return self.item
    }
    
    func getIcon() -> UIImage? {
        return self.icon
    }
    
}

enum MenuItem {
    case About
    case Favorite
    case Wishlist
    case HelpCenter
    case TAndC
    case Settings
    case SignIn
    
    var value: String{
        switch self{
        case .Favorite:
            return "Favorite"
        case .Wishlist:
            return "Wishlist"
        case .HelpCenter:
            return "Help Center"
        case .TAndC:
            return "Terms & Condition"
        case .Settings:
            return "Setting"
        case .About:
            return "About i get Spot"
        case .SignIn:
            return "Sign In"
        }
    }
    
    var icon: UIImage? {
        switch self{
        case .Favorite:
            return  R.image.menuFavorite()
        case .Wishlist:
            return R.image.menuWishlist()
        case .HelpCenter:
            return R.image.menuHelpCenter()
        case .TAndC:
            return R.image.menuTnC()
        case .Settings:
            return  R.image.menuSettings()
        case .About:
            return nil
        case .SignIn:
            return R.image.menuSignIn()
        }
    }
}
