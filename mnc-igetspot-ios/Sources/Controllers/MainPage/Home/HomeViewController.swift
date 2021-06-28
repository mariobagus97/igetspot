//
//  HomeViewController.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 20/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftMessages

class HomeViewController: MKViewController, MKTableViewDelegate {
    
    private var contentView: MKTableView!
    var homeContentCell: HomeContentCell!
    var masterOfTheWeekTableViewCell : MasterOfTheWeekTableViewCell!
    let homePresenter = HomePresenter()
    private let section = MKTableViewSection()
    private let hamburgerButton = UIButton(type: .custom)
    
//    let bgwhite = UIView()
//    let border = UIView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        setupNavigationBar()
        setupTableView()
        contentView.appendSection(section)
        section.appendRow(cell: homeContentCell)
        contentView.reloadData()
        homePresenter.attachview(self)
        getContentForHomepage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentTransparentNavigationBar()
        addLGNotifications()
        scrollViewDidScroll(contentView.tableView)
        homePresenter.getMasterOfTheWeek()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.lt_reset()
        removeNotifications()
        setStatusBarStyle(.default)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupSearchBar(withPlaceHolder: NSLocalizedString("I am looking for…", comment: ""))
        setupBarButtonItem()
    }
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = SearchTVC()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.push(viewController: searchVC)
        return false
    }
    
    // MARK: - MKTableViewDelegate
    func createRows() {
        createHomeContentCell()
        createMasterOfTheWeekCell()
    }
    
    func createSections() {
        
    }
    
    func registerNibs() {
        contentView.registeredCellIdentifiers.append(R.nib.homeContentCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.masterOfTheWeekTableViewCell.name)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        addBorder()
//        border.backgroundColor = Colors.inputTextGray
//        bgwhite.backgroundColor = .white
//        self.view.addSubview(bgwhite)
//        self.view.addSubview(border)
//        border.translatesAutoresizingMaskIntoConstraints = false
//        if #available(iOS 11.0, *) {
//            let guide = self.view.safeAreaLayoutGuide
//            bgwhite.snp.makeConstraints{ make in
//                make.left.top.right.equalTo(guide)
//                make.height.equalTo(3)
//            }
//            border.snp.makeConstraints { make in
//                make.left.right.equalTo(guide)
//                make.top.equalTo(bgwhite.snp.bottom)
//                make.height.equalTo(0.5)
//            }
//        } else {
//            bgwhite.snp.makeConstraints{ make in
//                make.left.top.right.equalTo(view)
//                make.height.equalTo(3)
//            }
//            border.snp.makeConstraints { make in
//                make.left.right.equalTo(view)
//                make.top.equalTo(bgwhite.snp.bottom)
//                make.height.equalTo(0.5)
//            }
//        }
        
        if (scrollView == contentView.tableView) {
            let colorNavBar = UIColor.white
            let navbarChangePoint:CGFloat = 20
            let offsetY = scrollView.contentOffset.y
            if (offsetY > navbarChangePoint) {
                let alpha = min(1, 1 - ((navbarChangePoint + 64 - offsetY) / 64))
                self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: colorNavBar.withAlphaComponent(alpha))
                if (alpha < 0.5) {
                    setStatusBarStyle(.lightContent)
                    navigationController?.navigationBar.shadowImage = UIImage()
                    hamburgerButton.setImage(R.image.hamburgerWhite(), for: .normal)
                } else {
                    setStatusBarStyle(.default)
                    navigationController?.navigationBar.shadowImage = UIImage()
                    hamburgerButton.setImage(R.image.hamburgerBlack(), for: .normal)
                    bgwhite.isHidden = false
                    border.isHidden = false
                }
            } else {
                self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: colorNavBar.withAlphaComponent(0))
                setStatusBarStyle(.lightContent)
                navigationController?.navigationBar.shadowImage = UIImage()
                hamburgerButton.setImage(R.image.hamburgerWhite(), for: .normal)
                
                hideBorder()
            }
        }
        
    }
    
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView){
        hideBorder()
    }
    
    // MARK: - Private Functions
    private func addLGNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOpenSideMenu), name: NSNotification.Name.LGSideMenuWillShowLeftView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideSideMenu), name: NSNotification.Name.LGSideMenuWillHideLeftView, object: nil)
        // Login Observer
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(kLoginNotificationName), object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleOpenSideMenu() {
        homeContentCell.automaticScrollingPager(isSliding: false)
    }
    
    @objc private func handleHideSideMenu() {
        homeContentCell.automaticScrollingPager(isSliding: true)
    }
    
    private func setupBarButtonItem() {
        hamburgerButton.setImage(R.image.hamburgerWhite(), for: .normal)
        hamburgerButton.addTarget(self, action: #selector(hamburgerButtonDidClicked), for: .touchUpInside)
        let hamburgerBarButtonItem = UIBarButtonItem(customView: hamburgerButton)
        self.navigationItem.leftBarButtonItem = hamburgerBarButtonItem
    }
    
    private func getContentForHomepage() {
        homePresenter.getWhatsOnList()
        homePresenter.getFeaturedServices()
        homePresenter.getMasterOfTheWeek()
    }
    
    private func setupTableView() {
        contentView = MKTableView(frame: .zero)
        contentView.registerDelegate(delegate: self)
        if #available(iOS 11.0, *) {
            self.contentView.tableView.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view)
        }
        contentView.backgroundColor = .white
        contentView.tableView.bounces = false
        contentView.reloadData()
    }
    
    private func createHomeContentCell() {
        homeContentCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.homeContentCell.name) as? HomeContentCell
        homeContentCell.delegate = self
    }
    
    private func createMasterOfTheWeekCell() {
        masterOfTheWeekTableViewCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.masterOfTheWeekTableViewCell.name) as? MasterOfTheWeekTableViewCell
        masterOfTheWeekTableViewCell.loadView()
        masterOfTheWeekTableViewCell.delegate = self
    }
    
    private func createSpecialDealsCell() {
        
    }
    
    @objc private func refreshData() {
        contentView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.masterOfTheWeekTableViewCell.removeContent()
            self.getContentForHomepage()
        }
    }
    
    // MARK: - Publics Functions
    override func tryAgainButtonDidClicked() {
        super.tryAgainButtonDidClicked()
        getContentForHomepage()
    }
    
    @objc func hamburgerButtonDidClicked() {
        self.showLeftViewAnimated(nil)
    }
}

