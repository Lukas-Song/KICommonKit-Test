//
//  GlobalUtils.swift
//  KICommon
//
//  Created by 조승보 on 2022/08/05.
//

import Foundation

public func safeString<T>(_ value: T?) -> String {
    guard let value = value as? NSNumber else { return "" }
    return String(format:"%@", value)
}

public func safeInt<T>(_ value: T?) -> Int {
    guard let value = value as? NSNumber else { return 0 }
    return value.intValue
}

public func safeDouble<T>(_ value: T?) -> Double {
    guard let value = value as? NSNumber else { return 0 }
    return value.doubleValue
}
