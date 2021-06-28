////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MySpotMasterDetailPackageCollectionCell: MKCollectionViewCell {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var packagePriceLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var package = MySpotPackage()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editButton.setRounded()
        overlayView.applyGradient(colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.4)], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 0.3)
        self.containerView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
        self.packageImageView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
        self.containerView.backgroundColor = Colors.gray
    }
    
    
    override func loadView() {
        super.loadView()
    }
    
    // MARK: - Public Functions
    func setupCell(package: MySpotPackage){
        
        self.package = package
        
        packageNameLabel.text = package.packageName
        packagePriceLabel.text = package.price?.currency
        
        
        let imageUrlString = package.packageImages ?? ""
        self.packageImageView.loadIGSImage(link: imageUrlString)
        
    }
    
    // MARK: - Private Functions
    
    
    
    // MARK: Actions
}
