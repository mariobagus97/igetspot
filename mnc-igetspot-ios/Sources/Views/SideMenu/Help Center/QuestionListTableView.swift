//
//  QuestionListTableView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/18/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class QuestionListTableView: UIView, MKTableViewDelegate {
    
//    var cellDelegate : ResultSearchTableViewDelegate!
    var section : MKTableViewSection!
    var contentView: MKTableView!
    var questionCell : QuestionListTableCell!
    
    // MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    // MARK: - Public Functions
    func setupView() {
        contentView = MKTableView(frame: .zero)
        contentView.registerDelegate(delegate: self)
        contentView.tableView.isScrollEnabled = false
        self.addSubview(contentView)
        
        let topOffset:CGFloat = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 60 : 80
        
        contentView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(self)
        }
    }
    
    // MARK: - MKTableViewDelegate
    func createRows() {
        createQuestionCell()
    }
    
    func createSections() {
        section = MKTableViewSection()
        contentView.appendSection(section)
        
        contentView.reloadData()
    }
    
    func registerNibs() {
        contentView.registeredCellIdentifiers.append(contentsOf: [
            R.nib.questionListTableCell.name
            ])
    }
    
    func setContent(list: [String]){
        var contentList = list
        contentList.append(" ")
        for item in contentList {
            createQuestionCell()
            questionCell.setContent(text: item)
            section.appendRow(cell: questionCell)
        }
        
        self.contentView.tableView.reloadData()
        self.contentView.tableView.setNeedsLayout()
        contentView.tableView.layoutIfNeeded()
    }
    
    private func createQuestionCell(){
        questionCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.questionListTableCell.name) as? QuestionListTableCell
//        packageCell.delegate = self
        
    }
    
}
