//
//  UIImageView-Extension.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/3/13.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
import Kingfisher
extension UIImageView {
    func setImageWithUrl(_ path: String, placeImage: String? = "touxiang_icon") {
        let enCodePath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = URL(string: enCodePath ?? path) {
           let resource = ImageResource(downloadURL: url)
            self.kf.setImage(with: resource, placeholder: UIImage(named: placeImage!))
        }else {
            self.image = UIImage(named: placeImage!)
        }
    }
}
