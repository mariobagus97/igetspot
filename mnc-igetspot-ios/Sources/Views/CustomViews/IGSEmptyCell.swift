////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

enum EmtypCellButtonType {
    case error
    case start
}

protocol IGSEmptyCellDelegate: class {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?)
}

class IGSEmptyCell: MKTableViewCell {
    
    @IBOutlet weak var containerView: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: IGSEmptyCellDelegate?
    var currentButtonType:EmtypCellButtonType?

    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Public Functions
    func setContent(withTitle title:String?, description:String?, buttonTitle:String?, buttonType:EmtypCellButtonType?) {
        titleLabel.text = title
        descLabel.text = description
        if let title = buttonTitle {
            button.alpha = 1.0
            button.setTitle(title, for: .normal)
        } else {
            button.alpha = 0.0
        }
        
        currentButtonType = buttonType
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        button.setTitle(NSLocalizedString("Start Browsing", comment: ""), for: .normal)
        button.makeItRounded(width: 0, cornerRadius: 20.0)
        makeGradientButton()
    }
    
    private func makeGradientButton(){
        button.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    @IBAction func buttonDidClicked() {
        delegate?.buttonDidClicked(withButtonType: currentButtonType)
    }
    
}
