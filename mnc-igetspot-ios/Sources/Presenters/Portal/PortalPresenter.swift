//
//  PortalPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/23/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import UIKit

protocol PortalView: class {
    func goToSignInPage()
    func setWalkthroughPage()
    func showUpdateAlert()
    func setHomePage()
    func showJailBreakAlert()
}

class PortalPresenter: MKPresenter {
    private weak var view: PortalView?
    
    override init() {
        super.init()
    }
    
    func attachview(_ view: PortalView) {
        self.view = view
    }
    
    func checkSession() {
        if DeviceIdHelper.isJailBrokenDevice() {
            self.view?.showJailBreakAlert()
        } else {
            if (TokenManager.shared.isLogin()) {
                self.view?.setHomePage()
            } else {
                self.setWalkthrough()
            }
        }
    }
    
    func isUpdatedVersion(){
        checkForUpdate { (isUpdate) in
            print("Update needed:\(isUpdate)")
            if isUpdate{
                DispatchQueue.main.async {
                    self.view?.showUpdateAlert()
                }
            }
        }
    }
    
    func checkForUpdate(completion:@escaping(Bool)->()){
        
        guard let bundleInfo = Bundle.main.infoDictionary,
            let currentVersion = bundleInfo["CFBundleShortVersionString"] as? String,
            let identifier = bundleInfo["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)")
            else{
                print("some thing wrong")
                completion(false)
                return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, resopnse, error) in
            if error != nil{
                completion(false)
                print("something went wrong")
            }else{
                do{
                    guard let reponseJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any],
                        let result = (reponseJson["results"] as? [Any])?.first as? [String: Any],
                        let version = result["version"] as? String
                        else{
                            completion(false)
                            return
                    }
                    print("Current Ver:\(currentVersion)")
                    print("Prev version:\(version)")
                    if currentVersion != version{
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
                catch{
                    completion(false)
                    print("Something went wrong")
                }
            }
        }
        task.resume()
    }
    
    func setWalkthrough() {
        guard let isSkipIntroduction = Preference.getBool(key: PreferenceKeyConstants.skipIntroduction) else {
            self.view?.setWalkthroughPage()
            return
        }
        if isSkipIntroduction {
            self.view?.goToSignInPage()
        } else {
            self.view?.setWalkthroughPage()
        }
        
    }
    
}
