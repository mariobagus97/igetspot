////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

let kRefreshDataUserProfileNotificationName = "RefreshDataUserProfileNotification"

class UserProfileManager {
    static let shared = UserProfileManager()
    var profileService = ProfileService()
    var editProfileService = EditProfileService()
    
    fileprivate init() { //This prevents others from using the default '()' initializer for this class.
    }
    
    func requestProfileUser(completion: ((Bool) -> Void)? = nil) {
        if (TokenManager.shared.isLogin()) {
            
            profileService.requestProfile({ (apiProfileResponse) in
                DataManager.shared.deleteAll(UserData.self)
                let user = UserData.init(withJSON: apiProfileResponse.data)
                DataManager.shared.add(user)
                NotificationCenter.default.post(name: NSNotification.Name(kRefreshDataUserProfileNotificationName), object: nil)
                completion?(true)
//                var profileJSON = apiProfileResponse.data
//                self.editProfileService.requestUserBankDetail(success: {(apiResponse) in
//                    DataManager.shared.deleteAll(User.self)
//                    do {
//                        let mergedJson = try profileJSON.merged(with: apiResponse.data)
//                        let user = User.init(withJSON: mergedJson)
//                        DataManager.shared.add(user)
//                        NotificationCenter.default.post(name: NSNotification.Name(kRefreshDataUserProfileNotificationName), object: nil)
//                        completion?(true)
//                    } catch {
//                        completion?(false)
//                    }
//                }, failure: {(error) in
//                    completion?(false)
//                })
                }, failure: {(error) in
                    PrintDebug.printDebugService(error, message: "requestProfileUser error")
                    completion?(false)
            })
        } else {
            completion?(true)
        }
    }
    
    func getUser() -> UserData? {
        return DataManager.shared.objects(UserData.self)?.first
    }
    
    func updateUserLevelToMaster() {
        DataManager.shared.runTransaction {
            if let user = DataManager.shared.objects(UserData.self)?.first {
                user.isMaster = true
            }
        }
    }
}
