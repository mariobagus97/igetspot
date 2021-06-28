////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func shareMaster(withText:String, linkUrl:String, sender:UIView) {
        guard let linkURL = URL(string: linkUrl) else {
            return
        }
        let firstActivityItem = withText
        let secondActivityItem = linkURL
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = sender
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = []
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            .print,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
