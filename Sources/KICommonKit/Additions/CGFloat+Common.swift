//
//  CGFloat+Common.swift
//  Genie
//
//  Created by 조승보 on 2022/04/14.
//

import UIKit

public extension CGFloat {
    static var e: CGFloat { // swiftlint:disable:this identifier_name
        return 2.71828182845904523536028747135266250
    }
    
    var noScaleLineWidth: CGFloat {
        return (1 / UIScreen.main.scale) * self
    }
    
    static var marginBetweenImages: CGFloat {
        return 0
    }
    
    var toRadian: CGFloat {
        return self * CGFloat.pi / 180
    }
    
    var toDegree: CGFloat {
        return self * 180 / CGFloat.pi
    }
    
    var toInt: Int {
        return Int(self)
    }

    var toFloat: Float {
        return Float(self)
    }
    
    var toDouble: Double {
        return Double(self)
    }
    
    var toTimeInterval: Double {
        return TimeInterval(self)
    }
    
    func snapTo(points: [CGFloat]) -> CGFloat {
        guard !points.isEmpty else { return self }
        return points.map({ abs($0 - self) }).sorted().first ?? self
    }
    
    func snapTo(upperBound points: [CGFloat]) -> CGFloat {
        guard !points.isEmpty else { return self }
        return points.compactMap({
            let subtracted = $0 - self
            return subtracted >= 0 ? subtracted : nil
        }).sorted().first ?? self
    }

    func multiply(_ value: CGFloat) -> CGFloat {
        return self * value
    }

    func divide(_ value: CGFloat) -> CGFloat {
        return self / value
    }
}
