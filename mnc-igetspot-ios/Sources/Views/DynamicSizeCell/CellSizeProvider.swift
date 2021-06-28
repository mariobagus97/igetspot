//
//  CellSizeProvider.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/4/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class CellSizeProvider {
    private static let kTagsPadding: CGFloat = 21
    private static let kMinCellSize: UInt32 = 50
    private static let kMaxCellSize: UInt32 = 300
    
    class func provideSizes(items: [String]) -> [CGSize] {
        var cellSizes = [CGSize]()
        var size: CGSize = .zero
        
        for item in items {
            size =  CellSizeProvider.provideTagCellSize(item: item)
            cellSizes.append(size)
        }
    
        return cellSizes
    }
    
    class func provideTagCellSize(item: String) -> CGSize {
//        var size = UIFont.systemFont(ofSize: 17).sizeOfString(string: item, constrainedToWidth: Double(UIScreen.main.bounds.width))
        
        var size = UIFont(name:"Barlow-Regular",size:12)!.sizeOfString(string: item, constrainedToWidth: Double(UIScreen.main.bounds.width))
        
        size.width += kTagsPadding
        size.height += kTagsPadding
        
        return size
    }
    
    private class func provideRandomCellSize(item: String) -> CGSize {
        let width = CGFloat(arc4random_uniform(kMaxCellSize) + kMinCellSize)
        let height = CGFloat(arc4random_uniform(kMaxCellSize) + kMinCellSize)
        
        return CGSize(width: width, height: height)
    }
}


extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSAttributedString.Key.font: self],
                                                     context: nil).size
    }
}
