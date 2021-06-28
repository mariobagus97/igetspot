////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol SideMenuPageViewDelegate {
    func menuProfileDidClicked()
    func menuAboutDidClicked()
    func menuFavoriteDidClicked()
    func menuWishlistDidClicked()
    func menuContactUsDidClicked()
    func menuTermsConditionDidClicked()
    func menuSettingsDidClicked()
    func menuSignInClicked()
    func closeMenuClicked()
}

class SideMenuPageView: UIView, MKTableViewDelegate {
    
    @IBOutlet weak var containerView:UIView!
    
    var menuProfileCell: MenuProfileCell!
    var menuListCell: MenuListCell!
    var menuSocialMediaCell : MenuSocialMediaCell!
    var headerSection: MKTableViewSection!
    var listSection: MKTableViewSection!
    var contentView: MKTableView!
    var delegate: SideMenuPageViewDelegate?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    // MARK: - lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        self.backgroundColor = .clear
        self.containerView.backgroundColor = .gray
    }
    
    private func createProfileCell() {
        menuProfileCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.menuProfileCell.name) as? MenuProfileCell
        menuProfileCell.delegate = self
    }
    
    private func createMenuListCell() {
        menuListCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.menuListCell.name) as? MenuListCell
    }
    
    // MARK: - Public Functions
    func setupMenuView() {
        contentView = MKTableView(frame: .zero)
        contentView.registerDelegate(delegate: self)
        contentView.tableView.isScrollEnabled = false
        self.containerView.addSubview(contentView)
        
        let topOffset:CGFloat = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 100 : 120
        
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.containerView)
            make.top.equalTo(self.containerView).offset(topOffset)
        }
    }
    
    func hideProfile() {
        menuProfileCell.alpha = 0.0
        showSignInCell(isShow: true)
    }
    
    func showProfile(withImageUrl imageUrl:String?, withName name:String, andBalance balance:String) {
        menuProfileCell.alpha = 1.0
        menuProfileCell.setBalance(balance)
        menuProfileCell.setProfileImage(imageUrl: imageUrl, andName: name)
        showSignInCell(isShow: false)
        contentView.reloadData()
    }
    
    func setContent(withMenuItems menuItemsArray:[MenuItems]) {
        listSection.removeAllRows()
        for menuItems in menuItemsArray {
            createMenuListCell()
            menuListCell.setupCell(forMenuItems: menuItems)
            menuListCell.delegate = self
            listSection.appendRow(cell: menuListCell)
        }
        contentView.reloadData()
    }
    
    func showSignInCell(isShow:Bool) {
        for cell in listSection.cells {
            if let menulistCell = cell as? MenuListCell, let menuItem = menulistCell.menuItems {
                if menuItem.getItem() == MenuItem.SignIn.value {
                    menulistCell.isHidden = !isShow
                }
            }
        }
    }
    
    // MARK: - MKTableViewDelegate
    func createRows() {
        createProfileCell()
        createMenuListCell()
    }
    
    func createSections() {
        headerSection = MKTableViewSection()
        headerSection.appendRow(cell: menuProfileCell)
        contentView.appendSection(headerSection)
        
        listSection = MKTableViewSection()
        contentView.appendSection(listSection)
        
        contentView.reloadData()
    }
    
    func registerNibs() {
        contentView.registeredCellIdentifiers.append(contentsOf: [
            R.nib.menuProfileCell.name,
            R.nib.menuListCell.name,
            R.nib.menuSignInCell.name
            ])
    }
    
    @IBAction func closeMenu(_ sender: Any) {
        delegate?.closeMenuClicked()
    }
}

// MARK: - MenuProfileCellDelegate
extension SideMenuPageView: MenuProfileCellDelegate {
    func profileDidClicked() {
        delegate?.menuProfileDidClicked()
    }
}

// MARK: - MenuListCellDelegate
extension SideMenuPageView: MenuListCellDelegate {
    func menuListDidSelected(withMenuItems menuItems: MenuItems) {
        switch menuItems.getItem() {
        case MenuItem.About.value:
            delegate?.menuAboutDidClicked()
            break
        case MenuItem.Favorite.value:
            delegate?.menuFavoriteDidClicked()
            break
        case MenuItem.Wishlist.value:
            delegate?.menuWishlistDidClicked()
            break
        case MenuItem.HelpCenter.value:
            delegate?.menuContactUsDidClicked()
            break
        case MenuItem.TAndC.value:
            delegate?.menuTermsConditionDidClicked()
            break
        case MenuItem.Settings.value:
            delegate?.menuSettingsDidClicked()
            break
        case MenuItem.SignIn.value:
            delegate?.menuSignInClicked()
            break
        default:
            break
        }
    }
}
