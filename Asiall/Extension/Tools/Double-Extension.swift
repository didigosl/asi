//
//  Double-Extension.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/9.
//  Copyright © 2019 GoEat. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    func roundTo2f() -> String {
        return String(format: "%.2f", self)
    }
}
