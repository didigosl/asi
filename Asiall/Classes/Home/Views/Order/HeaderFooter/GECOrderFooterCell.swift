//
//  GECOrderFooterCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/16.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECOrderFooterCell: UIView, CustomViewLoadable {

    @IBOutlet weak var actuallyPricePls: UILabel!
    @IBOutlet weak var deliveryPricePls: UILabel!
    @IBOutlet weak var totalPls: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var actuallyPriceLabel: UILabel!

    var orderModel: GECTakeAwayOrderModel? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        deliveryPricePls.text = "配送费用".getLocaLized
        totalPls.text = "总计".getLocaLized
        actuallyPricePls.text = "应付".getLocaLized
    }

    private func setData() {
        if let model = orderModel {
            deliveryPriceLabel.text = "免费".getLocaLized
            totalPriceLabel.text = "\(model.total ?? "0.00")€"
            actuallyPriceLabel.text = "\(model.currentTotal ?? "0.00")€"
        }
    }
}
