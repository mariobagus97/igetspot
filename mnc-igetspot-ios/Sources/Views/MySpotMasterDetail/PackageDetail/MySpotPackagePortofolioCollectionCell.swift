////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotPackagePortofolioCollectionCellDelegate:class {
    func deleteButtonDidClicked(packageImage:MySpotPackageImage, cell:MySpotPackagePortofolioCollectionCell)
}

class MySpotPackagePortofolioCollectionCell: MKCollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var portofolioImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate : MySpotPackagePortofolioCollectionCellDelegate?
    var packageImage:MySpotPackageImage?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func loadView() {
        super.loadView()
        
        deleteButton.setRounded()
        self.containerView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
        self.portofolioImageView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
        self.containerView.backgroundColor = Colors.gray
    }
    
    // MARK: - Public Functions
    func setupCell(packageImage:MySpotPackageImage) {
        self.packageImage = packageImage
        self.nameLabel.text = ""
        if let imageUrl = packageImage.imageUrl {
            self.portofolioImageView.loadIGSImage(link: imageUrl, placeholderImage: R.image.blankImage())
        } else if let image = packageImage.image {
            self.portofolioImageView.loadIGSImage(link: "xxxx/xxxx", placeholderImage: image)
        }
    }
    
    // MARK: - Actions
    @IBAction func deleteButtonDidClicked() {
        guard let packageImage = self.packageImage else {
            return
        }
        delegate?.deleteButtonDidClicked(packageImage: packageImage, cell: self)
    }
}
