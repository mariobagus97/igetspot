
import UIKit

protocol ChooseBankPanelDelegate {
    func setBank(bank: Bank)
    func hideSelf()
}

class ChooseBankPanel: MKViewController {
    var filterView: ChooseBankPanelPage = UINib(nibName: "ChooseBankPanelPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ChooseBankPanelPage
    
    var delegate: ChooseBankPanelDelegate?
    var categoryType: CategoryPageContentType!
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        filterView = ChooseBankPanelPage()
        filterView.delegate = self
//        filterView.setupLayout(categoryPageType: categoryType)
        view.addSubview(filterView)
        
        
        filterView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
        
//        setupIGSNavigationBar()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.presentIGSNavigationBar()
//    }
//
//    override func viewWillFirstAppear() {
//        super.viewWillFirstAppear()
//    }
//
//    override func setupIGSNavigationBar() {
//        setupNavigationBarTitle("Bank")
//
//        var barButtonItem = createCloseBarButtonItem()
//        var barButtonItems = [UIBarButtonItem]()
//        barButtonItems.append(barButtonItem)
//        self.navigationItem.leftBarButtonItems = barButtonItems
//
//        createCloseButton()
//    }
//
//    func createCloseButton(){
//        var barButtonItems = [UIBarButtonItem]()
//        let emptyBarButtonItem = UIBarButtonItem.menuButton(self, action:nil, image: R.image.closeButtonDidClicked, width: 21)
//        barButtonItems.append(emptyBarButtonItem)
//        self.navigationItem.rightBarButtonItems = barButtonItems
//    }
}

//// MARK:- CategoryFilterViewDelegate
extension ChooseBankPanel: ChooseBankPanelPageDelegate {
    func setBank(name: String) {
//        self.delegate?.setBankName(name: name)
    }
    
    func hideSelf(){
        self.delegate?.hideSelf()
    }
}
