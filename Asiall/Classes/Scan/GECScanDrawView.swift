//
//  GECScanDrawView.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/26.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECScanDrawView: UIView {

    override func draw(_ rect: CGRect) {
        UIColor(white: 0.0, alpha: 0.5).setFill()
        UIRectFill(rect)
        var y: CGFloat = 225
        if #available(iOS 13, *) {
            y = 225
        }
        let holeRection = CGRect(x: (rect.width - 225) / 2, y: y , width: 225, height: 225)
        let holeInterSection = holeRection.intersection(rect)
        UIColor.clear.setFill()
        UIRectFill(holeInterSection)
    }
}
