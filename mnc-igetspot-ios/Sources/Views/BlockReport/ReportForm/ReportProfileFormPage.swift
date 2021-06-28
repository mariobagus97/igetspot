//
//  ReportProfileFormPage.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 03/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

protocol ReportProfileFormPageDelegate {
    func onReportButtonPressed(reasonString: String)
}

class ReportProfileFormPage: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var submitReportButton: UIButton!
    
    var delegate: ReportProfileFormPageDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.submitReportButton.makeItRounded(width:0.0, cornerRadius : self.submitReportButton.bounds.height / 2)
        self.submitReportButton.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    func setContent(title: String?, subtitle: String?) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        showKeyboard(isShow: true)
    }
    
    func showKeyboard(isShow:Bool) {
        if isShow {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }
    
    // MARK: - Actions
    @IBAction func reportButtonDidClicked() {
        showKeyboard(isShow: false)
        delegate?.onReportButtonPressed(reasonString: textView.text)
    }
}
