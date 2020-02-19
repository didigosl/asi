//
//  Colors.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/10.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit


extension UIColor {
    static var themaSelectColor: UIColor {
        get {
            return UIColor.red
        }
    }

    static var themaNormalColor: UIColor {
        get {
            return UIColor(hexString: "#4B5257") ?? .black
        }
    }

    static var themaBackgroundColor: UIColor {
        get {
            if #available(iOS 13, *) {
               return UIColor { (traintCollection) -> UIColor in
                    switch traintCollection.userInterfaceStyle {
                    case .dark: return UIColor(hexString: "#F5F5F5")!
                    case .light: return UIColor(hexString: "#F5F5F5")!
                    default: return UIColor(hexString: "#F5F5F5")!
                    }
                }
            }else {
                return UIColor(hexString: "#F5F5F5")!
            }
        }
    }

    static var themaTextSelectedBackgroundColor: UIColor {
        get {
            return UIColor(hexString: "#FF6201") ?? .orange
        }
    }

    static var themaLightBackgroundColor: UIColor {
        get {
            return UIColor(hexString: "#F4F6F6") ?? .white
        }
    }

    static var themaLightGrayColor: UIColor {
        get {
            return UIColor(hexString: "#969FA2") ?? .lightGray
        }
    }

    static var systemBlueColor: UIColor {
        get {
            return UIColor(hexString: "#0177F9") ?? .blue
        }
    }

}
