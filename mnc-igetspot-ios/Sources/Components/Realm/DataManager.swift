////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class DataManager {
    static let shared = DataManager()
    
    func getRealm() -> Realm {
        if let _ = NSClassFromString("XCTest") {
            return try! Realm(configuration: Realm.Configuration(fileURL: nil, inMemoryIdentifier: "test", encryptionKey: nil, readOnly: false, schemaVersion: 0, migrationBlock: nil, objectTypes: nil))
        } else {
            let config = Realm.Configuration(
                // Set the new schema version. This must be greater than the previously used.
                schemaVersion: 2,
                
                migrationBlock: { migration, oldSchemaVersion in
                    print("migrationBlock Running")
                    if (oldSchemaVersion < 2) {
                        migration.deleteData(forType: "User")
                    }
            }
            )
            Realm.Configuration.defaultConfiguration = config
            return try! Realm();
        }
    }
    
    func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        if !isRealmAccessible() { return nil }
        
        let realm = getRealm()
        realm.refresh()
        
        return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
    }
    
    func object<T: Object>(_ type: T.Type, key: Any) -> T? {
        if !isRealmAccessible() { return nil }
        
        let realm = getRealm()
        realm.refresh()
        
        return realm.object(ofType: type, forPrimaryKey: key)
    }
    
    func add<T: Object>(_ data: [T], update: Bool = true) {
        if !isRealmAccessible() { return }
        
        let realm = getRealm()
        realm.refresh()
        
        if realm.isInWriteTransaction {
            realm.add(data, update: update)
        } else {
            try? realm.write {
                realm.add(data, update: update)
            }
        }
    }
    
    func add<T: Object>(_ data: T, update: Bool = true) {
        add([data], update: update)
    }
    
    func runTransaction(action: () -> Void) {
        if !isRealmAccessible() { return }
        
        let realm = getRealm()
        realm.refresh()
        
        try? realm.write {
            action()
        }
    }
    
    func delete<T: Object>(_ data: [T]) {
        let realm = getRealm()
        realm.refresh()
        try? realm.write { realm.delete(data) }
    }
    
    func delete<T: Object>(_ data: T) {
        delete([data])
    }
    
    func deleteAll<T:Object>(_ ofType:T.Type) {
        let realm = getRealm()
        realm.refresh()
        try? realm.write { realm.delete(realm.objects(ofType)) }
    }
    
    func clearAllData() {
        if !isRealmAccessible() { return }
        
        let realm = getRealm()
        realm.refresh()
        try? realm.write { realm.deleteAll() }
    }
}

extension DataManager {
    func isRealmAccessible() -> Bool {
        do { _ = try Realm() } catch {
            print("Realm is not accessible")
            return false
        }
        return true
    }
    
    func configureRealm() {
        let config = RLMRealmConfiguration.default()
        config.deleteRealmIfMigrationNeeded = true
        RLMRealmConfiguration.setDefault(config)
    }
}

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
