////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import SwiftDate

class BlogDetailContentView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var contentTitleView: UIView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
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
//                self.dateLabel.text = dateString
//        }
        
//        DispatchQueue.main.async {[weak self] in
//            self?.contentLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut lectus arcu bibendum at varius vel pharetra vel turpis. Arcu cursus vitae congue mauris. Consectetur adipiscing elit duis tristique sollicitudin nibh. Nunc non blandit massa enim. Mauris a diam maecenas sed enim. Convallis convallis tellus id interdum velit laoreet id donec ultrices. Habitant morbi tristique senectus et netus et. Id diam maecenas ultricies mi eget mauris pharetra et. Fringilla urna porttitor rhoncus dolor purus. Laoreet non curabitur gravida arcu ac tortor dignissim. Donec ultrices tincidunt arcu non sodales neque sodales. Sociis natoque penatibus et magnis dis parturient montes. A scelerisque purus semper eget duis at tellus at urna. Congue nisi vitae suscipit tellus. Sit amet volutpat consequat mauris. Maecenas volutpat blandit aliquam etiam erat velit scelerisque in dictum. Maecenas pharetra convallis posuere morbi leo urna molestie at. Risus commodo viverra maecenas accumsan lacus vel facilisis volutpat est. Ante metus dictum at tempor commodo ullamcorper a. Integer eget aliquet nibh praesent tristique magna sit. Ac tortor vitae purus faucibus. Eleifend donec pretium vulputate sapien. Odio aenean sed adipiscing diam donec adipiscing tristique risus nec.Sit amet nisl suscipit adipiscing bibendum est ultricies integer quis. A pellentesque sit amet porttitor eget dolor morbi non arcu. Scelerisque eu ultrices vitae auctor eu augue ut. Enim sit amet venenatis urna cursus eget nunc scelerisque viverra. Proin libero nunc consequat interdum varius sit amet. Nunc sed velit dignissim sodales ut eu. Massa massa ultricies mi quis hendrerit dolor magna eget est. Non sodales neque sodales ut etiam sit amet nisl. Lectus urna duis convallis convallis tellus id. Massa ultricies mi quis hendrerit dolor magna eget. Mattis aliquam faucibus purus in. Integer eget aliquet nibh praesent tristique magna sit amet.Ut faucibus pulvinar elementum integer. Suspendisse in est ante in nibh mauris cursus mattis molestie. Ullamcorper velit sed ullamcorper morbi tincidunt ornare massa. Egestas erat imperdiet sed euismod nisi porta lorem mollis aliquam. Amet consectetur adipiscing elit pellentesque habitant morbi tristique senectus. Sed faucibus turpis in eu mi bibendum neque. Ut enim blandit volutpat maecenas volutpat blandit."
//        }
        
        

        DispatchQueue.main.async {
            if let contentString = blog.desc {
                self.contentLabel.setHTMLFromString(text: contentString)
            }
        }

//        if let contentString = blog.detail{
//            if Thread.isMainThread {
//                DispatchQueue.global().async {
//                    self.contentLabel.setHTMLFromString(text: contentString)
//                }
//            } else {
//                self.contentLabel.setHTMLFromString(text: contentString)
//            }
//        }
    }
}
