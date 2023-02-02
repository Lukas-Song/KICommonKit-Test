//
//  UIApplication+Common.swift
//  Genie
//
//  Created by 조승보 on 2022/04/14.
//

import UIKit

@available(iOS 13.0, *)
public extension UIApplication {
    
    var keyWindow: UIWindow? {
        
        return UIApplication.shared.connectedScenes
//            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap( { $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    var keyboardWindow: UIWindow? {
        
        let window = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap( { $0 as? UIWindowScene })?.windows
            .filter { String(describing: type(of: $0)) == "UIRemoteKeyboardWindow" }
        
        return window?.first
    }
}
