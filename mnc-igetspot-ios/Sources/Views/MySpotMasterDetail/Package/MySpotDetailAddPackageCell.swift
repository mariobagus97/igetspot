////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotDetailAddPackageCellDelegate:class {
    func addPackageCategoryButtonDidClicked()
}

class MySpotDetailAddPackageCell: MKTableViewCell {
    
    @IBOutlet weak var addButton: UIButton!
    weak var delegate: MySpotDetailAddPackageCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func addPackageButtonDidClickef() {
        delegate?.addPackageCategoryButtonDidClicked()
    }
    
}
