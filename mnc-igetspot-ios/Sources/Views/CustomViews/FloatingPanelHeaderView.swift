////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol FloatingPanelHeaderViewDelegate:class {
    func panelHeaderCloseButtonDidClicked()
}

class FloatingPanelHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var horizontalSpacingIconAndTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthIconConstraint: NSLayoutConstraint!
    weak var delegate: FloatingPanelHeaderViewDelegate?
    let defaultIconWidth:CGFloat = 35.0
    let defaultHorizontalSpacing:CGFloat = 0.0
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Functions
    func setIconTitle(image:UIImage? = nil) {
        if let iconImage = image {
            iconImageView.image = iconImage
            horizontalSpacingIconAndTitleConstraint.constant = defaultHorizontalSpacing
            widthIconConstraint.constant = defaultIconWidth
        } else {
            horizontalSpacingIconAndTitleConstraint.constant = 0
            widthIconConstraint.constant = 0
        }
        self.layoutIfNeeded()
    }
    
    // MARK: - Actions
    @IBAction func closeButtonDidClicked() {
        delegate?.panelHeaderCloseButtonDidClicked()
    }
    
}
