//
//  MKTableViewCell.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 13/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit

public class MKTableViewCell: UITableViewCell {
    
    var priority: Int = 0
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadView() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func onSelected(){}
    
}
