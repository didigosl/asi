//
//  GECPreCartDishesCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/9.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECPreCartDishesCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    var delegate: DishesCellProtocol?
    var dishModel: GECRestaurantDishModel? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    private func setData() {
        if let model = dishModel {
            var content = ""
            for item in model.menuSelectedGarnishedList.first! {
                for dish in item.selectCommodity {
                    content += "- \(dish.commodity_name ?? "")"
                    if !(Double(dish.price ?? "0.00") == 0) {
                        content += " + \(dish.price!)€ \r\n"
                    }else { content += "\r\n"}
                }
            }
            nameLabel.text = content
            quantityLabel.text = "\(model.addedGarnishCount)"
        }
    }

    private func checkIsShowQuantityLabel() {

    }

    @IBAction func addToCartAction(_ sender: UIButton) {
        if let model = dishModel {
            delegate?.cellDishAugmentQuantity(cell: self, model: model)
        }
    }

    @IBAction func subtractFromCartAction(_ sender: UIButton) {
        if let model = dishModel {
            if model.addedGarnishCount - 1 == 0 {
                delegate?.preCartCellDishSubtractQuantity(cell: self, model: model, canDelete: true)
                return
            }
            delegate?.preCartCellDishSubtractQuantity(cell: self, model: model, canDelete: false)
        }
    }
}
