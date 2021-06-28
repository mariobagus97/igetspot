////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotFinishYourOrderViewDelegate:class {
    func finishOrderButtonDidClicked()
    func photoButtonDidClicked()
}

class MySpotFinishYourOrderView: UIView {

    @IBOutlet weak var finishOrderButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoView: UIView!
    var delegate: MySpotFinishYourOrderViewDelegate?
    
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
    
    func setPhotoImage(image:UIImage) {
        imageView.image = image
        photoButton.alpha = 0.0
    }
    
    // MARK: - Layouts
    private func adjustLayout() {
        finishOrderButton.makeItRounded(width: 0.0, cornerRadius : finishOrderButton.bounds.height / 2)
        finishOrderButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        photoView.makeItRounded(width: 1, borderColor: Colors.selectedGray.cgColor, cornerRadius: 10)
    }
    
    // MARK: - Actions
    @IBAction func photoButtonDidClicked() {
        delegate?.photoButtonDidClicked()
    }
    
    @IBAction func finishOrderButtonDidClicked() {
        delegate?.finishOrderButtonDidClicked()
    }
}
