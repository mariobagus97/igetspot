////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MenuProfileCellDelegate:class {
    func profileDidClicked()
}

class MenuProfileCell: MKTableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userBalanceLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    weak var delegate: MenuProfileCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.setRounded()
    }

    func setProfileImage(imageUrl:String?, andName name:String) {
        if let urlString = imageUrl {
//            userImageView.loadIGSImage(link: urlString, placeholderImage: R.image.userPlacaholder())
            let url = NSURL(string: urlString)
            let data = NSData(contentsOf:url as! URL)
               if data != nil {
                userImageView.image = UIImage(data:data! as Data)
               }
        }
        
        userNameLabel.text = name
    }
    
    override func onSelected() {
        delegate?.profileDidClicked()
    }
    
    func setBalance(_ totalBalanceString:String) {
        
        let balanceTitleString = NSLocalizedString("Balance: ", comment: "")
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(balanceTitleString)\(totalBalanceString)")
        attributedString.setColorForText(textForAttribute: "Balance", withColor: UIColor.white, withFont: R.font.barlowRegular(size: 14))
        attributedString.setColorForText(textForAttribute: totalBalanceString, withColor: UIColor.white, withFont: R.font.barlowMedium(size: 14))
        userBalanceLabel.attributedText = attributedString
    }
    
}



