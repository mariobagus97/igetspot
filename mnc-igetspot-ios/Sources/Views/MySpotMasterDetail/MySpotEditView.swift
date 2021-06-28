////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

protocol MySpotEditViewDelegate:class {
    func saveButtonDidClicked(aboutText:String)
}

class MySpotEditView: UIView {
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    weak var delegate: MySpotEditViewDelegate?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupDelegate()
        setupKeyboard()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupDelegate()
        setupKeyboard()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDelegate()
        setupKeyboard()
    }
    
    func setupKeyboard() {

    }
    
    func setupDelegate() {
        textView.delegate = self
    }
    
    func setContent(aboutString:String) {
        textView.text = aboutString
    }
    
    func showKeyboard(isShow:Bool) {
        if isShow {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }
}


extension MySpotEditView: UITextViewDelegate {
    
}
