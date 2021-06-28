////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MenuListCellDelegate {
    func menuListDidSelected(withMenuItems menuItems:MenuItems)
}

class MenuListCell: MKTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconMenuImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var separatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    var delegate:MenuListCellDelegate?
    let normalMenuCellLeading:CGFloat = 85.0
    let wideSeparatorHeight:CGFloat = 8
    var menuItems: MenuItems?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(forMenuItems menuItems:MenuItems) {
        self.menuItems = menuItems
        
        iconMenuImageView.alpha = 1.0
        iconMenuImageView.image = menuItems.getIcon()
        let titleMenuString = menuItems.getItem()
        
        if (menuItems.getItem() == MenuItem.About.value) {
            iconMenuImageView.alpha = 0.0
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: titleMenuString)
            attributedString.setColorForText(textForAttribute: "About", withColor: UIColor.white, withFont: R.font.barlowRegular(size: 14))
            attributedString.setColorForText(textForAttribute: "i get spot", withColor: UIColor.white, withFont: R.font.quandoRegular(size: 14))
            titleLabel.attributedText = attributedString
        } else {
            titleLabel.text = titleMenuString
        }
        
        separatorLeadingConstraint.constant = normalMenuCellLeading
        separatorHeightConstraint.constant = 1.0
        
        contentHeightConstraint.constant = getContentHeight(basedScreenType: UIDevice.current.screenType)
        
        self.contentView.layoutIfNeeded()
    }
    
    func getContentHeight(basedScreenType screenType:UIDevice.ScreenType) -> CGFloat {
        var contenHeight:CGFloat = 45
        switch UIDevice.current.screenType {
        case .iPhones_6_6s_7_8:
            contenHeight += 15
        case .iPhones_6Plus_6sPlus_7Plus_8Plus, .iPhone_XR:
            contenHeight += 25
        case .iPhones_X_XS:
            contenHeight += 30
        case .iPhone_XSMax:
            contenHeight += 40
        default:
            break
        }
        
        return contenHeight
    }
    
    override func onSelected() {
        super.onSelected()
        guard let menuItems = self.menuItems else {
            return
        }
        delegate?.menuListDidSelected(withMenuItems: menuItems)
    }
}
