//
//  UIColor+Common.swift
//  KICommon
//
//  Created by 조승보 on 2022/05/16.
//

import UIKit

extension UIColor {
    
    public static var askColor: UIColor { fetchColor(#function) }
    public static var bidColor: UIColor { fetchColor(#function) }
    public static var lightBackground: UIColor { fetchColor(#function) }
    public static var darkBackground: UIColor { fetchColor(#function) }
    public static var textColor: UIColor { fetchColor(#function) }
    public static var grayTextColor: UIColor { fetchColor(#function) }
    public static var whiteTextColor: UIColor { fetchColor(#function) }
    public static var lineColor: UIColor { fetchColor(#function) }
    public static var lineColor30: UIColor { fetchColor("lineColor").withAlphaComponent(0.3) }
    public static var dimmedColor: UIColor { fetchColor(#function) }
    public static var hoseColor: UIColor { fetchColor(#function) }
    public static var hnxColor: UIColor { fetchColor(#function) }
    public static var upcomColor: UIColor { fetchColor(#function) }

    private static func fetchColor(_ name: String) -> UIColor {

        guard let color = UIColor(named: name, in: Bundle.Common, compatibleWith: nil) else {
            assertionFailure()
            return .darkGray
        }
        return color
    }
}

extension UIColor {
    
    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            self.init()
        } else {
            var rgbValue:UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)
            
            let r = (rgbValue & 0xff0000) >> 16
            let g = (rgbValue & 0xff00) >> 8
            let b = rgbValue & 0xff

            self.init(red: CGFloat(r) / 0xff, green: CGFloat(g) / 0xff, blue: CGFloat(b) / 0xff, alpha: alpha)
        }
    }
}
