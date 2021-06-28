////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

class MigrationManager: NSObject {

    func prepareDefaultPreferencesForFreshInstall() {
        TokenManager.shared.clearDataKeychain()
    }
    
}
