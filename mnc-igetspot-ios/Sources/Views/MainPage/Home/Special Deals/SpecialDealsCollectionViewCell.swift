//
//  SpecialDealsCollectionViewCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/18/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Cosmos

class SpecialDealsCollectionViewCell : MKCollectionViewCell{
    
    @IBOutlet weak var dealsImageView: UIImageView!
    
    @IBOutlet weak var dealsNameLabel: UILabel!
    
    @IBOutlet weak var dealsDescLabel: UILabel!
    
    @IBOutlet weak var dealStar1: UIImageView!
    
    @IBOutlet weak var dealStar2: UIImageView!
    
    @IBOutlet weak var dealStar3: UIImageView!
    
    @IBOutlet weak var dealStar4: UIImageView!
    
    @IBOutlet weak var dealStar5: UIImageView!
    
    @IBOutlet weak var dealTotal: UILabel!
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    
    var starImageView = [UIImageView]()
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
        
        self.containerView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 15.0)
        self.dealsImageView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 15.0)
        self.containerView.elevate(elevation: 2)
       // self.gradientView.applyGradient(colours: [UIColor.white, UIColor.black], xStartPos: 0, xEndPos: 0, yStartPos: 0.0, yEndPos: 0.5)
    }
    
    func setupCell(deal : Deals){
        
//        starImageView.append(dealStar1)
//        starImageView.append(dealStar2)
//        starImageView.append(dealStar3)
//        starImageView.append(dealStar4)
//        starImageView.append(dealStar5)
        
        let rate = Double(deal.rate)
        
        cosmosView.rating = rate!
        
//        setStarTint(rate: rate ?? 0.0)
        
        self.dealsImageView.loadIGSImage(link: deal.imageUrl)
    
        dealsNameLabel.text = deal.title
        dealsDescLabel.text = deal.description
        dealTotal.text = deal.deals
        
    }
    
    func setStarTint(rate: Double){
        if (rate > 0.0){
            let pos: Int = Int(round(rate)) - 1
            starImageView[pos].tintColor = .yellow
            setStarTint(rate: rate - 1.0)
        }
    }
}
