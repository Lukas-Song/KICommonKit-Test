//
//  String+Secure.swift
//  KICommon
//
//  Created by 조승보 on 2022/07/13.
//

import Foundation
import CryptoKit

@available(iOS 13.0, *)
extension String {
    
    public func MD5() -> String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
    
}
