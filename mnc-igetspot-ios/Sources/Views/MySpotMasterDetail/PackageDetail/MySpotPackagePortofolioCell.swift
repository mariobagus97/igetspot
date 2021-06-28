////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotPackagePortofolioCellDelegate:class {
    func packagePortofolioDidClicked(packagePortofolio:MySpotPackageImage, index:Int)
    func addPackagePortofolioDidClicked()
    func deleteButtonPortofolioDidClicked(packagePortofolio: MySpotPackageImage)
}

class MySpotPackagePortofolioCell: MKTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var packagePortofolioCollectionView: MySpotPackagePortofolioCollectionView!
    weak var delegate : MySpotPackagePortofolioCellDelegate?
    var packagePortofolios:[MySpotPackageImage]?
    
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
        packagePortofolioCollectionView.cellDelegate = self
        packagePortofolioCollectionView.reloadData()
    }
    
    func setContent(packagePortofolios:[MySpotPackageImage]){
        self.packagePortofolios = packagePortofolios
        packagePortofolioCollectionView.setContent(packagePortofolios: packagePortofolios)
        layoutSubviews()
    }
    
    func removeContent(){
        packagePortofolioCollectionView.removeContent()
    }
    
    func handlePortofolioClicked(atIndex:Int) {
        guard let packagePortofolios = self.packagePortofolios else {
            return
        }
        let packagePortofolio = packagePortofolios[atIndex]
        delegate?.packagePortofolioDidClicked(packagePortofolio: packagePortofolio, index: atIndex)
    }
    
}


// MARK:- MKCollectionViewDelegate
extension MySpotPackagePortofolioCell: MKCollectionViewDelegate {
    
    func collectionViewDidSelectedItemAtIndexPath(indexPath: IndexPath) {
        if let _ = packagePortofolioCollectionView.collectionView.cellForItem(at: indexPath) as? MySpotPackagePortofolioCollectionCell {
            handlePortofolioClicked(atIndex: indexPath.item)
        } else if let _ = packagePortofolioCollectionView.collectionView.cellForItem(at: indexPath) as? MySpotAddPackageCollectionCell {
            self.delegate?.addPackagePortofolioDidClicked()
        }
    }
}

// MARK:- MySpotPackagePortofolioCollectionViewDelegate
extension MySpotPackagePortofolioCell: MySpotPackagePortofolioCollectionViewDelegate {
    func deletePortofolioDidClicked(packagePortofolio: MySpotPackageImage) {
        delegate?.deleteButtonPortofolioDidClicked(packagePortofolio: packagePortofolio)
    }
    
}
