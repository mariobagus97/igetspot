////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import DKImagePickerController

open class CustomUIDKImagePickerDelegate : DKImagePickerControllerBaseUIDelegate {
    
    override open func createDoneButtonIfNeeded() -> UIButton {
        if self.doneButton == nil {
            let button = UIButton(type: .custom)
            button.titleLabel?.font = R.font.barlowMedium(size: 14)
            button.setTitleColor(Colors.blueTwo, for: .normal)
            button.setTitleColor(Colors.placeholderGray, for: .disabled)
            button.addTarget(self.imagePickerController, action: #selector(DKImagePickerController.done), for: .touchUpInside)
            self.doneButton = button
        }
        
        return self.doneButton!
    }
    
    override open func updateDoneButtonTitle(_ button: UIButton) {
        if self.imagePickerController.selectedAssets.count > 0 {
            let buttonTitle = self.imagePickerController.singleSelect ? "Send" : String(format: "Send (%d)", self.imagePickerController.selectedAssets.count)
            button.setTitle(buttonTitle, for: .normal)
            button.isEnabled = true
        } else {
            button.setTitle("Send", for: .normal)
            button.isEnabled = false
        }
        
        button.sizeToFit()
    }
    
    override open func imagePickerController(_ imagePickerController: DKImagePickerController,
                                             showsCancelButtonForVC vc: UIViewController) {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = R.font.barlowMedium(size: 14)
        button.setTitleColor(Colors.blueTwo, for: .normal)
        button.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        button.addTarget(imagePickerController, action: #selector(imagePickerController.dismiss as () -> Void), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        
        vc.navigationItem.leftBarButtonItem = barButtonItem
    }
    
}
