////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class OrderDetailMasterCell: MKTableViewCell {
    
    @IBOutlet weak var masterImageView: UIImageView!
    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var masterTitleLabel: UILabel!
    @IBOutlet weak var packageNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        masterImageView.setRounded()
    }
    
    func setContent(masterImageUrl:String, masterName:String, packageName:String) {
        let masterNameAttributed = "Master: \(masterName)"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: masterNameAttributed)
        attributedString.setColorForText(textForAttribute: "Master:", withColor: Colors.brownishGrey, withFont: R.font.barlowRegular(size: 11))
        
        masterImageView.loadIGSImage(link: masterImageUrl, placeholderImage: R.image.userPlacaholder())
        masterNameLabel.attributedText = attributedString
        packageNameLabel.text = packageName
    }
    
}
