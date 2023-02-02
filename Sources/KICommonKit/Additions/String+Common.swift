//
//  String+Common.swift
//  Genie
//
//  Created by 조승보 on 2022/04/26.
//

import Foundation
import UIKit

// Localized
public extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func localized(with: CVarArg = [], comment: String) -> String {
        return NSLocalizedString(self, value: String(format: self.localized, with), comment: comment)
    }
}

// Image
@available(iOS 13.0, *)
public extension String {
    
    var systemImage: UIImage {
        return UIImage(systemName: self) ?? UIImage()
    }
    
    func systemImage(size: CGFloat, weight: UIImage.SymbolWeight = .regular, scale: UIImage.SymbolScale = .default) -> UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: size, weight: weight, scale: scale)
        return UIImage(systemName: self, withConfiguration: configuration) ?? UIImage()
    }
}

// For UINib
public extension String {
    
    func nib(bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: self, bundle: bundle)
    }
}

// For UIView
public extension String {
    
    func viewFromNib(bundle: Bundle? = nil, index: Int = 0) -> UIView? {
        return self.nib(bundle: bundle).instantiate(withOwner: nil, options: nil)[index] as? UIView
    }
}

// Encoding
public extension String {
    
    func stringByURLEncodingWithUTF8StringEncoding() -> String? {
        let allowSet = CharacterSet(charactersIn: "{}^!*'\"();:@&=+$,/?%#[]% ").inverted
        return addingPercentEncoding(withAllowedCharacters: allowSet)
    }
}

// Comma```````````````````````````````````````````````````````````````````````````````````````````````````````
public extension String {
    
    var comma: String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedNumber = formatter.string(from: NSNumber(value: Double(self) ?? 0)) ?? ""
        return formattedNumber
    }
    
    var amount: String {
        
        let suffix = ["", "K", "M", "B", "T", "P", "E"]
        var number = self.toFloat()
        
        var index = 0
        while( (number / 1000) >= 1 ) {
            number = number / 1000
            index += 1
        }
        if index == 0 {
            return String(format: "%d%@", Int(number), suffix[index])
        }
        return String(format: "%.1f%@", number, suffix[index])
    }

    var percent: String {
        return self + "%"
    }
    
    // 143020 -> 14:30:20
    var time: String {

        var temp: String = self
        if temp.count < 6 {
            temp = "0" + temp
        }
        temp.insert(":", at: temp.index(startIndex, offsetBy: 4))
        temp.insert(":", at: temp.index(startIndex, offsetBy: 2))
        return temp
    }
    
    // 20220810 -> 2022/08/10
    var date: String {
        
        var temp: String = self
        temp.insert("/", at: temp.index(startIndex, offsetBy: 6))
        temp.insert("/", at: temp.index(startIndex, offsetBy: 4))
        return temp
    }
    
    // 20221005161716 -> 2022/08/10,14:30:20
    var dateTime: String {
        
        let date = self.to(8).date
        let time = self.from(8).time
        return date + "," + time
    }
    
    // 22,000 -> 22000
    var numberOnly: String {
        return self.replacingOccurrences(of: ",", with: "")
    }
    
    // 07/10/2022 -> 20221007
    var yyyyMMdd: String {
        
        let components = self.components(separatedBy: "/")
        if components.count == 3 {
            return components[2] + components[1] + components[0]
        }
        
        return self
    }
    
    // 20221007 -> 07/10/2022
    var ddMMyyyy: String {
        return self.from(6) + "/" + self.subString(from: 4, to: 6) + "/" + self.to(4)
    }
}

// Size
public extension String {
    
    func size(font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size
    }
    
