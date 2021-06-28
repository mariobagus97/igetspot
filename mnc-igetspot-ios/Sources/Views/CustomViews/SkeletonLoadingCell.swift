////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class SkeletonLoadingCell: MKTableViewCell {
    
    @IBOutlet weak var loadingXLabel: UILabel!
    @IBOutlet weak var loadingYLabel: UILabel!
    @IBOutlet weak var loadingZLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadingXLabel.isSkeletonable = true
        loadingYLabel.isSkeletonable = true
        loadingZLabel.isSkeletonable = true
    }
    
    func showLoadingView() {
        self.contentView.showAnimatedGradientSkeleton()
    }
    
    func hideLoadingView() {
        self.contentView.hideSkeleton()
    }
    
}
