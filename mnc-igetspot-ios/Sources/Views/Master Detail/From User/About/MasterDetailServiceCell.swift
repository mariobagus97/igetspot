////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MasterDetailServiceCell: MKTableViewCell {
    
    @IBOutlet weak var servicesCollectionView: MasterDetailServiceCollectionView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.servicesCollectionView.layoutIfNeeded()
    }
    
    override func loadView() {
        super.loadView()
        self.servicesCollectionView.commonInit()
        self.servicesCollectionView.delegate = self
        self.servicesCollectionView.snp.removeConstraints()
        self.servicesCollectionView.snp.makeConstraints { make in
            make.height.equalTo(50).priority(999)
            make.left.equalTo(5)
        }
        self.servicesCollectionView.reloadData()
    }
    
    
    // MARK: - Private Methods
    
    // MARK: - Public Methods
    func setContent(services : [ServiceCategory]) {
        self.servicesCollectionView.setContent(services: services)
        layoutSubviews()
    }
    
    func showLoadingView() {
        servicesCollectionView.alpha = 0.0
    }
    
    func hideLoadingView() {
        servicesCollectionView.alpha = 1.0
    }
}

// MARK: - MKCollectionViewDelegate
extension MasterDetailServiceCell: MKCollectionViewDelegate {
    func collectionViewDidSelectedItemAtIndexPath(indexPath: IndexPath) {
       
    }
}
