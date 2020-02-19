//
//  GlobalString.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/14.
//  Copyright © 2019 GoEat. All rights reserved.
//

import Foundation

let euro = "€"
let errorKey = "isError"
extension String {
    var dateWithFormatter: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = self
            return formatter.string(from: Date())
        }
    }

    func dateWithFormatter(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = self
        return formatter.string(from: date)
    }
}

