//
//  CategorySort.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/17/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftMessages

class CategorySort: MessageView {
    
    
    var closeMessage: (() -> Void)?

    @IBOutlet weak var highestPopularityLabel: UILabel!
    
    @IBOutlet weak var lowestPriceLabel: UILabel!
    
    @IBOutlet weak var highestPriceLabel: UILabel!
    
    @IBOutlet weak var highestRatingLabel: UILabel!
    
    @IBOutlet weak var nearestDistanceLabel: UILabel!
    
    @IBAction func onClosePressed(_ sender: Any) {
        closeMessage?()
    }
    
    @IBAction func onHighestPopularityPressed(_ sender: Any) {
        
    }
    
    @IBAction func onLowestPricePressed(_ sender: Any) {
        
    }
    
    @IBAction func onHighestPricePressed(_ sender: Any) {
        
    }
    
    @IBAction func onHighestRatingPressed(_ sender: Any) {
        
    }
    
    @IBAction func onNearestDistancePressed(_ sender: Any) {
        
    }
    
}
