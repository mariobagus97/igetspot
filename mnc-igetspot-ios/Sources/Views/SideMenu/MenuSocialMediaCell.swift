////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MenuSocialMediaCellDelegate: class {
    func facebookButtonDidClicked()
    func twitterButtonDidClicked()
    func instagramButtonDidClicked()
    func youtubeButtonDidClicked()
}

class MenuSocialMediaCell: MKTableViewCell {

    @IBOutlet weak var facebookButton:UIButton!
    @IBOutlet weak var twitterButton:UIButton!
    @IBOutlet weak var instagramButton:UIButton!
    @IBOutlet weak var youtubeButton:UIButton!
    
    weak var delegate: MenuSocialMediaCellDelegate?
    
    // MARK: - Actions
    @IBAction func facebookButtonDidClicked() {
        delegate?.facebookButtonDidClicked()
    }
    
    @IBAction func twitterButtonDidClicked() {
        delegate?.twitterButtonDidClicked()
    }
    
    @IBAction func instagramButtonDidClicked() {
        delegate?.instagramButtonDidClicked()
    }
    
    @IBAction func youtubeButtonDidClicked() {
        delegate?.youtubeButtonDidClicked()
    }
    
}
