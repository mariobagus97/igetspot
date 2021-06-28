////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import SwiftMessages

protocol ReasonReportViewDelegate:class {
    func reasonReportCloseButtonDidClicked()
    func reasonDidSelect(reason:String)
}

class ReasonReportView: MessageView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    weak var delegate: ReasonReportViewDelegate?
    
    var listArray:[String]?
    var selectedReason: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell") 
        tableView.register(UINib(nibName: "IGSSelectCell", bundle: nil), forCellReuseIdentifier: "IGSSelectCell")
    }
    
    private func updateHeightTableView() {
        self.tableView.reloadData()
        tableView.layoutIfNeeded()
        tableViewHeightConstraint.constant = self.tableView.contentSize.height
    }
    
    // MARK: - Public Functions
    func setContent(listArray:[String]) {
        self.listArray = listArray
        updateHeightTableView()
    }
    
    // MARK: - Actions
    @IBAction func closeButtonDidClicked() {
        delegate?.reasonReportCloseButtonDidClicked()
    }
}

// MARK: - UITableViewDelegate
extension ReasonReportView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let listArray = self.listArray, listArray.count > 0 else {
            return
        }
        
        let reason = listArray[indexPath.row]
        delegate?.reasonDidSelect(reason: reason)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let listArray = self.listArray, listArray.count > 0 else {
            return 250
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let listArray = self.listArray, listArray.count > 0 else {
            return 250
        }
        return 50
    }
}

// MARK: - UITableViewDataSource
extension ReasonReportView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listArray = self.listArray, listArray.count > 0 else {
            return 1
        }
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listArray = self.listArray, listArray.count > 0 else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IGSSelectCell", for: indexPath) as! IGSSelectCell
        let reason = listArray[indexPath.row]
        cell.titleLabel.text = reason
        if reason == selectedReason {
            cell.selectedImageView.alpha = 1.0
        } else {
            cell.selectedImageView.alpha = 0.0
        }
        return cell
    }
    
    
}
