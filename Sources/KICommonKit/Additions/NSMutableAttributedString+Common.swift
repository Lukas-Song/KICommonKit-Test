//
//  NSMutableAttributedString+Common.swift
//  Genie
//
//  Created by 조승보 on 2022/04/01.
//

import Foundation
import UIKit

public extension NSMutableAttributedString {
    
    func font(string: String, fontSize: CGFloat, weight: UIFont.Weight = .regular) -> NSMutableAttributedString {
        
        let font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func append(string: String, fontSize: CGFloat, weight: UIFont.Weight = .regular, color: UIColor) -> NSMutableAttributedString {
        
        let font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self

    }
    
    func width(height: CGFloat) -> CGFloat {
        
        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.width)
    }
}
