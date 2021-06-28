////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol EmptyLoadingViewDelegate: class {
    func errorTryAgainButtonDidClicked()
}

class EmptyLoadingView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorView: ErrorView!
    
    weak var delegate: EmptyLoadingViewDelegate?
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setErroViewDelegate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setErroViewDelegate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setErroViewDelegate()
    }
    
    func setErroViewDelegate() {
        errorView.delegate = self
    }
    
    func showLoadingView() {
        self.loadingIndicatorView.startAnimating()
        errorView.alpha = 0.0
    }
    
    func hideLoadingView() {
        self.loadingIndicatorView.stopAnimating()
        errorView.alpha = 0.0
    }
    
    func setEmptyErrorContent(withMessage message:String?, buttonTitle:String?, forDisplay display: ErrorViewDisplay) {
        errorView.setContent(message: message, buttonTitle: buttonTitle, forDisplay:display)
        loadingIndicatorView.stopAnimating()
        errorView.alpha = 1.0
    }
    
}

extension EmptyLoadingView: ErrorViewDelegate {
    func tryAgainButtonDidClicked() {
        delegate?.errorTryAgainButtonDidClicked()
    }
}
