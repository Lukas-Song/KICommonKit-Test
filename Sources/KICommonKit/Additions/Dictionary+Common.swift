//
//  Dictionary+Common.swift
//  KICommon
//
//  Created by 조승보 on 2022/04/28.
//

import Foundation

public extension Dictionary {
    func urlEncodedString() -> String {
        var parts: [String] = []
        for (key, value) in self {
            let part = "\(key)=\(value)"
            parts.append(part)
        }
        let joinedString = parts.joined(separator: "&")
        return joinedString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? joinedString
    }
    
    mutating func merge(_ dictionary: [Key: Value]) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
    
    func componentsKeyValueJoined(seperator: String) -> String {
        var parts: [String] = []
        for (key, value) in self {
            let part = "\(key)=\(value)"
            parts.append(part)
        }
        return parts.joined(separator: seperator)
    }
}

public extension Dictionary where Value == Any {
    
    func intValue(withKey key: Key) -> Int? {
        if let value = self[key] as? String {
            return Int(value)
        } else if let value = self[key] as? Int {
            return value
        }
        
        return 0
    }
    
    func boolValue(withKey key: Key) -> Bool {
        let intValue = self.intValue(withKey: key)
        return intValue != 0
    }
    
    func numberValue(withKey key: Key) -> NSNumber? {
        guard let intValue = self.intValue(withKey: key) else { return nil }
        return NSNumber(value: intValue)
    }
    
    func floatValue(withKey key: Key) -> Float? {
        if let value = self[key] as? Float {
            return value
        } else if let value = self[key] as? NSString {
            return value.floatValue
        }
        return nil
    }

}

public extension Dictionary where Value: Equatable {
    func key(forValue value: Value) -> Key? {
        return first { $0.1 == value }?.0
    }
}

public extension Encodable {
    func dictionary(strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = strategy
        guard let data = try? encoder.encode(self),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                return nil
        }
        return jsonObject as? [String: Any]
    }
}

public extension Collection {
    var jsonString: String? {
        guard JSONSerialization.isValidJSONObject(self) else {
            KILogger.error("Dictionary Json to Convert fail -- \(self)")
            return nil
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return JSONString
            }
        } catch {
            KILogger.error("Dictionary Json --" + error.localizedDescription)
        }
        return nil
    }
    
    var jsonStringPrettyPrinted: NSString? {
        guard JSONSerialization.isValidJSONObject(self) else {
            KILogger.error("Dictionary Json to Convert fail -- \(self)")
            return nil
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            if let JSONString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return JSONString
            }
        } catch {
            KILogger.error("Dictionary Json --" + error.localizedDescription)
        }
        return nil
    }
}
