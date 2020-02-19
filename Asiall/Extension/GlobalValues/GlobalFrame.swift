//
//  Frame.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/10.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

var screenWidth: CGFloat{
    get {
        return UIScreen.main.bounds.width
    }
}
var screenHeight: CGFloat {
    get {
      return UIScreen.main.bounds.height
    }
}
var screenFrame: CGRect {
    get {
        return UIScreen.main.bounds
    }
}

var naviBarHeight: CGFloat {
    get {
        if let nav = UIApplication.shared.keyWindow?.rootViewController?.children.first as? UINavigationController {
            return nav.navigationBar.frame.height
        }else {
            return 44
        }
    }
}
var statusBarHeight: CGFloat {
    get {
        return UIApplication.shared.statusBarFrame.height
    }
}
var tabBarHeight: CGFloat {
    get {
        if let tab = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            return tab.tabBar.frame.height
        }else {
            return 49
        }
    }
}
let iphone678height: CGFloat = 667
let iphone345PlusHeight: CGFloat = 736
let iphonex: CGFloat = 812
let iphonexMax: CGFloat = 896
let bigMargin: CGFloat = 20
let commonMargin: CGFloat = 15
let middleMargin: CGFloat = 10
let miniMargin: CGFloat = 5
let searchLogoSize: CGFloat = 20
let normalButtonHeight: CGFloat = 44
let homeTopAlertHeight: CGFloat = 44
let normalRowHeight: CGFloat = 44
let normalTableHeaderHeight: CGFloat = 34
let normalOrderTableRowHeight: CGFloat = 130
