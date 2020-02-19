//
//  GECOrderInfoView.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/16.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECOrderInfoView: UIView, CustomViewLoadable {

    @IBOutlet weak var titleInfoPls: UILabel!
    @IBOutlet weak var deliveryTimePls: UILabel!
    @IBOutlet weak var deliveryDirectionPls: UILabel!
    @IBOutlet weak var deliveryMethodPls: UILabel!
    
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var deliveryDirectionLabel: UILabel!
    @IBOutlet weak var deliveryMethodLabel: UILabel!

    var customFrame: CGRect? { didSet { layoutIfNeeded() }}
    var orderModel:GECTakeAwayOrderModel? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleInfoPls.text = "配送信息".getLocaLized
        deliveryTimePls.text = "预计送达".getLocaLized
        deliveryMethodPls.text = "配送方式".getLocaLized
        deliveryDirectionPls.text = "配送地址".getLocaLized
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let customFrame = self.customFrame {
            self.frame = customFrame
        }
    }

    private func setData() {
        if let model = orderModel {
            deliveryTimeLabel.text = model.deliveryTime
            deliveryDirectionLabel.text = GECHomeViewModel.defaultAddress?.address1
            if let address = model.deliveryInfo?.address1 {
                deliveryDirectionLabel.text = address
            }
            deliveryMethodLabel.text = "商家配送".getLocaLized
        }
    }
}
