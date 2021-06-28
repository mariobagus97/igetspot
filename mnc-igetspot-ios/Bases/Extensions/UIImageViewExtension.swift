//
//  UIImageViewExtension.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 04/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import Foundation
import SDWebImage
import Kingfisher

extension UIImageView {
    
    func loadIGSImage(link: String, placeholderImage: UIImage? = nil) {
//        let imageUrlString = IGSImageUrlHelper.getImageUrl(forPathUrl: link)
        if link.contains(" ") {
            load(link: link.replacingOccurrences(of: " ", with: "%20"), placeholderImage: placeholderImage)
        } else {
            load(link: link, placeholderImage: placeholderImage)
        }
    }
    
    
    func load(link: String, placeholderImage: UIImage? = nil) {
        PrintDebug.printDebugGeneral(link, message: "image link")
        //let processor = DownsamplingImageProcessor(size: self.frame.size)
        if let pholderImage = placeholderImage {
            self.image = pholderImage
        }
        if link == "" {
            self.sd_setImage(with: nil, placeholderImage: R.image.userPlacaholder(), options: .scaleDownLargeImages, completed: nil)
        }
        if let linkURL = URL(string: link) {
            self.sd_imageTransition = .fade
            self.sd_setImage(with: linkURL, placeholderImage: placeholderImage, options: .scaleDownLargeImages, completed: nil)
        }
    }
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
