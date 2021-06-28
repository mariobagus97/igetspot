//
//  HeaderSectionView.swift
//  Metube
//
//  Created by Mendhy Syiasko on 5/30/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol HeaderSectionViewDelegate {
    func titleLabelDidPressed(source: HeaderSectionView)
    func buttonActionDidPressed(source: HeaderSectionView)
}

class HeaderSectionView: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var sectionActionButton: UIButton!
    
    
    var delegate: HeaderSectionViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelAction))
//        sectionTitle.isUserInteractionEnabled = true
//        sectionTitle.addGestureRecognizer(tap)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        xibSetup()
    }
    
    func setContent(){
       
    }
    
    @objc func titleLabelAction(){
        self.delegate.titleLabelDidPressed(source: self)
    }
    
    @IBAction func sectionActionButtonPressed(_ sender: Any) {
        self.delegate.buttonActionDidPressed(source: self)
    }
    
}