// MARK: - HomeView
extension HomeViewController: HomeView {
    func showLoadingView() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        homeContentCell.showLoadingView()
        contentView.reloadData()
    }
    
    func showEmptyView() {
        UIApplication.shared.endIgnoringInteractionEvents()
        showErrorView()
        homeContentCell.hideLoadingView()
        contentView.reloadData()
    }
    
    func setContentFeaturedServices(featuredServices:FeaturedServices) {
        guard let categoryArray = featuredServices.categories, categoryArray.count > 0 else {
            showEmptyView()
            return
        }
        setStatusBarStyle(.lightContent)
        UIApplication.shared.endIgnoringInteractionEvents()
        homeContentCell.hideLoadingView()
        homeContentCell.setContent(categoryArray: categoryArray)
        contentView.reloadData()
    }
    
    func setContentWhatsOn(whatsonList: [Whatson]) {
        if whatsonList.count == 0 {
            showEmptyView()
            return
        }
        setStatusBarStyle(.lightContent)
        UIApplication.shared.endIgnoringInteractionEvents()
        homeContentCell.hideLoadingView()
        homeContentCell.setContent(whatsOnArray: whatsonList)
        contentView.reloadData()
    }
    
    func setContentMasterOfTheWeeks(masters: [MasterPreview]) {
        if (masters.count == 0) {
            return
        }
        if section.hasCell(cell: masterOfTheWeekTableViewCell) == false {
            section.appendRow(cell: masterOfTheWeekTableViewCell)
        }
        masterOfTheWeekTableViewCell.setContent(master: masters)
        contentView.reloadData()
    }
    
    func setContentSpecialDeals(deals:[Deals]) {
        
    }
    
    func hideLoadingView() {
        
    }
}

// MARK: - HomeContentCellDelegate
extension HomeViewController: HomeContentCellDelegate {
    func blogDidClicked(withWhatsOn whatsOn:Whatson, blogArray:[Whatson]?) {
        let blogDetailVC = BlogDetailTVC()
        blogDetailVC.blog = whatsOn
        blogDetailVC.blogArray = blogArray
        blogDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(blogDetailVC, animated: true)
    }
    
    func categoryDidClicked(withCategory homeCategory:HomeCategory) {
        if (homeCategory.categoryName == "More") {
            let serviceVC = ServicesVC()
            serviceVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(serviceVC, animated: true)
        } else {
            let detailVC = CategoryDetailVC()
            detailVC.categoryName = homeCategory.categoryName
            detailVC.categoryId = homeCategory.id
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - MasterOfTheWeekTableViewCellDelegate
extension HomeViewController : MasterOfTheWeekTableViewCellDelegate {
    func masterOfTheWeekDidClicked(withMaster master: MasterPreview) {
        let masterVC = MasterDetailVC()
        masterVC.masterId = master.id
        masterVC.masterName = master.masterName
        masterVC.masterProfileImageUrl = master.imageUrl
        masterVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(masterVC, animated: true)
    }
    
    func seeAllMaster() {
        let masterPreviewVC = MasterPreviewVC()
        masterPreviewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(masterPreviewVC, animated: true)
    }
}
