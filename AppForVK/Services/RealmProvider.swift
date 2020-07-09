//
//  RealmProvider.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 22/02/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import RealmSwift


class RealmProvider {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static func save<T: Object>(items: [T], config: Realm.Configuration = Realm.Configuration.defaultConfiguration, update: Bool = true) {
        print(config.fileURL!)
        
        do {
            let realm = try Realm(configuration: config)
            
            try realm.write {
                realm.add(items, update: update)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func get<T: Object>(_ type: T.Type, config: Realm.Configuration = Realm.Configuration.defaultConfiguration) throws -> Results<T> {
            let realm = try Realm(configuration: config)
            return realm.objects(type)
    }
    
    static func delete<T: Object>(_ items: [T], config: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        let realm = try? Realm(configuration: config)
        ((try? realm?.write {
            realm?.delete(items)
        }) as ()??)
    }
}
