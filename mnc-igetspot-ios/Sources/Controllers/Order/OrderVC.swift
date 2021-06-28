////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import Parchment


class OrderVC: MKViewController {
    
    var pagingViewController: FixedPagingViewController!
    var viewControllers: [UIViewController]!
    var requestOrderTVC : RequestOrderTVC!
    var historyOrderTVC : HistoryOrderTVC!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name:NSNotification.Name(kLoginNotificationName), object: nil)
        setupNavigationBar()
        addPagerViews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                   self.pagingViewController.reloadMenu()
                   self.pagingViewController.select(index: 0)
               }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Private Function
    private func addPagerViews() {
        requestOrderTVC = RequestOrderTVC(title:NSLocalizedString("Waiting (0)", comment: ""))
        requestOrderTVC.delegate = self
        historyOrderTVC = HistoryOrderTVC(title:NSLocalizedString("Active (0)", comment: ""))
        historyOrderTVC.delegate = self
        viewControllers = [requestOrderTVC, historyOrderTVC]
        pagingViewController = FixedPagingViewController(viewControllers: viewControllers)
        pagingViewController.dataSource = self
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 30, height: 54)
        pagingViewController.borderColor = Colors.tealBlue
        pagingViewController.indicatorColor = .black
        pagingViewController.font = R.font.barlowRegular(size: 14)!
        pagingViewController.textColor = Colors.brownishGrey
        pagingViewController.selectedFont = R.font.barlowMedium(size: 14)!
        pagingViewController.selectedTextColor = UIColor.black
        
        pagingViewController.indicatorOptions = .visible(
            height: 2,
            zIndex: Int.max,
            spacing: UIEdgeInsets.zero,
            insets: UIEdgeInsets.zero
        )
        
        pagingViewController.borderOptions = .visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets.zero
        )
        
        // Make sure you add the PagingViewController as a child view
        // controller and constrain it to the edges of the view.
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.view.snp.makeConstraints{ (make) in
            make.top.left.right.bottom.equalTo(view)
        }
        pagingViewController.didMove(toParent: self)
    }
    
    @objc func refreshData() {
        if viewControllers != nil {
            if let requestOderTVC = viewControllers[0] as? RequestOrderTVC {
                requestOderTVC.removeAllRows()
                requestOderTVC.getRequestOrderList()
            }
            if let historyOrderTVC = viewControllers[1] as? HistoryOrderTVC {
                historyOrderTVC.removeAllRows()
                historyOrderTVC.getHistoryOrderList()
            }
        }
    }
    
    func openRequestTabAndRefreshData() {
        selectTab(index: 0)
        refreshData()
    }
    func openSuccessTabAndRefreshData() {
        selectTab(index: 1)
        refreshData()
    }
    
    func selectTab(index:Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pagingViewController.select(index: index)
        }
    }
    
    func goToMasterAll() {
        let masterPreviewVC = MasterPreviewVC()
        masterPreviewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(masterPreviewVC, animated: true)
    }
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if ((pagingViewController.selectedIndex) == 0){
            if (searchText != "" && searchText != " "){ 
                self.requestOrderTVC.searchOrder(keyword: searchText)
            } else {
                self.requestOrderTVC.resetOrder()
            }
        } else if ((pagingViewController.selectedIndex) == 1) {
            if (searchText != "" && searchText != " "){
                self.historyOrderTVC.searchHistory(keyword: searchText)
            } else {
                self.historyOrderTVC.resetHistory()
            }
        }
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    override func setupNavigationBar() {
          super.setupNavigationBar()
          setupNavigationBarTitle(NSLocalizedString("My Order",comment: ""))
          setupLeftBackBarButtonItems(barButtonType: .hamburgerMenu)
    }
}

// MARK: - PagingViewControllerDataSource
extension OrderVC: PagingViewControllerDataSource {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        return PagingIndexItem(index: index, title: viewControllers[index].title ?? "") as! T
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }
    
    func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int {
        return viewControllers.count
    }
    
}

// MARK: - RequestOrderTVCDelegate
extension OrderVC: RequestOrderTVCDelegate {
    func requestStartOrderButtonDidClicked() {
        goToMasterAll()
    }
    
    func refreshTitle() {
        self.pagingViewController.reloadData()
    }
}

// MARK: - HistoryOrderTVCDelegate
extension OrderVC: HistoryOrderTVCDelegate {
   
    func historyOrderDidClicked(masterName: String, masterId: String, orderId: String,packageId:String) {
        let historyOrderDetailTVC = HistoryOrderDetailTVC()
        historyOrderDetailTVC.masterId = masterId
        historyOrderDetailTVC.masterName = masterName
        historyOrderDetailTVC.orderId = orderId
        historyOrderDetailTVC.packageId = packageId
        self.navigationController?.pushViewController(historyOrderDetailTVC, animated: true)
    }
    
    func historyStartOrderButtonDidClicked() {
         goToMasterAll()
    }
}

extension FixedPagingViewController {
    
    var selectedIndex: Int? {
        if let selected = pageViewController.selectedViewController, let index = viewControllers.index(of: selected) {
            return index
        }
        return -1
    }
}
