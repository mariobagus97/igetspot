////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotRegisterTermsConditionViewDelegate {
    func continueButtonDidClicked()
}

class MySpotRegisterTermsConditionView: UIView {
    
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var radioButton: KGRadioButton!
    @IBOutlet weak var acceptTermsLabel: UILabel!
    @IBOutlet weak var acceptTermsView: UIView!
    
    var delegate: MySpotRegisterTermsConditionViewDelegate?
    
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
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    func adjustLayout() {
        continueButton.makeItRounded(width: 0, borderColor: UIColor.clear.cgColor, cornerRadius: continueButton.frame.height/2)
        
        acceptTermsLabel.textColor = Colors.blueTwo
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(acceptTermsViewDidTapped))
        tap.cancelsTouchesInView = false
        acceptTermsView.addGestureRecognizer(tap)
        
    }
    
    func setContent(text : String) {
        self.termsLabel.setHTMLFromString(text: text)
    }
    
    @objc func acceptTermsViewDidTapped() {
        if radioButton.isSelected {
            radioButton.isSelected = false
            continueButton.isEnabled = false
            continueButton.removeGradient()
        } else {
            radioButton.isSelected = true
            continueButton.isEnabled = true
            continueButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        }
    }
    
    @IBAction func continueButtonDidClicked() {
        if (radioButton.isSelected) {
            delegate?.continueButtonDidClicked()
        }
    }
    
}
