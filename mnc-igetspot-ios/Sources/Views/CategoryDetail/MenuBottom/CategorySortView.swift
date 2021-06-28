//
//  CategorySortView.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 02/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol CategorySortViewDelegate:class {
    func closeSortView()
    func categorySortDidSelect(selectedSort:CategoryOptionSort)
}

class CategorySortView: UIView {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var sortOptionsArray = [CategoryOptionSort]()
    var selectedSort: CategoryOptionSort?
    weak var delegate: CategorySortViewDelegate?

    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupTableView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupTableView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    // MARK: - Actions
    @IBAction func closeButtonDidClicked() {
        delegate?.closeSortView()
    }
    
    // MARK: - Private Functions
    private func setupTableView() {
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = 50
        tableView.isScrollEnabled = false
        tableView.register(UINib(nibName: "RadioButtonAndTitleCell", bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.radioButtonAndTitleCell.identifier)
    }
    
    func setupSortList(forCategoryType categoryType:CategoryPageContentType) {
        sortOptionsArray = CategoryOptionSort.buildListSortCategory(forCategory: categoryType)
        tableView.reloadData()
        
        tableView.snp.removeConstraints()
        tableView.snp.makeConstraints { make in
            make.height.equalTo(tableView.contentSize.height).priority(999)
        }
        self.layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource
extension CategorySortView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortOptionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.radioButtonAndTitleCell.identifier, for: indexPath) as! RadioButtonAndTitleCell
        let categoryOptionSort = sortOptionsArray[indexPath.row]
        var isSelected = false
        if categoryOptionSort.title == selectedSort?.title {
            isSelected = true
        }
        cell.setContent(withTitle: categoryOptionSort.title, isSelected: isSelected)
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension CategorySortView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryOptionSort = sortOptionsArray[indexPath.row]
        selectedSort = categoryOptionSort
        tableView.reloadData()
        
        delegate?.categorySortDidSelect(selectedSort: categoryOptionSort)
    }
}
