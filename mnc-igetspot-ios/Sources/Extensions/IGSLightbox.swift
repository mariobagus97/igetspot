////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import Lightbox
import SDWebImage

class IGSLightbox {
    
    class func show(imageSrcs: [String], index: Int? = 0) {
        let lightboxImages = imageSrcs.map { (item) -> LightboxImage in
            guard let url = URL(string: item) else {
                return LightboxImage(image: R.image.userPlacaholder()!)
            }
            return LightboxImage(imageURL: url)
        }
        // Load image using SDWebImage
        LightboxConfig.loadImage = {
            imageView, URL, completion in
            imageView.sd_setImage(with: URL)
            
            completion?(nil)
        }
        
        if imageSrcs.count > 1 {
            LightboxConfig.PageIndicator.enabled = true
        } else {
            LightboxConfig.PageIndicator.enabled = false
        }
        
        let closeButtonAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font:  R.font.barlowMedium(size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        LightboxConfig.CloseButton.textAttributes = closeButtonAttributes
        
        let startIndex = index ?? 0
        let lightbox = LightboxController(images: lightboxImages, startIndex: startIndex)
        lightbox.modalPresentationStyle = .fullScreen
        lightbox.dynamicBackground = false
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            vc.present(lightbox, animated: true, completion: nil)
        }
    }
    
    class func showLocalImage(images: [UIImage], index: Int? = 0, vc: UIViewController){
        
        let lightboxImages = images.map { (item) -> LightboxImage in
                return LightboxImage(image: item)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: index ?? 0)
        lightbox.modalPresentationStyle = .fullScreen
        vc.present(lightbox, animated: true, completion: nil)
        
    }
}
