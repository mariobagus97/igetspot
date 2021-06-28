//
//  FooterSectionView.swift
//  Metube
//
//  Created by Mendhy Syiasko on 5/31/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol FooterSectionViewDelegate {
    func actionButtonDidPressed(source: FooterSectionView)
}

class FooterSectionView: UIView {
    
    @IBOutlet weak var actionButton: UIButton!
    var delegate: FooterSectionViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        self.delegate.actionButtonDidPressed(source: self)
    }
    
}
