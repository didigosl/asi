//
//  GECOrderDishesCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/16.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECOrderDishesCell: UITableViewCell {
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishQuantityLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    var dishModel: GECRestaurantDishModel? {
        didSet {
            setData()
        }
    }

    var orderDishModel: GECOrderItemModel? {
        didSet {
            setData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    private func setData() {
        if let model = dishModel {
            dishNameLabel.text = model.name
            dishQuantityLabel.text = "x\(model.quantity)"
            dishPriceLabel.text = "\(model.price ?? "0.00")€"
        }else if let model = orderDishModel {
            dishNameLabel.text = model.name
            dishQuantityLabel.text = "x\(model.quantity ?? 1)"
            dishPriceLabel.text = model.price
        }
    }
    
}
