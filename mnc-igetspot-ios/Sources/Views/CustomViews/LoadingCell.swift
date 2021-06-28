////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class LoadingCell: MKTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateHeight(_ height:CGFloat) {
        containerView.snp.removeConstraints()
        containerView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        self.layoutIfNeeded()
    }
    
}
