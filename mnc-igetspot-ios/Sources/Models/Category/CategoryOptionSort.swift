//
//  CategoryOptionSort.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 02/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation


class CategoryOptionSort {
    var title:String?
    var key:String?
    var value:String?
    
    init(title:String, key:String, value:String) {
        self.title = title
        self.key = key
        self.value = value
    }
    
    static func buildListSortCategory(forCategory categoryType:CategoryPageContentType) -> [CategoryOptionSort] {
        let popularSort = CategoryOptionSort(title: NSLocalizedString("Highest popularity", comment: ""), key: "sortBypopular", value: "MAX")
        let lowestPriceSort = CategoryOptionSort(title: NSLocalizedString("Lowest price", comment: ""), key: "sortByprice", value: "MIN")
        let highestPriceSort = CategoryOptionSort(title: NSLocalizedString("Highest price", comment: ""), key: "sortByprice", value: "MAX")
        let highestRatingSort = CategoryOptionSort(title: NSLocalizedString("Highest rating", comment: ""), key: "sortByrate", value: "MAX")
        let nearestDistance = CategoryOptionSort(title: NSLocalizedString("Nearest distance", comment: ""), key: "nearestDistanceKey", value: "nearestDistanceValue")
        
        return categoryType == .package ? [popularSort, lowestPriceSort, highestPriceSort, highestRatingSort, nearestDistance] : [popularSort, highestRatingSort, nearestDistance]
    }
}
