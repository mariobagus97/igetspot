//
//  MySpotIntro.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/29/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MySpotIntroDelegate {
    func joinButtonDidClicked()
    func officialSpotMasterDidClicked()
}

class MySpotIntro : UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var officialSpotMasterButton: UIButton!
    
    var delegate : MySpotIntroDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.backgroundColor = .white
        joinButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        joinButton.makeItRounded(width: 0, borderColor: UIColor.clear.cgColor, cornerRadius: joinButton.frame.height/2)
        
        officialSpotMasterButton.setTitleColor(Colors.gradientThemeTwo, for: .normal)
        imageView.image = R.image.myspotIntro()
    }
    
    
    @IBAction func joinButtonDidClicked(_ sender: Any) {
        delegate?.joinButtonDidClicked()
    }
    
    @IBAction func officialSpotMasterDidClicked(_ sender: Any) {
        delegate?.officialSpotMasterDidClicked()
    }
    
}
