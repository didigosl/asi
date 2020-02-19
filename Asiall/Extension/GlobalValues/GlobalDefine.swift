//
//  GlobalDefine.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/14.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

protocol CustomViewLoadable {

}

extension CustomViewLoadable where Self : UIView{
    static func loadNib(_ nibNmae :String? = nil) -> Self{
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}
