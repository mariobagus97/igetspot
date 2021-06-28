////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol PackagePortofolioCollectionCellDelegate {
    func packagePortofolioDidClicked(imageUrl:String)
}

class PackagePortofolioCollectionCell: MKCollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var portofolioImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var delegate : PackagePortofolioCollectionCellDelegate?
    var portofolioImageUrl:String?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func loadView() {
        super.loadView()
        self.containerView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
        self.portofolioImageView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
        self.containerView.backgroundColor = Colors.gray
    }
    
    // MARK: - Public Functions
    func setupCell(imageUrl:String) {
        self.portofolioImageView.loadIGSImage(link: imageUrl, placeholderImage: R.image.blankImage())
    }

}
