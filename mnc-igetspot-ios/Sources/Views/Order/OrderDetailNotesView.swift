////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

protocol OrderDetailNotesViewDelegate:class {
    func addButtonDidClicked(noteString:String)
    func closeNotesButtonDidClicked()
}

class OrderDetailNotesView: UIView {
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    weak var delegate: OrderDetailNotesViewDelegate?
    
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
    
    func adjustLayout() {
        addButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        addButton.makeItRounded(width: 0, cornerRadius: addButton.frame.height/2)
        addButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        textViewDidChange(textView)
    }
    
    func setContent(noteString:String) {
        showKeyboard(isShow: true)
        textView.text = noteString
    }
    
    func showKeyboard(isShow:Bool) {
        if isShow {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }
    
    // MARK: - Actions
    @IBAction func addButtonDidClicked() {
        showKeyboard(isShow: false)
        delegate?.addButtonDidClicked(noteString: textView.text)
    }
    
    @IBAction func closeButtonDidClicked() {
        showKeyboard(isShow: false)
        delegate?.closeNotesButtonDidClicked()
    }
}

extension OrderDetailNotesView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text, text.isEmptyOrWhitespace() == false else {
            return
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}
