////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MasterDetailSectionTitleTableViewCell: MKTableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.isSkeletonable = true
    }
    
    // MARK: - Public Functions
    func showLoadingView() {
        titleLabel.showAnimatedGradientSkeleton()
    }
    
    func hideLoadingView() {
        titleLabel.hideSkeleton()
    }
    
}
