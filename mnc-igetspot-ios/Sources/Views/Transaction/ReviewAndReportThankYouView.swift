////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol ReviewAndReportThankYouViewDelegate:class {
    func backToTransactionButtonDidClicked()
}

class ReviewAndReportThankYouView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backToTransactionButton: UIButton!
    weak var delegate: ReviewAndReportThankYouViewDelegate?
    
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
        backToTransactionButton.makeItRounded(width:0.0, cornerRadius : backToTransactionButton.bounds.height / 2)
        backToTransactionButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        imageView.image = R.image.reportConfirmationOrder()
    }
    
    // MARK: - Actions
    @IBAction func backToTransactionButtonDidClicked() {
        delegate?.backToTransactionButtonDidClicked()
    }

}
