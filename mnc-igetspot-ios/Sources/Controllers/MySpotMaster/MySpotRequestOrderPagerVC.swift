////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import Parchment

class MySpotRequestOrderPagerVC: MKViewController {
    
    var viewControllers: [UIViewController]!
    var pagingViewController: FixedPagingViewController!
    var selectIndex = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Order Request", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    // MARK: - Private Function
    private func addPagerViews() {
        let orderWaitingTVC = MySpotOrderWaitingTVC(title:NSLocalizedString("Waiting (0)", comment: ""))
        orderWaitingTVC.delegate = self
        
        let orderActiveTVC = MySpotOrderActiveTVC(title:NSLocalizedString("Active (0)", comment: ""))
        orderActiveTVC.delegate = self
        
        let orderSuccessTVC = MySpotOrderSuccessTVC(title:NSLocalizedString("Success (0)", comment: ""))
        orderSuccessTVC.delegate = self
        viewControllers = [orderWaitingTVC, orderActiveTVC, orderSuccessTVC]
        pagingViewController = FixedPagingViewController(viewControllers: viewControllers)
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 30, height: 54)
        pagingViewController.borderColor = Colors.tealBlue
        pagingViewController.indicatorColor = .black
        pagingViewController.font = R.font.barlowRegular(size: 14)!
        pagingViewController.textColor = Colors.brownishGrey
        pagingViewController.selectedFont = R.font.barlowMedium(size: 14)!
        pagingViewController.selectedTextColor = UIColor.black
        pagingViewController.dataSource = self
        
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

    func goToOrderDetail(packageId:String, orderId:String, invoiceID:String?) {
        let orderRequestDetailTVC = MySpotOrderRequestDetailTVC()
        orderRequestDetailTVC.packageId = packageId
        orderRequestDetailTVC.orderId = orderId
        orderRequestDetailTVC.invoiceId = invoiceID ?? ""
        orderRequestDetailTVC.delegate = self
        self.navigationController?.pushViewController(orderRequestDetailTVC, animated: true)
    }
}

// MARK: - PagingViewControllerDataSource
extension MySpotRequestOrderPagerVC: PagingViewControllerDataSource {
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

// MARK: - MySpotOrderWaitingTVCDelegate
extension MySpotRequestOrderPagerVC: MySpotOrderWaitingTVCDelegate {
    func orderWaitingDidClicked(orderId:String, packageId:String) {
        goToOrderDetail(packageId: packageId, orderId: orderId,invoiceID: nil)
    }
    
    func refreshTitle() {
        self.pagingViewController.reloadData()
    }
    
}

// MARK: - MySpotOrderRequestWaitingDetailTVCDelegate
extension MySpotRequestOrderPagerVC: MySpotOrderRequestDetailTVCDelegate {
    func backToMyOrderSuccess() {
        if (pagingViewController != nil && viewControllers != nil) {
            self.pagingViewController.select(index: 1)
            if let orderSuccessTVC = viewControllers[2] as? MySpotOrderSuccessTVC {
                orderSuccessTVC.getOrderSuccessList()
            }
            if let orderActiveTVC = viewControllers[1] as? MySpotOrderActiveTVC {
                orderActiveTVC.getOrderActiveList()
            }
        }
    }
    
    func refreshOrderWaiting() {
        if (pagingViewController != nil && viewControllers != nil) {
            if let orderWaitingTVC = viewControllers[0] as? MySpotOrderWaitingTVC {
                orderWaitingTVC.getOrderWaitingList()
            }
        }
    }
}

// MARK: - MySpotOrderActiveTVCDelegate
extension MySpotRequestOrderPagerVC: MySpotOrderActiveTVCDelegate {
    func orderActiveDidClicked(orderId: String, packageId: String, invoiceID: String) {
        goToOrderDetail(packageId: packageId, orderId: orderId,invoiceID: invoiceID)
    }
    
    func refreshOrderActiveTitle() {
        self.pagingViewController.reloadData()
    }
}


// MARK: - MySpotOrderSuccessTVCDelegate
extension MySpotRequestOrderPagerVC: MySpotOrderSuccessTVCDelegate {
    func orderSuccessDidClicked(orderId: String, packageId: String, invoiceId: String) {
        goToOrderDetail(packageId: packageId, orderId: orderId,invoiceID: nil)
    }
    
    func refreshOrderSuccessTitle() {
        self.pagingViewController.reloadData()
    }
}
