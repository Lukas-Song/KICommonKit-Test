//
//  URL+Common.swift
//  KICommon
//
//  Created by 조승보 on 2022/05/26.
//

import Foundation

public extension URL {
    
    init?(string: String, encoding: String.Encoding) {
        let characterSet = CharacterSet(charactersIn: "!*'\"();:@&=+$,/?%#[]%").union(.urlFragmentAllowed)
        guard let string = string.addingPercentEncoding(withAllowedCharacters: characterSet) else {
           return nil
        }
        self.init(string: string)
    }
    
    var isWeb: Bool {
        if let scheme = scheme?.lowercased() {
            if scheme == "http" || scheme == "https" || scheme == "about" {
                return true
            }
        }
        return false
    }

    func appendingParameters(_ parameters: [String: Any]) -> URL {
        guard parameters.count > 0 else { return self }
        
        var escapedParameterPairs: [String] = []
        
        for (key, value) in parameters {
            var escapedValue: String?
            
            if let stringValue = value as? String {
                escapedValue = stringValue.stringByURLEncodingWithUTF8StringEncoding()
            } else if let numberValue = value as? NSNumber {
                escapedValue = numberValue.stringValue
            } else {
                NSException(name: .invalidArgumentException, reason: "the parameter value \(value) is not kind of String or NSNumber", userInfo: nil).raise()
            }
            
            let pair = "\(key)=\((escapedValue ?? ""))"
            escapedParameterPairs.append(pair)
        }
        
        let queryForParameters = escapedParameterPairs.joined(separator: "&")
        let separator = self.query != nil ? "&" : "?"
        let urlStringWithParameters = "\(self.absoluteString)\(separator)\(queryForParameters)"
        
        return URL(string: urlStringWithParameters) ?? self
    }

    func byAddingQueryParameters(_ parameters: [String: Any]?) -> URL {
        guard let parameters = parameters, var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        var queryItems: [URLQueryItem] = components.queryItems ?? []
        for (key, value) in parameters {
            queryItems = queryItems.filter({ $0.name != key })
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }

        var encodedQueryItems = [URLQueryItem]()
        for queryItem in queryItems {
            if let value = queryItem.value?.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) {
                encodedQueryItems.append(URLQueryItem(name: queryItem.name, value: value))
            }
        }
        components.queryItems = encodedQueryItems
        return components.url ?? self
    }

    func queryToDictionary() -> [String: String] {
        var params = [String: String]()
        if let query = self.query {
            for paramPairString in query.components(separatedBy: "&") {
                let paramPair = paramPairString.components(separatedBy: "=")
                if paramPair.count == 2 {
                    var value: String = paramPair[1]
                    if value.range(of: "+") != nil {
                        value = value.replacingOccurrences(of: "+", with: " ")
                    }
                    if let result = value.removingPercentEncoding,
                        let key = paramPair[0].removingPercentEncoding {
                        params.updateValue(result, forKey: key)
                    }
                }
            }
        }
        
        return params
    }
}
