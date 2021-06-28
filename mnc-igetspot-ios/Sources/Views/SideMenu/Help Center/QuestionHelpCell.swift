//
//  QuestionHelpCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/18/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class QuestionHelpCell : MKTableViewCell{
    
    @IBOutlet weak var questionListTable: QuestionListTableView!
    
    @IBOutlet weak var questionListTableHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        questionListTable.cellDelegate = self
        addGesture()
    }
    
    func addGesture(){
//        filterView.isUserInteractionEnabled = true
//        filterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFilterViewPressed(_:))))
    }
    
    func setResultContent(questionList : [String]){
        questionListTable.setContent(list: questionList)
        questionListTableHeight.constant = questionListTable.contentView.tableView.contentSize.height
        questionListTable.setNeedsLayout()
        questionListTable.layoutIfNeeded()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
//    @objc func onFilterViewPressed(_ sender: UITapGestureRecognizer){
//        self.delegate?.onFilterPressed()
//    }
}
