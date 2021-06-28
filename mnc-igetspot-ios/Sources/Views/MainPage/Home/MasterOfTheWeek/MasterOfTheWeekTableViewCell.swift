//
//  MasterOfTheWeekTableViewCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/5/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol MasterOfTheWeekTableViewCellDelegate:class {
    func seeAllMaster()
    func masterOfTheWeekDidClicked(withMaster master: MasterPreview) 
}

class MasterOfTheWeekTableViewCell : MKTableViewCell{
    
    @IBOutlet weak var titleMasterOfTheWeekLabel: UILabel!
    @IBOutlet weak var seeAllLabel: UILabel!
    @IBOutlet weak var masterOfTheWeekCollectionView: MasterOfTheWeekCollectionView!
    weak var delegate: MasterOfTheWeekTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
        masterOfTheWeekCollectionView.commonInit()
        masterOfTheWeekCollectionView.delegate = self
        masterOfTheWeekCollectionView.snp.removeConstraints()
        let cellSize = masterOfTheWeekCollectionView.getContentHeight(basedScreenType: UIDevice.current.screenType)
        masterOfTheWeekCollectionView.snp.makeConstraints { make in
            make.height.equalTo(cellSize)
        }
        masterOfTheWeekCollectionView.reloadData()
        seeAllLabel.isUserInteractionEnabled = true
        seeAllLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(isPressed(_:))))
    }
    
    func setContent(master: [MasterPreview]){
        masterOfTheWeekCollectionView.setContent(master: master)
        masterOfTheWeekCollectionView.refreshLayout()
    }
    
    func removeContent(){
        masterOfTheWeekCollectionView.removeContent()
    }
    
    @objc func isPressed(_ sender: UITapGestureRecognizer){
        self.delegate?.seeAllMaster()
    }
}

extension MasterOfTheWeekTableViewCell: MKCollectionViewDelegate {
    func collectionViewDidSelectedItemAtIndexPath(indexPath: IndexPath) {
        if let master = masterOfTheWeekCollectionView?.getItem(indexPath: indexPath) as? MasterPreview {
            self.delegate?.masterOfTheWeekDidClicked(withMaster: master)
        }
    }
}

