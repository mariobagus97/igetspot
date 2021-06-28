//
//  MKCollectionViewSection.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 13/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import Foundation

class MKCollectionViewSection {
    
    private var title: String = ""
    private var itemList: [AnyObject] = [AnyObject]()
    
    func numberOfItems() -> Int {
        return itemList.count
    }
    
    func hasItemAtIndex(index: Int) -> Bool {
        return index < itemList.count
    }
    
    func appendItem(item: AnyObject) {
        itemList.append(item)
    }
    
    func appendItems(items: [AnyObject]) {
        self.itemList.append(contentsOf: items)
    }
    
    func setItems(items: [AnyObject]) {
        self.itemList = items
    }
    
    func getItemAtIndex(index: Int) -> AnyObject? {
        if hasItemAtIndex(index: index) {
            return itemList[index]
        }
        return nil
    }
    
}
