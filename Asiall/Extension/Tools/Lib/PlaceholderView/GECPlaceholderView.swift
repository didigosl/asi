//
//  GECPlaceholderView.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/13.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECPlaceholderView: UIView {

    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var placeholderLabel: UILabel!

    static func getClassWithNib() -> GECPlaceholderView {
        let v = Bundle.main.loadNibNamed("GECPlaceholderView", owner: nil, options: nil)?.first as! GECPlaceholderView
        return v
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        placeholderLabel.text = "您还没有正在进行中的单子".getLocaLized
    }

}
