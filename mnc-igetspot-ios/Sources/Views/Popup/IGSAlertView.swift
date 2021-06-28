//
//  IGSAlertView.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 17/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftMessages

class IGSAlertView: MessageView {

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: GradientBorderButton!
    @IBOutlet weak var heightCancelConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightOkConstraint: NSLayoutConstraint!
    
    var okAction: (() -> Void)?
    var cancelAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        okButton.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius : okButton.bounds.height / 2)
        okButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        cancelButton.setTitleColor(Colors.vividBlue, for: .normal)
        cancelButton.setupButton(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], startPoint: CGPoint.zero, endPoint: CGPoint(x: 1, y: 0), cornerRadius: cancelButton.bounds.height)
    }
    
    // MARK: - Publics Functions
    func setTitleOkButton(title:String?) {
        guard let buttonTitle = title else {
            heightOkConstraint.constant = 0
            self.layoutIfNeeded()
            return
        }
        okButton.setTitle(buttonTitle, for: .normal)
    }
    
    func setTitleCancelButton(title:String?) {
        guard let buttonTitle = title else {
            heightCancelConstraint.constant = 0
            self.layoutIfNeeded()
            return
        }
        cancelButton.setTitle(buttonTitle, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func okButtonDidClicked() {
        okAction?()
    }
    
    @IBAction func cancelButtonDidClicked() {
        cancelAction?()
    }
}
