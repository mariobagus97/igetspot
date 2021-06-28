////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol BlogListCellDelegate: class {
    func blogListDidClicked(atItem blog:Whatson)
}

class BlogListCell: MKTableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    weak var delegate: BlogListCellDelegate?
    var blog: Whatson?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.makeItRounded(width: 0, borderColor: UIColor.clear.cgColor, cornerRadius: 10)
        overlayView.applyGradient(colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.3)], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 0.1)
    }
    
    func setContent(blog:Whatson) {
        self.blog = blog
        backgroundImageView.loadIGSImage(link: blog.imageUrl ?? "")
        titleLabel.text = blog.title
        authorLabel.text = blog.author
    }
    
    override func onSelected() {
        guard let blog = self.blog else {
            return
        }
        delegate?.blogListDidClicked(atItem: blog)
    }
    
}
