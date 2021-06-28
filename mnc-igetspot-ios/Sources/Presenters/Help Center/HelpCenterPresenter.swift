//
//  SearchPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/5/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol HelpCenterView: ParentProtocol {
    func setBrowseHelpContent(list: [String])
    func setQuestionContent(list: [String])
    func createContactUs()
}

class HelpCenterPresenter: MKPresenter {
    private weak var view: HelpCenterView?
//    private var helpService : SearchService?
    
    override init() {
        super.init()
        //        signOutService = SignOutService()
    }
    
    func attachview(_ view: HelpCenterView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func getHelpList(){
        
        self.view?.showLoading()
        self.view?.hideLoading()
        
        var list = [String]()
        
        list.append("Using i Get Spot")
        list.append("Managing your account")
        list.append("Privacy and safety")
        list.append("Policies and Reporting")
        
        var questList = ["Can a user be a customer and a Spot Master with the same account?",
                         "How do I choose what I get notifications about on i Get Spot?",
                         "Where can I find my i Get Spot settings?",
                         "How do I change or reset my i Get Spot password?",
                         "What should I do, when I have a dispute over a transaction with a Spot Master?",
                         "Where is the main office of i Get Spot?"]
        
        self.view?.setBrowseHelpContent(list: list)
        self.view?.setQuestionContent(list: questList)
        self.view?.createContactUs()
    }
}
