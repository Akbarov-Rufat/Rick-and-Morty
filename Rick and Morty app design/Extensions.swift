//
//  Extensions.swift
//  Rick and Morty app design
//
//  Created by Rufat  on 22.05.24.
//

import Foundation
import UIKit


extension UITextField {
    func addPadding() {
        let paddingView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
extension String {
    func convertToRequiredFont() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: UIFont(name: "Inter-Regular_Medium", size: 20) as Any, NSAttributedString.Key.foregroundColor: UIColor.white])
        return attributedString
    }
}
extension NSMutableAttributedString {
    func appendMutableString(_ attrString : NSMutableAttributedString) -> NSMutableAttributedString {
        let mutableString = self
        mutableString.append(attrString)
        return mutableString
    }
}

