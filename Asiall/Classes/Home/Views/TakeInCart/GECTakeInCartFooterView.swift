//
//  GECTakeInCartFooterView.swift
//  G-eatClient
//
//  Created by JS_Coder on 24/07/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECTakeInCartFooterView:  UITableViewHeaderFooterView, CustomViewLoadable  {
    var customFrame: CGRect? { didSet { layoutIfNeeded() }}
    var customSize: CGSize? { didSet { layoutIfNeeded() }}
    @IBOutlet weak var remarkPls: UILabel!
    @IBOutlet weak var totalPricePls: UILabel!
    @IBOutlet weak var discountPricePls: UILabel!
    @IBOutlet weak var actuallyPricePls: UILabel!
    /*----------------------------------------------*/
    @IBOutlet weak var textView: PlaceholderTextView!
    @IBOutlet weak var actuallyPrice: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!


    // 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        if let customFrame = self.customFrame {
            self.frame = customFrame
        }
        if let customSize = self.customSize {
            self.frame.size = customSize
        }
    }
}
