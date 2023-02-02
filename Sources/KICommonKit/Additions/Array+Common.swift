//
//  Array+Common.swift
//  KICommon
//
//  Created by 조승보 on 2022/04/28.
//

import Foundation

public extension Array where Element: Equatable {
    func mergedIf(overlap: [Element]) -> [Element] {
        guard let first = overlap.first else { return self }
        var result = overlap
        if let index = firstIndex(of: first), index > 0 {
            result = Array(self[0..<index]) + result
        }
        return result
    }
    
    func next(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index + 1 <= self.count {
            return index + 1 == self.count ? self[0] : self[index + 1]
        }
        return nil
    }

    func prev(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index >= 0 {
            return index == 0 ? self.last : self[index - 1]
        }
        return nil
    }
    
    static func -=(lhs: inout Array, rhs: Array) {
        rhs.forEach {
            if let indexOfhit = lhs.firstIndex(of: $0) {
                lhs.remove(at: indexOfhit)
            }
        }
    }

    static func -(lhs: Array, rhs: Array) -> Array {
        return lhs.filter { return !rhs.contains($0) }
    }
}

public extension Array where Element: Codable {
    var jsonString: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            KILogger.error(error.localizedDescription)
        }
        return nil
    }
}

public extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

public extension Array {
    func castingMap<TO>(to: TO.Type) -> [TO] {
        compactMap({ $0 as? TO })
    }
}
