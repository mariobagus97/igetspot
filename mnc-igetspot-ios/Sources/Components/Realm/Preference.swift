//
//  KeyValue.swift
//  Oncology Medibase
//
//  Created by Hadi Yazdi on 1/11/17.
//  Copyright © 2017 Hadi Yazdi. All rights reserved.
//

import Foundation
import RealmSwift

class Preference: Object {
    
    static var realm = DataManager.shared.getRealm()
    
    @objc dynamic var key = ""
    @objc dynamic var stringValue: String?
    @objc dynamic var dateValue: Date?
    let intValue = RealmOptional<Int>()
    let floatValue = RealmOptional<Float>()
    let doubleValue = RealmOptional<Double>()
    let boolValue = RealmOptional<Bool>()
    
    override static func primaryKey() -> String? {
        return "key"
    }
    
    
    static func setString(key: String, value: String) {
        let x = Preference()
        x.key = key
        x.stringValue = value
        x.save()
    }
    
    static func setInt(key: String, value: Int) {
        let x = Preference()
        x.key = key
        x.intValue.value = value
        x.save()
    }
    
    static func setFloat(key: String, value: Float) {
        let x = Preference()
        x.key = key
        x.floatValue.value = value
        x.save()
    }
    
    static func setDouble(key: String, value: Double) {
        let x = Preference()
        x.key = key
        x.doubleValue.value = value
        x.save()
    }
    
    static func setBool(key: String, value: Bool) {
        let x = Preference()
        x.key = key
        x.boolValue.value = value
        x.save()
    }
    
    static func setDate(key: String, value: Date) {
        let x = Preference()
        x.key = key
        x.dateValue = value
        x.save()
    }
    
    static func getObject(key: String) -> Preference? {
        return Preference.realm.object(ofType: Preference.self, forPrimaryKey: key as AnyObject)
    }
    
    static func getString(key: String) -> String? {
        return Preference.realm.object(ofType: Preference.self, forPrimaryKey: key as AnyObject)?.stringValue
    }
    
    static func getInt(key: String) -> Int? {
        return Preference.realm.object(ofType: Preference.self, forPrimaryKey: key as AnyObject)?.intValue.value
    }
    
    static func getFloat(key: String) -> Float? {
        return Preference.realm.object(ofType: Preference.self, forPrimaryKey: key as AnyObject)?.floatValue.value
    }
    
    static func getDouble(key: String) -> Double? {
        return Preference.realm.object(ofType: Preference.self, forPrimaryKey: key as AnyObject)?.doubleValue.value
    }
    
    static func getBool(key: String) -> Bool? {
        return Preference.realm.object(ofType: Preference.self, forPrimaryKey: key as AnyObject)?.boolValue.value
    }
    
    static func getDate(key: String) -> Date? {
        return Preference.realm.object(ofType: Preference.self, forPrimaryKey: key as AnyObject)?.dateValue
    }
    
    static func keyExists(key: String) -> Bool {
        if Preference.getObject(key: key) != nil {
            return true
        }
        return false
    }
    
    private func save() {
        try! Preference.realm.write {
            Preference.realm.add(self, update: true)
        }
    }
    
    func delete() {
        try! Preference.realm.write {
            Preference.realm.delete(self)
        }
    }
    
}
