//
//  MKTableViewSection.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 13/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import Foundation
import UIKit

class MKTableViewSection {
    
    var title: String = ""
    var priority: Int = 0
    var headerHeight: CGFloat = 50
    var footerHeight: CGFloat = 50
    var cells: [MKTableViewCell] = [MKTableViewCell]()
    var header: HeaderSectionView?
    var footer: FooterSectionView?
    
    func numberOfRows() -> Int {
        return cells.count
    }
    
    func hasRowAtIndex(index: Int) -> Bool {
        return index < cells.count
    }
    
    func appendRow(cell: MKTableViewCell) {
        cells.append(cell)
    }
    
    func sortingRow() {
        cells.sort(by: {
            (cell1: MKTableViewCell, cell2: MKTableViewCell) -> Bool in
            return cell1.priority < cell2.priority
        })
    }
    
    func hasCell(cell: MKTableViewCell) -> Bool {
        return cells.contains(cell)
    }
    
    func indexOfCell(cell: MKTableViewCell) -> Int {
        for index in 0...cells.count {
            if cells[index] == cell {
                return index
            }
        }
        return -1
    }
    
    func removeAllRows() {
        cells.removeAll()
    }
    
    func removeAtIndex(index: Int){
        cells.remove(at: index)
    }
    
    func getRowAtIndex(index: Int) -> MKTableViewCell {
        if hasRowAtIndex(index: index) {
            return cells[index]
        }
        return MKTableViewCell()
    }
    
    func getHeader() -> UIView?{
        return header
    }
    
    func getFooter() -> UIView?{
        return footer
    }
    
}
