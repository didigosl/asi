//
//  GECPaddingTextField.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/6.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECPaddingTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}
