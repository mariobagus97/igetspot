////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol ReportThisOrderViewDelegate:class {
    func submitReportOrderButtonDidClicked(reasonString:String, explainString:String)
    func showReasonReport()
}

class ReportThisOrderView: UIView {
    
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var reasonContainerView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitReportButton: UIButton!
    weak var delegate: ReportThisOrderViewDelegate?
    let defaultTextViewHeight:CGFloat = 60.0
    
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
    
    // MARK: - Layouts
    private func adjustLayout() {
        submitReportButton.backgroundColor = Colors.brownishGrey
        submitReportButton.makeItRounded(width: 0, cornerRadius : submitReportButton.bounds.height / 2)
        
        reasonContainerView.isUserInteractionEnabled = true
        reasonContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showReasonReport(_:))))
    }
    
    private func updateButton() {
        guard let reason = reasonLabel.text, reason != "Please Select", let explainString = textView.text, explainString.isEmptyOrWhitespace() == false else {
            submitReportButton.removeGradient()
            return
        }
        
        submitReportButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    func setReason(_ reason:String) {
        reasonLabel.text = reason
        updateButton()
    }
    
    // MARK: - Actions
    @IBAction func submitReportDidClicked() {
        guard let reason = reasonLabel.text, reason != "Please Select", let explainString = textView.text, explainString.isEmpty == false else {
            return
        }
        delegate?.submitReportOrderButtonDidClicked(reasonString: reason, explainString: explainString)
    }
    
    @objc func showReasonReport(_ sender: UITapGestureRecognizer) {
        delegate?.showReasonReport()
    }
}


extension ReportThisOrderView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text != nil && textView.text != ""){
            var newFrame = self.textView.frame
            let width = newFrame.size.width
            let newSize = self.textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
            if newSize.height > defaultTextViewHeight {
                newFrame.size = CGSize(width: width, height: newSize.height)
                textView.frame = newFrame
                self.textViewHeightConstraint.constant = newSize.height
                self.textView.setNeedsLayout()
                self.textView.layoutIfNeeded()
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        } else {
            self.textViewHeightConstraint.constant = defaultTextViewHeight
            self.textView.setNeedsLayout()
            self.textView.layoutIfNeeded()
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        
        updateButton()
    }
}
