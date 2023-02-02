//
//  UILabel+Common.swift
//  KICommon
//
//  Created by Kany on 2022/10/06.
//

import UIKit

extension UILabel {
    
    func bold(targetString: String) {
        let fontSize = self.font.pointSize
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: range)
        self.attributedText = attributedString
    }
}
