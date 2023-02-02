//
//  Properties.swift
//  KICommon
//
//  Created by 조승보 on 2022/08/01.
//

import UIKit

public class Properties: NSObject {

    public static let shared = Properties()

    public func save() {
        UserDefaults.standard.synchronize()
    }

    public func setObject(_ object: Any?, forKey: String) {
        UserDefaults.standard.setValue(object, forKey: forKey)
    }

    public func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

    public func removeObject(forKey: String) {
        UserDefaults.standard.removeObject(forKey: forKey)
    }

    public func object(forKey: String) -> Any? {
        return UserDefaults.standard.object(forKey: forKey)
    }

    public func string(forKey: String) -> String? {
        return UserDefaults.standard.string(forKey: forKey)
    }

    public func int(forkey: String) -> Int? {
        return UserDefaults.standard.integer(forKey: forkey)
    }
    
    public func bool(forkey: String) -> Bool? {
        return UserDefaults.standard.bool(forKey: forkey)
    }
    
    public func double(forkey: String) -> Double? {
        return UserDefaults.standard.double(forKey: forkey)
    }
    
    public func key(_ property: PropertyList) -> String {
        return property.rawValue
    }
}
