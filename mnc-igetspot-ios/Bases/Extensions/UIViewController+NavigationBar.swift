////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    
    var topbarHeight: CGFloat {
        
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var tabbarHeight: CGFloat {
        
        return self.tabBarController?.tabBar.frame.height ?? 0.0
    }
    
    func setNavigationBarTitleColor(color:UIColor) {
        let textAttributes = [NSAttributedString.Key.foregroundColor:color,
                              NSAttributedString.Key.font : R.font.barlowMedium(size: 14)!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
}