    func width(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func height(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func height(font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func height(attributes: [NSAttributedString.Key : Any], width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return boundingBox.height
    }
    
    func textSize(with font: UIFont, forWidth: CGFloat = CGFloat.greatestFiniteMagnitude, lineBreakMode: NSLineBreakMode = .byWordWrapping, textAlignment: NSTextAlignment = .left) -> CGSize {
        return textSize(with: font, constrained: CGSize(width: forWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: lineBreakMode, textAlignment: textAlignment)
    }
    
    func textSize(with font: UIFont, constrained toSize: CGSize, lineBreakMode: NSLineBreakMode = .byWordWrapping, textAlignment: NSTextAlignment = .left) -> CGSize {
        let sizingText = self
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = lineBreakMode
        style.alignment = textAlignment
        let textFont: UIFont = font
        return (sizingText as NSString).boundingRect(with: toSize, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: textFont], context: nil).size
    }
}

// Substring
public extension String {
    
    func to(offset: Int, appendingEllipsis: String? = nil) -> String {
        guard self.count > offset else {
            return self
        }
        
        let string = String(self[startIndex..<index(startIndex, offsetBy: offset)])
        if let ellipsis = appendingEllipsis {
            return "\(string)\(ellipsis)"
        }
        return string
    }
    
    func from(offset: Int) -> String {
        guard self.count > offset else {
            return ""
        }
        return String(self[index(startIndex, offsetBy: offset)..<endIndex])
    }
    
    func toNumber() -> NSNumber? {
        if let number = Int64(self) {
            return NSNumber(value: number)
        } else if let double = Double(self) {
            return NSNumber(value: double)
        } else {
            return nil
        }
    }
    
    func boolValue(defaultVaule: Bool = false) -> Bool {
        let trueValues = ["true", "yes", "1"]
        let falseValues = ["false", "no", "0"]
        
        let lowerSelf = lowercased()
        if trueValues.contains(lowerSelf) {
            return true
        } else if falseValues.contains(lowerSelf) {
            return false
        }
        return defaultVaule
    }
    
    func toURL() -> URL? {
        if let url = URL(string: self) {
            return url
        } else {
            return nil
        }
    }
    
    func toInt() -> Int {
        var value: Int = 0
        if let intValue = Int(self) {
            value = intValue
        }
        return value
    }
    
    func toInt64() -> Int64 {
        var value: Int64 = 0
        if let intValue = Int64(self) {
            value = intValue
        }
        return value
    }
    
    func toFloat() -> Float {
        var value: Float = 0.0
        if let floatValue = Float(self) {
            value = floatValue
        }
        return value
    }

    func toStringDictionary() -> [String: String] {
        var dictionary = [String: String]()
        let keyValues = components(separatedBy: "&")
        for keyValue in keyValues {
            let newKeyValue = keyValue.components(separatedBy: "=")
            if newKeyValue.count > 1, let value = newKeyValue[1].removingPercentEncoding {
                dictionary[newKeyValue[0]] = value
            }
        }
        return dictionary
    }

    func at(_ index: Int) -> String {
        
        guard index > 0 && self.count >= index else {
            return self
        }
        
        return String(self[self.index(self.startIndex, offsetBy: index)])
    }
    
    func at(_ index: Int) -> Character {
        
        guard index > 0 && self.count >= index else {
            return self[self.index(self.startIndex, offsetBy: 0)]
        }
        
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    func from(_ index: Int) -> String {
        
        guard index > 0 && self.count >= index else {
            return self
        }
        
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    
    func to(_ index: Int) -> String {
        
        guard index > 0 && self.count >= index else {
            return self
        }
        
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func subString(from: Int, to: Int) -> String {
        
        guard from > 0 && self.count >= from && from < to && self.count >= to else {
            return self
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
    
    func subString(from: Int, count: Int) -> String {
        
        guard from > 0 && self.count >= from && self.count >= from + count else {
            return self
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(startIndex, offsetBy: count)
        return String(self[startIndex..<endIndex])
    }
    
    func subString(index: String.Index, count: Int) -> String {
        
        let endIndex = self.index(index, offsetBy: count)
        return String(self[index..<endIndex])
    }
    
    func remove(from: Int, count: Int) -> String {
        
        guard from >= 0 && self.count >= from && self.count >= from + count else {
            return self
        }
        
        var result = self
        
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(startIndex, offsetBy: count)
        result.removeSubrange(startIndex..<endIndex)
        
        return result
    }
    
    func removeLast() -> String {
        return remove(from: count - 1, count: 1)
    }
    
    static func - (left: String, right: String) -> String {
        
        var result = left
        
        if let index = left.firstIndex(of: right.at(0)) {
            
            let substring = result.subString(index: index, count: right.count - 1)
            if substring == right {
                result.removeSubrange(index...left.index(index, offsetBy: right.count))
                return result
            }
        }
        
        return result
    }
}

// Compare

public extension String {
    
    var isNumber: Bool {
        return self.filter({ $0.isNumber }).count > 0
    }
}

// Currency Symbol
public extension String {
    
    var dong: String {
        return "₫" + self
    }
}

public extension StringProtocol {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}

public extension LosslessStringConvertible {
    var string: String { .init(self) }
}
