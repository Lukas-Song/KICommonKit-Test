//
//  Int+Common.swift
//  KICommon
//
//  Created by 조승보 on 2022/05/16.
//

import Foundation

// Comma
public extension Int {
    
    var comma: String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedNumber = formatter.string(from: NSNumber(value: self)) ?? ""
        return formattedNumber
    }
}

public extension Int64 {
    
    var comma: String {

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedNumber = formatter.string(from: NSNumber(value: self)) ?? ""
        return formattedNumber
    }
}

public extension Numeric where Self: LosslessStringConvertible {
    var digits: [Int] { string.digits }
}
