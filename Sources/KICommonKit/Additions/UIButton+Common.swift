//
//  UIButton+Common.swift
//  KICommon
//
//  Created by 조승보 on 2022/11/04.
//

import UIKit

public extension UIButton {
    
    func setTitle(_ title: Int?, for state: UIControl.State = .normal) {
        self.setTitle(String(title ?? 0), for: state)
    }
}
