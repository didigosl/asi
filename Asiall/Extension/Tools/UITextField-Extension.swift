//
//  UITextField-Extension.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/6.
//  Copyright © 2019 GoEat. All rights reserved.
//
import UIKit

extension UITextField {
    func setLeftPadding(_ span: Double) {
        self.setValue(NSNumber(floatLiteral: span), forKey: "paddingLeft")
    }

    func setPlaceHolder(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text,
                                                               attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
