////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol SelectViaMapCellDelegate:class {
    func selectViaMapDidTapped()
}

class SelectViaMapCell: MKTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: SelectViaMapCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGestures()
    }
    
    func setupTapGestures() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewTapped))
        tapGesture.cancelsTouchesInView = false
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleViewTapped() {
        delegate?.selectViaMapDidTapped()
    }
    
}
