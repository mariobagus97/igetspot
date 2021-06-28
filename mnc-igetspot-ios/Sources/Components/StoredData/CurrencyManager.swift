//
//  CurrencyManager.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 15/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

class CurrencyManager {
    
    static let shared = CurrencyManager()
    let predicate = NSPredicate(format: "isChosen == %@", NSNumber(booleanLiteral: true))
    
    fileprivate init() { //This prevents others from using the default '()' initializer for this class.
    }
    
    func initCurrency(){
        if(!currencyHasBeenSet()){
            setUserCurrency(currencyList: currencyValueList())
        }
    }
    
    func setUserCurrency(currencyList: [CurrencyObject], selected: Int? = 0){
        try! DataManager.shared.getRealm().write {
            for index in 0...currencyList.count - 1 {
                if (index != selected){
                    currencyList[index].isChosen = false
                }
            }
            currencyList[selected!].isChosen = true
            DataManager.shared.getRealm().add(currencyList, update: true)
        }
    }
    
    func currencyValueList() -> [CurrencyObject]{
        var currencyList = [CurrencyObject]()
        
        currencyList.append(CurrencyObject.init(currencyId: "1", currencyCode: "IDR", currencyName: "Rupiah", isChosen: true))
        currencyList.append(CurrencyObject.init(currencyId: "2", currencyCode: "USD", currencyName: "US Dollar"))
        currencyList.append(CurrencyObject.init(currencyId: "3", currencyCode: "MYR", currencyName: "Malaysian ringgit"))
        currencyList.append(CurrencyObject.init(currencyId: "4", currencyCode: "SGD", currencyName: "Singaporean Dollar"))
        
        return currencyList
    }
    
    func currencyHasBeenSet() -> Bool {
        if (DataManager.shared.objects(CurrencyObject.self)?.count ?? 0 > 0){
            return true
        }
        return false
    }
    
    func getUserCurrency() -> [CurrencyObject] {
        return (DataManager.shared.objects(CurrencyObject.self)?.toArray(type: CurrencyObject.self))!
    }
    
    func getChosenCurrency() -> CurrencyObject {
        let currency = DataManager.shared.objects(CurrencyObject.self)?.filter(predicate).first
        if (currency != nil){
            return currency!
        }
        
        return CurrencyObject()
    }
}

