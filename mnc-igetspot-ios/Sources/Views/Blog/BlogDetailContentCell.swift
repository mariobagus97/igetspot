//
//  BlogDetailContentCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 25/10/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftDate

class BlogDetailContentCell : MKTableViewCell {
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Private Functions
    
    // MARK: - Public Functions
    
    func setContent(withBlog blog:Whatson) {
        
        self.writerLabel.text = blog.author
        
//        if let date = blog.createdAt {
//            let isoDate = date.toISODate(region: Region.UTC)
//            let dateString = isoDate?.toString(.custom("dd MMMM yyyy"))
//            self.dateLabel.text = dateString
//        }
        
    }
}
