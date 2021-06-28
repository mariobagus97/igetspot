//
//  MenuVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/19/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import LGSideMenuController
import SwiftMessages

protocol MenuVCDelegate{
    func onCloseMenu()
}

class MenuVC : MKViewController {
    
    var delegate : MenuVCDelegate!
    
    var menuPageView: SideMenuPageView = {
        let menuPageView = SideMenuPageView()
        return menuPageView
    }()
    
    var mPresenter = SignOutPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        addLGNotification()
        menuPageView.setupMenuView()
        menuPageView.delegate = self
        view.addSubview(menuPageView)
        menuPageView.snp.makeConstraints{ (make) in
            make.bottom.top.left.right.equalTo(self.view)
        }
        
        let listMenu = buildListMenu()
        menuPageView.setContent(withMenuItems: listMenu)
        
        self.mPresenter.attachview(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func buildListMenu() -> [MenuItems] {
        var listMenu = [MenuItems]()
        listMenu.append(MenuItems(item: MenuItem.About.value, icon: MenuItem.About.icon))
        listMenu.append(MenuItems(item: MenuItem.Favorite.value, icon: MenuItem.Favorite.icon))
        listMenu.append(MenuItems(item: MenuItem.Wishlist.value, icon: MenuItem.Wishlist.icon))
        listMenu.append(MenuItems(item: MenuItem.HelpCenter.value, icon: MenuItem.HelpCenter.icon))
        listMenu.append(MenuItems(item: MenuItem.TAndC.value, icon: MenuItem.TAndC.icon))
        listMenu.append(MenuItems(item: MenuItem.Settings.value, icon: MenuItem.Settings.icon))
        listMenu.append(MenuItems(item: MenuItem.SignIn.value, icon: MenuItem.SignIn.icon))
        return listMenu
    }
    
    @objc func refreshPage() {
        if (TokenManager.shared.isLogin()) {
            if let user = UserProfileManager.shared.getUser() {
                let profileImageUrl = user.avatar
                let firstName = user.firstname
                let lastName = user.lastname
                let fullName = firstName.isEmpty ? lastName : "\(firstName) \(lastName)"
                let totalBalance = "\(user.balance)".currency
                menuPageView.showProfile(withImageUrl: profileImageUrl, withName: fullName, andBalance: totalBalance)
            } else {
                menuPageView.showProfile(withImageUrl: "", withName: "", andBalance: "0")
            }
        } else {
            menuPageView.hideProfile()
        }
    }
    
    private func addLGNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPage), name: NSNotification.Name.LGSideMenuWillShowLeftView, object: nil)
    }
}

extension MenuVC: SideMenuPageViewDelegate {
    func closeMenuClicked() {
        delegate.onCloseMenu()
    }
    
    func menuProfileDidClicked() {
        if (TokenManager.shared.isLogin()) {
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true, completionHandler: {
                let tabbarController = mainViewController.rootViewController as! MainPageTabBarController
                let navigationController = tabbarController.selectedViewController as! UINavigationController
                let profileTVC = ProfileTVC()
                profileTVC.hidesBottomBarWhenPushed = true
                navigationController.pushViewController(profileTVC, animated: true)
            })
        }
    }
    
    func menuAboutDidClicked() {
        let mainViewController = sideMenuController!
        mainViewController.hideLeftView(animated: true, completionHandler: {
            let tabbarController = mainViewController.rootViewController as! MainPageTabBarController
            let navigationController = tabbarController.selectedViewController as! UINavigationController
            let aboutVC = AboutVC()
            aboutVC.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(aboutVC, animated: true)
        })
    }
    
    func menuFavoriteDidClicked() {
        if (TokenManager.shared.isLogin()) {
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true, completionHandler: {
                let tabbarController = mainViewController.rootViewController as! MainPageTabBarController
                let navigationController = tabbarController.selectedViewController as! UINavigationController
                let favoriteTVC = FavoriteTVC()
                favoriteTVC.hidesBottomBarWhenPushed = true
                navigationController.pushViewController(favoriteTVC, animated: true)
            })
        } else {
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true, completionHandler: {
                self.goToLoginScreen(afterLoginScreenType: .favorite, afterLoginParameter: nil)
            })
        }
        
    }
    
    func menuWishlistDidClicked() {
        if (TokenManager.shared.isLogin()) {
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true, completionHandler: {
                let tabbarController = mainViewController.rootViewController as! MainPageTabBarController
                let navigationController = tabbarController.selectedViewController as! UINavigationController
                let wishlistTVC = WishlistTVC()
                wishlistTVC.hidesBottomBarWhenPushed = true
                navigationController.pushViewController(wishlistTVC, animated: true)
            })
        } else {
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true, completionHandler: {
                self.goToLoginScreen(afterLoginScreenType: .wishlist, afterLoginParameter: nil)
            })
        }
    }
    
    func menuContactUsDidClicked() {
        let mainViewController = sideMenuController!
        mainViewController.hideLeftView(animated: true, completionHandler: {
            let tabbarController = mainViewController.rootViewController as! MainPageTabBarController
            let navigationController = tabbarController.selectedViewController as! UINavigationController
            let helpCenterVC = HelpCenterVC()
            helpCenterVC.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(helpCenterVC, animated: true)
        })
    }
    
    func menuTermsConditionDidClicked() {
        let mainViewController = sideMenuController!
        mainViewController.hideLeftView(animated: true, completionHandler: {
            let tabbarController = mainViewController.rootViewController as! MainPageTabBarController
            let navigationController = tabbarController.selectedViewController as! UINavigationController
            let privacyPolicyVC = PrivacyPolicyVC()
            privacyPolicyVC.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(privacyPolicyVC, animated: true)
        })
    }
    
    func menuSettingsDidClicked() {
        let mainViewController = sideMenuController!
        mainViewController.hideLeftView(animated: true, completionHandler: {
            let tabbarController = mainViewController.rootViewController as! MainPageTabBarController
            let navigationController = tabbarController.selectedViewController as! UINavigationController
            let settingsVC = SettingsVC()
            settingsVC.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(settingsVC, animated: true)
        })
    }
    
    func menuSignInClicked() {
        let mainViewController = sideMenuController!
        mainViewController.hideLeftView(animated: true, completionHandler: {
            self.goToLoginScreen(afterLoginScreenType: .none, afterLoginParameter: nil)
        })
    }
}

extension MenuVC : SignOutView {
    func showLoading() {
        showLoadingHUD()
    }
    
    func hideLoading() {
        hideLoadingHUD()
    }
    
    func showErrorMessage(_ message: String) {
        showErrorMessageBanner(message)
    }
    
}
