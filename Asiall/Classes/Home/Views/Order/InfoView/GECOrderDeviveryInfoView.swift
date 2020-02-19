//
//  GECOrderDiviveryInfoView.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/16.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECOrderDeviveryInfoView: UIView, CustomViewLoadable {
    @IBOutlet weak var orderNumberPls: UILabel!
    @IBOutlet weak var payMethodPls: UILabel!
    @IBOutlet weak var createTimePls: UILabel!
    @IBOutlet weak var remarkPls: UILabel!
    @IBOutlet weak var titleInfoPls: UILabel!
    @IBOutlet weak var payMethodLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!

    var customFrame: CGRect? { didSet { layoutIfNeeded() }}

    var orderModel: GECTakeAwayOrderModel? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleInfoPls.text = "订单信息".getLocaLized
        orderNumberPls.text = "订单号码".getLocaLized
        payMethodPls.text = "支付方式".getLocaLized
        createTimePls.text = "下单时间".getLocaLized
        remarkPls.text = "订单备注".getLocaLized
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let customFrame = self.customFrame {
            self.frame = customFrame
        }
    }

    private func setData() {
        if let model = orderModel {
            orderNumLabel.text = model.no
            payMethodLabel.text = model.paymentMethod
            createTimeLabel.text = model.createTime
            remarkLabel.text = model.remarks
        }
    }
}
