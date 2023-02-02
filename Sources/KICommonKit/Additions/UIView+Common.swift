//
//  UIView+Common.swift
//  Genie
//
//  Created by 조승보 on 2022/03/17.
//

import UIKit

// @IBInspectable
public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColour: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        } set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
}

public extension UIStackView {
    
    @IBInspectable var marginTop: CGFloat {
        get {
            return layoutMargins.top
        } set {
            layoutMargins.top = newValue
            isLayoutMarginsRelativeArrangement = true
        }
    }

    @IBInspectable var marginBottom: CGFloat {
        get {
            return layoutMargins.bottom
        } set {
            layoutMargins.bottom = newValue
            isLayoutMarginsRelativeArrangement = true
        }
    }

    @IBInspectable var marginLeft: CGFloat {
        get {
            return layoutMargins.left
        } set {
            layoutMargins.left = newValue
            isLayoutMarginsRelativeArrangement = true
        }
    }

    @IBInspectable var marginRight: CGFloat {
        get {
            return layoutMargins.right
        } set {
            layoutMargins.right = newValue
            isLayoutMarginsRelativeArrangement = true
        }
    }
}

public extension UIView {
    
    var x: CGFloat {
        get {
            return left
        }
        set {
            left = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return top
        }
        set {
            top = newValue
        }
    }
    
    var left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var newFrame: CGRect = frame
            newFrame.origin.x = newValue
            frame = newFrame
        }
    }
    
    var top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var newFrame: CGRect = frame
            newFrame.origin.y = newValue
            frame = newFrame
        }
    }
    
    var right: CGFloat {
        get {
            return frame.maxX
        }
        set {
            var newFrame: CGRect = frame
            newFrame.origin.x = newValue - frame.size.width
            frame = newFrame
        }
    }
    
    var bottom: CGFloat {
        get {
            return frame.maxY
        }
        set {
            var newFrame: CGRect = frame
            newFrame.origin.y = newValue - frame.size.height
            frame = newFrame
        }
    }
    
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            var newFrame: CGRect = frame
            newFrame.origin = newValue
            frame = newFrame
        }
    }
    
    var centerX: CGFloat {
        get {
            return center.x
        }
        set {
            center = CGPoint(x: newValue, y: center.y)
        }
    }
    
    var centerY: CGFloat {
        get {
            return center.y
        }
        set {
            center = CGPoint(x: center.x, y: newValue)
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            var newFrame: CGRect = frame
            newFrame.size.width = newValue
            frame = newFrame
        }
    }
    
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            var newFrame: CGRect = frame
            newFrame.size.height = newValue
            frame = newFrame
        }
    }
    
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            var newFrame: CGRect = frame
            newFrame.size = newValue
            frame = newFrame
        }
    }
    
    var sx: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var sy: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    var ssize: CGSize {
        return UIScreen.main.bounds.size
    }

    var srect: CGRect {
        return UIScreen.main.bounds
    }
    
    var scenter: CGPoint {
        return CGPoint(x: UIScreen.main.bounds.width / 2.0, y: UIScreen.main.bounds.height / 2.0)
    }

    func ratioWidth(size: CGSize, height: CGFloat) -> CGFloat {
        return size.width * height / size.height
    }
    
    func ratioHeight(size: CGSize, width: CGFloat) -> CGFloat {
        return size.height * width / size.width
    }

    static var sw: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    static var sh: CGFloat {
        return UIScreen.main.bounds.size.height
    }
        
    static var scale: CGFloat {
        return UIScreen.main.scale
    }
}

public extension UIView {
    
    func roundView(radius: CGFloat = 0.0) {
        self.layer.cornerRadius = radius == 0.0 ? self.width / 2.0 : radius
        self.layer.masksToBounds = true
    }
    
    func borderView(color: UIColor = .clear, thickness: CGFloat = 1) {
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = thickness
        self.layer.masksToBounds = true
    }
    
    func roundCorners(radius: CGFloat, corners: CACornerMask) {
        
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = CACornerMask(arrayLiteral: corners)
    }
}

// Capture
public extension UIView {
    
    func capture() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func capture(croppingRect: CGRect) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(croppingRect.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.translateBy(x: -croppingRect.origin.x, y: -croppingRect.origin.y)
        layoutIfNeeded()
        layer.render(in: context)
        let screenshotImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }
}
