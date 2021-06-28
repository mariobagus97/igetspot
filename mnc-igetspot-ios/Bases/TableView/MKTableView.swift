//
//  MKTableView.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 13/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit

@objc protocol MKTableViewDelegate {
    func createRows()
    func createSections()
    func registerNibs()
    
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func scrollViewDidScrollToTop(_ scrollView: UIScrollView)
    @objc optional func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    @objc optional func tableViewTouchBottom()
}

class MKTableView: UIView {
    
    var tableView: UITableView!
    var priorityActive: Bool = false
    var sections: [MKTableViewSection] = [MKTableViewSection]()
    var registeredCellIdentifiers: [String] = [String]()
    
    weak var delegate: MKTableViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitCreateTableView()
    }
    
    deinit {
        PrintDebug.printDebugGeneral(self, message: "deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    func commonInitCreateTableView() {
        if tableView == nil {
            setupTableView()
            observeDidReceiveMemoryWarning()
        }
    }
    
    func setupTableView() {
        tableView = UITableView(frame: self.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: 0.0001))
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 44.0
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self)
        }
    }
    
    func observeDidReceiveMemoryWarning() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleReceiveMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    @objc private func handleReceiveMemoryWarning() {
        if (tableView != nil) {
            PrintDebug.printDebugGeneral(self, message: "handleReceiveMemoryWarning")
            reloadData()
        }
    }
    
    func showSeparator() {
        if tableView != nil {
            tableView.separatorStyle = .singleLine
        }
    }
    
    func registerDelegate(delegate: MKTableViewDelegate) {
        self.delegate = delegate
        if let delegate = self.delegate {
            delegate.registerNibs()
            registerCellIdentifiers()
            delegate.createRows()
            delegate.createSections()
        }
    }
    
    private func registerCellIdentifiers() {
        for cellIdentifier in registeredCellIdentifiers {
            let nib = UINib(nibName: cellIdentifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        }
    }
    
    func reloadData() {
        if priorityActive {
            // Sorting Section
            sections.sort(by: {
                (section1: MKTableViewSection, section2: MKTableViewSection) -> Bool in
                return section1.priority < section2.priority
                
            })
            // Sorting Cell
            for section in sections {
                section.sortingRow()
            }
        }
        tableView.reloadData()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }
    
    func reloadSection(section: MKTableViewSection) {
        
        let sectionPosition = self.sectionPosition(section: section)
        if sectionPosition > -1 {
            // reload without animation
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.reloadSections(NSIndexSet(index: sectionPosition) as IndexSet, with: UITableView.RowAnimation.none)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
    
    func scrollEnabled(_ enabled: Bool) {
        tableView.isScrollEnabled = enabled
    }
    
    func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    func scrollToBottom() {
        let bottomOffset = tableView.contentSize.height - tableView.bounds.size.height
        if !tableView.isDragging && bottomOffset > 0 {
            let point: CGPoint = CGPoint(x: 0, y: bottomOffset)
            tableView.setContentOffset(point, animated: true)
        }
    }
    
    func removeAllSection() {
        sections.removeAll()
    }
    
    func appendSection(_ section: MKTableViewSection) {
        sections.append(section)
    }
    
    func deleteSection(_ section: MKTableViewSection) {
        let position = sectionPosition(section: section)
        sections.remove(at: position)
    }
    
    func getContentOffset() -> CGPoint {
        return tableView.contentOffset
    }
    
    func setContentOffset(offset: CGPoint) {
        if tableView != nil {
            tableView.contentOffset = offset
        }
    }
    
    func hasCell(cell: MKTableViewCell) -> Bool {
        for section in sections {
            if section.hasCell(cell: cell) {
                return true
            }
        }
        return false
    }
    
    func hasSection(section: MKTableViewSection) -> Bool {
        for sectionTable in sections {
            if sectionTable === section {
                return true
            }
        }
        return false
    }
    
    func sectionPosition(section: MKTableViewSection) -> Int {
        if sections.count > 0 {
            for position in 0...sections.count {
                if section === sections[position] {
                    return position
                }
            }
        }
        return -1
    }
    
    func getCell(cell: MKTableViewCell) -> MKTableViewCell {
        for section in sections {
            if section.hasCell(cell: cell) {
                return cell
            }
        }
        return MKTableViewCell()
    }
    
    func isRowEmpty() -> Bool {
        for section in sections {
            if !section.cells.isEmpty {
                return false
            }
        }
        return true
    }
    
    func hasSectionAtIndex(index: Int) -> Bool {
        return index < sections.count
    }
    
    func hasIndexPath(indexPath: IndexPath) -> Bool {
        return hasSectionAtIndex(index: indexPath.section) && sections[indexPath.section].hasRowAtIndex(index: indexPath.row)
    }
    
    func dequeueReusableCellWithIdentifier(nibName: String) -> UITableViewCell {
        if let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: nibName) {
            return cell
        }
        return UITableViewCell()
    }
}

extension MKTableView:  UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = sections[section].header {
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections[section].header != nil {
            return sections[section].headerHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let view = sections[section].footer {
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if hasIndexPath(indexPath: indexPath) {
            let row = sections[indexPath.section].getRowAtIndex(index: indexPath.row)
            row.onSelected()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if sections[section].footer != nil {
            return sections[section].footerHeight
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hasIndexPath(indexPath: indexPath) {
            let section = sections[indexPath.section]
            let cell = section.getRowAtIndex(index: indexPath.row)
            cell.loadView()
            return cell
        }
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
 
    
}
