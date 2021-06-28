////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol SearchLocationPanelViewDelegate:class {
    func locationSearchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    func searchBarTextDidChange(searchText: String)
    func getPlaceDetail(place:GooglePlace)
    func openSelectViaMap()
}

class SearchLocationPanelView: UIView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var delegate: SearchLocationPanelViewDelegate?
    var placeArray: [GooglePlace]?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        adjustLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        adjustLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    func adjustLayout() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LocationPlaceCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        tableView.register(UINib(nibName: "SelectViaMapCell", bundle: nil), forCellReuseIdentifier: "SelectViaMapCell")
        setupSearchBar()
    }

    func setupSearchBar() {
        searchBar.placeholder = NSLocalizedString("Search for a location", comment: "")
        searchBar.backgroundColor = .clear
        searchBar.delegate = self
        changeBackgroundColor(color: UIColor.rgb(red: 207, green: 216, blue: 220))
    }
    
    func changeBackgroundColor(color: UIColor) {
        // change textfield background color on searchbar

        //let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField
        searchBar.textField?.backgroundColor = color
        
        guard #available(iOS 13, *) else {
            // remove black background color
            for subView in searchBar.subviews {
                for view in subView.subviews {
                    if view.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                        let imageView = view as! UIImageView
                        imageView.removeFromSuperview()
                    }
                }
            }
            return
        }
    }
    
    func setContent(googlePlaces:[GooglePlace]?) {
        placeArray = googlePlaces
        self.tableView.reloadData()
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.isEmptyOrWhitespace() == false else {
            print("nothing to search")
            return
        }
        delegate?.searchBarTextDidChange(searchText: query)
    }
}

// MARK: - UISearchBarDelegate
extension SearchLocationPanelView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.alpha = 1.0
        delegate?.locationSearchBarTextDidBeginEditing(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 1.25)
    }
}

// MARK: - UITableViewDataSource
extension SearchLocationPanelView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let placeArray = self.placeArray, placeArray.count > 0 else {
            return 1
        }
        return placeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let placeArray = self.placeArray, placeArray.count > 0 else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LocationPlaceCell
        let googlePlace = placeArray[indexPath.row]
        cell.titleLabel.text = googlePlace.placeName
        cell.subTitleLabel.text = googlePlace.address
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchLocationPanelView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let placeArray = self.placeArray, placeArray.count > 0 else {
            return
        }
        let googlePlace = placeArray[indexPath.row]
        delegate?.getPlaceDetail(place: googlePlace)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let placeArray = self.placeArray, placeArray.count > 0 else {
            return 200
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let placeArray = self.placeArray, placeArray.count > 0 else {
            return 200
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "SelectViaMapCell") as! SelectViaMapCell
        headerCell.delegate = self
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
}

// MARK: - SelectViaMapCellDelegate
extension SearchLocationPanelView: SelectViaMapCellDelegate {
    func selectViaMapDidTapped() {
        delegate?.openSelectViaMap()
    }
}

extension UISearchBar {

    var textField : UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            // Fallback on earlier versions
            for view : UIView in (self.subviews[0]).subviews {
                if let textField = view as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
}
