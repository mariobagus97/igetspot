////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol PackageDetailPortofolioCellDelegate:class {
    func packagePortofolioDidClicked(imageUrls:[String], index:Int)
}

class PackageDetailPortofolioCell : MKTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var packagePortofolioCollectionView: PackageDetailPortofolioCollectionView!
    weak var delegate : PackageDetailPortofolioCellDelegate?
    var imageUrls:[String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.packagePortofolioCollectionView.layoutIfNeeded()
    }
    
    override func loadView() {
        super.loadView()
        packagePortofolioCollectionView.commonInit()
        packagePortofolioCollectionView.snp.removeConstraints()
        packagePortofolioCollectionView.snp.makeConstraints { make in
            make.height.equalTo(packagePortofolioCollectionView.getViewContentSize().height)
        }
        packagePortofolioCollectionView.delegate = self
        packagePortofolioCollectionView.reloadData()
    }
    
    func setContent(imageUrls:[String]){
        self.imageUrls = imageUrls
        packagePortofolioCollectionView.setContent(portofolioImageUrlArray: imageUrls)
        layoutSubviews()
    }
    
    func removeContent(){
        packagePortofolioCollectionView.removeContent()
    }
    
}


// MARK:- MKCollectionViewDelegate
extension PackageDetailPortofolioCell: MKCollectionViewDelegate {
    
    func collectionViewDidSelectedItemAtIndexPath(indexPath: IndexPath) {
        guard var imageUrlArray = self.imageUrls else {
            return
        }
        for index in 0...imageUrlArray.count-1 {
            let pathImageUrl = imageUrlArray[index]
            let imageUrlString = IGSImageUrlHelper.getImageUrl(forPathUrl: pathImageUrl)
            imageUrlArray[index] = imageUrlString
        }
        delegate?.packagePortofolioDidClicked(imageUrls: imageUrlArray, index: indexPath.item)
    }
}
