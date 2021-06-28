//
//  MySpotThanksPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/18/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MySpotThanksPageDelegate {
    func manageMySpotButtonDidClicked()
    func manageOfficialSpotButtonDidClicked()
}

class MySpotThanksPage : UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var manageMySpotButton: UIButton!
    @IBOutlet weak var manageOfficialSpotButton: GradientBorderButton!
    @IBOutlet weak var containerView: UIView!
    var delegate: MySpotThanksPageDelegate?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        adjustLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        adjustLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Actions
    @IBAction func manageMySpotButtonDidClicked() {
        delegate?.manageMySpotButtonDidClicked()
    }
    
    @IBAction func manageOfficialSpotButtonDidClicked() {
        delegate?.manageOfficialSpotButtonDidClicked()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        manageMySpotButton.makeItRounded(width:0.0, cornerRadius : manageMySpotButton.bounds.height / 2)
        manageMySpotButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        manageOfficialSpotButton.setTitleColor(Colors.vividBlue, for: .normal)
        manageOfficialSpotButton.setupButton(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], startPoint: CGPoint.zero, endPoint: CGPoint(x: 1, y: 0), cornerRadius: manageOfficialSpotButton.bounds.height)
        
        imageView.image = R.image.afterRegistration()
        
    }
    
}
