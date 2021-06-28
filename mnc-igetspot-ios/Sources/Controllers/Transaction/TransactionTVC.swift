////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import Parchment
import FloatingPanel

class TransactionTVC: MKTableViewController {
    
    var viewControllers: [UIViewController]!
    var pagingViewController: FixedPagingViewController!
    var paymentSuccessFPC: FloatingPanelController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.requestAfterLogin), name:NSNotification.Name(kLoginNotificationName), object: nil)
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
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Transaction",comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .hamburgerMenu)
    }
    
    
    // MARK: - Private Function
    private func addPagerViews() {
        let waitingTransactionTVC = WaitingTransactionTVC(title:NSLocalizedString("Waiting (0)", comment: ""))
        waitingTransactionTVC.delegate = self
        
        let activeTransactionTVC = ActiveTransactionTVC(title:NSLocalizedString("Active (0)", comment: ""))
        activeTransactionTVC.delegate = self
        
        viewControllers = [waitingTransactionTVC, activeTransactionTVC]
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
    
    @objc func requestAfterLogin() {
        if (pagingViewController != nil && viewControllers != nil) {
            if let waitingTVC = viewControllers[0] as? WaitingTransactionTVC {
                waitingTVC.removeAllRows()
                waitingTVC.getTransactionWaitingList()
            }
            if let activeTransactionTVC = viewControllers[1] as? ActiveTransactionTVC {
                activeTransactionTVC.removeAllRows()
                activeTransactionTVC.getTransactionActiveList()
            }
        }
    }
    
    func goToMasterAll() {
        let masterPreviewVC = MasterPreviewVC()
        masterPreviewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(masterPreviewVC, animated: true)
    }
    
    func openWaitingTabAndRefreshData() {
        selectTab(index: 0)
        refreshData()
    }
    func openActiveTabAndRefreshData() {
        selectTab(index: 1)
        refreshData()
    }
    
    func refreshData() {
        if (pagingViewController != nil && viewControllers != nil) {
            if let waitingTVC = viewControllers[0] as? WaitingTransactionTVC {
                waitingTVC.getTransactionWaitingList()
            }
            if let activeTransactionTVC = viewControllers[1] as? ActiveTransactionTVC {
                activeTransactionTVC.getTransactionActiveList()
            }
        }
    }
    
    func selectTab(index:Int) {
        if (pagingViewController != nil && viewControllers != nil) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.pagingViewController.select(index: index)
            }
        }
    }
    
    func showPaymentSuccess(txId: String, isFromPushNotifications:Bool = false){
        paymentSuccessFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        paymentSuccessFPC?.surfaceView.cornerRadius = 8.0
        paymentSuccessFPC?.surfaceView.shadowHidden = false
        paymentSuccessFPC?.isRemovalInteractionEnabled = true
        paymentSuccessFPC?.panGestureRecognizer.isEnabled = false
        paymentSuccessFPC?.delegate = self
        
        let contentVC = TransactionVirtualAccountTVC()
        contentVC.txId = txId
        contentVC.delegate = self
        
        // Set a content view controller
        paymentSuccessFPC?.set(contentViewController: contentVC)
        
        //  Add FloatingPanel to self.view
        present(paymentSuccessFPC!, animated: true, completion: nil)
    }
    
    private func hidePaymentSuccess() {
        if let paymentSuccessFPC = self.paymentSuccessFPC {
            paymentSuccessFPC.dismiss(animated: true, completion: nil)
        }
    }
}


// MARK: - PagingViewControllerDataSource
extension TransactionTVC: PagingViewControllerDataSource {
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

// MARK: - WaitingTransactionTVCDelegate, ActiveTransactionTVCDelegate
extension TransactionTVC: WaitingTransactionTVCDelegate, ActiveTransactionTVCDelegate {
    func processPaymentDidClicked(invoiceID : String, orderId: String, total: Int) {
        let paymentTVC = TransactionPaymentTVC()
        paymentTVC.invoiceID = invoiceID
        paymentTVC.orderId = orderId
        paymentTVC.subtotal = "\(total)"
        paymentTVC.delegate = self
        paymentTVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(paymentTVC, animated: true)
    }
    
    func requestStartOrderButtonDidClicked() {
        goToMasterAll()
    }
    
    func refreshTitle() {
        pagingViewController.reloadData()
    }
}

// MARK: - TransactionPaymentTVCDelegate
extension TransactionTVC: TransactionPaymentTVCDelegate {
    func redirectToActiveTab() {
        openWaitingTabAndRefreshData()
    }
}

// MARK: - FloatingPanelControllerDelegate
extension TransactionTVC : FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == paymentSuccessFPC {
            return FullPanelLayout()
        }
        return nil
    }
}

// MARK: - TransactionVirtualAccountTVCDelegate
extension TransactionTVC : TransactionVirtualAccountTVCDelegate{
    func closePanel() {
        hidePaymentSuccess()
    }
}
