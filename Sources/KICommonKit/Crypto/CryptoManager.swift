//
//  CryptoManager.swift
//  KICommon
//
//  Created by 조승보 on 2022/07/29.
//

import UIKit
import CryptoSwift
import CommonCrypto

class CryptoManager: NSObject {

    static func encrypt(key: Data, initialVector: Data, data: Data) -> Data? {
        do {
            let encryptedData = Data(try AES(key: key.bytes, blockMode: CTR(iv: initialVector.bytes), padding: .noPadding).encrypt(data.bytes))

            return encryptedData
        } catch {
            return nil
        }
    }

    static func decrypt(key: Data, initialVector: Data, data: Data) -> Data? {
        do {
            let decryptedData = Data(try AES(key: key.bytes, blockMode: CTR(iv: initialVector.bytes), padding: .noPadding).decrypt(data.bytes))

            return decryptedData
        } catch {
            return nil
        }
    }

    static func credential(password: String, salt: Data) -> Data? {
        keyDerivation(password: password, salt: salt, rounds: 4096, count: 32)
    }

    private static func keyDerivation(password: String, salt: Data, rounds: UInt32, count: Int) -> Data? {
        guard let passwordData = password.data(using: .utf8) else {
            return nil
        }

        return passwordData.withUnsafeBytes {
            guard let passwordBytes = $0.baseAddress?.assumingMemoryBound(to: Int8.self) else {
                return nil
            }

            return salt.withUnsafeBytes {
                guard let saltBytes = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return nil
                }

                var derivedKey = Data(repeating: 0, count: count)

                return derivedKey.withUnsafeMutableBytes {
                    guard let derivedKeyBytes = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                        return nil
                    }

                    let algorithm = CCPBKDFAlgorithm(kCCPBKDF2)
                    let prf = CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256)

                    guard CCKeyDerivationPBKDF(algorithm,
                                               passwordBytes,
                                               passwordData.count,
                                               saltBytes,
                                               salt.count,
                                               prf,
                                               rounds,
                                               derivedKeyBytes,
                                               count) == errSecSuccess else {

                        return nil
                    }

                    return Data(bytes: derivedKeyBytes, count: count)
                }
            }
        }
    }

}
