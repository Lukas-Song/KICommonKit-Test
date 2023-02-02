//
//  Properties+Util.swift
//  KICommon
//
//  Created by 조승보 on 2022/08/01.
//

import Foundation
import CryptoSwift

public typealias PR = Properties

public extension Properties {
    
    enum PropertyList: String {
        case shownWalkthrough
        case clientID
        case password
        case credential
        case initialVector
        case rememberMe
        case accessToken
        case refreshToken
        case userInfo
        case subaccounts
        case selectedGroupIndex
        case favoriteStocks
        case chartType
        case otpToken
        case otpRemember
        case otpIsSMS
        case otpPeriod
        case homeViewMode
        case bubbles
        case homeType
        case detailEnabled
        case netfox
        case assetEncryption
        case portfolioAssetLightWeightChart
    }
}


// MARK: - Utils
public extension Properties {
    
    // password only
    func savePassword(password: String, userID: String) {
        
        let salt = Data(userID.utf8)
        
        if let credential = CryptoManager.credential(password: password, salt: salt) {
            
            let data = Data(password.utf8)
            let iv = Data(AES.randomIV(AES.blockSize))

            if let encryptedData = CryptoManager.encrypt(key: credential, initialVector: iv, data: data) {
                
                PR.shared.setObject(encryptedData, forKey: PR.shared.key(.password))
                PR.shared.setObject(credential, forKey: PR.shared.key(.credential))
                PR.shared.setObject(iv, forKey: PR.shared.key(.initialVector))
                
                PR.shared.save()
            }
        }
    }
    
    // password only
    func loadPassword() -> String? {
        
        if let encryptedData = PR.shared.object(forKey: PR.shared.key(.password)) as? Data,
           let credential = PR.shared.object(forKey: PR.shared.key(.credential)) as? Data,
           let iv = PR.shared.object(forKey: PR.shared.key(.initialVector)) as? Data,
           let decryptedData = CryptoManager.decrypt(key: credential, initialVector: iv, data: encryptedData) {
            
            return String(data: decryptedData, encoding: .utf8)
        }
        
        return nil
    }
    
    // to save struct object
    func saveWithEncoding<T: Encodable>(value: T, key: String) {
        
        do {
            
            let encodedData = try PropertyListEncoder().encode(value)
            PR.shared.setObject(encodedData, forKey: key)
            
        } catch {
            KILogger.error(error)
        }
    }
    
    // to load struct object
    func loadWithDecoding<T: Decodable>(type: T.Type, key: String) -> T? {
        
        do {
            
            if let encodedData = PR.shared.object(forKey: key) as? Data {
                let decodedData = try PropertyListDecoder().decode(type, from: encodedData)
                return decodedData
            }
            
        } catch {
            KILogger.error(error)
        }
        
        return nil
    }
}
