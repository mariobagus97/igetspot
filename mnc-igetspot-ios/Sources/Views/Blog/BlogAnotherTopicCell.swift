////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import FSPagerView

class BlogAnotherTopicCell: FSPagerViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.shadowRadius = 0
        self.contentView.layer.shadowOpacity = 0
        containerView.makeItRounded(width: 0, borderColor: UIColor.clear.cgColor, cornerRadius: 10)
        overlayView.applyGradient(colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.5)], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 0.1)
    }
    
    func setContent(blog:Whatson) {
        backgroundImageView.loadIGSImage(link: blog.imageUrl ?? "")
        titleLabel.text = blog.title
        descLabel.text = blog.desc
    }

}
