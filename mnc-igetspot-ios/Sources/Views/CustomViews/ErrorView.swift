////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate: class {
    func tryAgainButtonDidClicked()
}

enum ErrorViewDisplay {
    case fullpage
    case subview
}


class ErrorView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var descLabel:UILabel!
    @IBOutlet weak var tryAgainButton:UIButton!
    weak var delegate: ErrorViewDelegate?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self)
        }
        
        adjustLayout()
    }
    
    // MARK: - lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        tryAgainButton.makeItRounded(width: 0, cornerRadius: 20.0)
        makeGradientButton()
    }
    
    private func makeGradientButton(){
        tryAgainButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 0.35, yStartPos: 0, yEndPos: 0)
    }
    
    // MARK: - Public Functions    
    func setContent(message:String?,
                    buttonTitle title:String?,
                    forDisplay display:ErrorViewDisplay) {
        if (display == .fullpage) {
            descLabel.font = R.font.barlowMedium(size: 14)
        } else {
            descLabel.font = R.font.barlowRegular(size: 14)
        }
        descLabel.text = message
        
        if let buttonTitle = title {
            tryAgainButton.alpha = 1.0
            tryAgainButton.setTitle(buttonTitle, for: .normal)
        } else {
            tryAgainButton.alpha = 0.0
        }
    }
    
    // MARK: - Actions
    @IBAction func tryAgainButtonDidClicked() {
        delegate?.tryAgainButtonDidClicked()
    }
}
