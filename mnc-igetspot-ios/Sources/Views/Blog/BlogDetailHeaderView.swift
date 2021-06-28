////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class BlogDetailHeaderView: UIView {
    
    @IBOutlet weak var headerImageView:UIImageView!
    @IBOutlet weak var overlayView:UIView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Function
    func setContent(withImageUrl imageUrl:String, title:String) {
        headerImageView.loadIGSImage(link: imageUrl)
        titleLabel.text = title
        
        overlayView.applyGradient(colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.5)], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 0.1)
    }

}
