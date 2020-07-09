//
//  Realm+Extensions.swift
//  AppForVK
//
//  Created by Mikhail Semerikov on 27/04/2019.
//  Copyright © 2019 Семериков Михаил. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
    
    static func build<O: Object>(_ builder: (O) -> Void ) -> O {
        let object = O()
        builder(object)
        return object
    }
}

extension Realm {
    
    func writeAsync<T: ThreadConfined>(obj: T, errorHandler: @escaping ((_ error: Swift.Error) -> Void) = { _ in return }, block: @escaping ((Realm, T?) -> Void)) {
        let wrappedObj = ThreadSafeReference(to: obj)
        let config = self.configuration
        DispatchQueue(label: "background").async {
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: config)
                    let obj = realm.resolve(wrappedObj)
                    
                    try realm.write {
                        block(realm, obj)
                    }
                } catch {
                    errorHandler(error)
                }
            }
        }
    }
}
