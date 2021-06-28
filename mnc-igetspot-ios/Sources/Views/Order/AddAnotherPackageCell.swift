////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol AddAnotherPackageCellDelegate:class {
    func addAnotherPackageCellDidClicked()
}

class AddAnotherPackageCell: MKTableViewCell {
    
    @IBOutlet weak var addAnotherPackageButton: UIButton!
    weak var delegate:AddAnotherPackageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func onSelected() {
        delegate?.addAnotherPackageCellDidClicked()
    }
    
    // MARK: - Actions
    @IBAction func addAnotherPackageButtonDidClicked() {
        
    }
    
}
