////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotDetailPackageCellDelegate:class {
    func addPackageButtonDidClicked(categoryId:String)
    func editPackageButtonDidClicked(package:MySpotPackage)
}

class MySpotDetailPackageCell: MKTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var packageCollectionView: MySpotMasterDetailPackageCollectionView!
    weak var delegate : MySpotDetailPackageCellDelegate?
    var categoryId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.packageCollectionView.layoutIfNeeded()
    }
    
    override func loadView() {
        super.loadView()
        packageCollectionView.commonInit()
        packageCollectionView.delegate = self
        packageCollectionView.snp.removeConstraints()
        packageCollectionView.snp.makeConstraints { make in
            make.height.equalTo(packageCollectionView.getViewContentSize().height)
        }
        packageCollectionView.reloadData()
    }
    
    func setContent(packageArray: [MySpotPackage], categoryId:String?) {
        self.categoryId = categoryId
        packageCollectionView.setContent(packages: packageArray)
        layoutSubviews()
    }
    
    func removeContent(){
        packageCollectionView.removeContent()
    }
}

extension MySpotDetailPackageCell : MKCollectionViewDelegate {
    func collectionViewDidSelectedItemAtIndexPath(indexPath: IndexPath) {
        if let _ = packageCollectionView.collectionView.cellForItem(at: indexPath) as? MySpotMasterDetailPackageCollectionCell, let package = packageCollectionView.getItem(indexPath: indexPath) as? MySpotPackage {
            self.delegate?.editPackageButtonDidClicked(package: package)
        } else if let _ = packageCollectionView.collectionView.cellForItem(at: indexPath) as? MySpotAddPackageCollectionCell, let categoryId = self.categoryId {
            self.delegate?.addPackageButtonDidClicked(categoryId: categoryId)
        }
    }
}
