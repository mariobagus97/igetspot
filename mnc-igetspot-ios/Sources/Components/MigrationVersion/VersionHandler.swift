////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import Version

class VersionManager: NSObject {
    
    func checkForUpdatedVersion() {
        
        guard let currentVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return
        }
        
        let installedVersionAppString = Preference.getString(key: PreferenceKeyConstants.versionNumberApp)
        
        let migrationManager = MigrationManager()
        if let installedVersion = installedVersionAppString, installedVersion.count > 0 {
            
            /*
            let version:Version = installedVersion
            // MIGRATION from version < v2.2.6
            if version < "" {
                
            } else {
                migrationManager.prepareDefaultPreferencesForFreshInstall()
            }
            */
            
            
        } else {
            // FRESH INSTALL
            migrationManager.prepareDefaultPreferencesForFreshInstall()
        }
        
        // Save the current bundle build to Preferences
        Preference.setString(key: PreferenceKeyConstants.versionNumberApp, value: currentVersionString)
        
    }

}
