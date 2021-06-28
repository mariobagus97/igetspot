//
//  Walkthrough.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 20/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class Walkthrough {
    
    var title : String?
    var description : String?
    var image : UIImage?
    
    init(title: String,description: String, image: UIImage?) {
        self.title = title
        self.description = description
        self.image = image
    }
    
    func getTitle() -> String?{
        return self.title
    }
    
    func getDescription() -> String?{
        return self.description
    }
    
    func getImage() -> UIImage? {
        return self.image
    }
    
}
