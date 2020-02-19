//
//  GECCartDishesCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/15.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
protocol GECCartDishCellDelegate {
    func cartDishCellDidSelectAddItemAction(cell: GECCartDishesCell, dishModel: GECRestaurantDishModel)
    func cartDishCellDidSelectSubtractItemAction(cell: GECCartDishesCell, dishModel: GECRestaurantDishModel)
}

class GECCartDishesCell: UITableViewCell {

    @IBOutlet weak var dishNameLabel: UILabel!

    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dishDetailLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var dishQuantityLabel: UILabel!
    @IBOutlet weak var disheImageView: UIImageView!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var subtractItemButton: UIButton!

    var delegate: GECCartDishCellDelegate?
    var dishModel: GECRestaurantDishModel? {
        didSet {
            setData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        disheImageView.layer.cornerRadius = 5
        disheImageView.layer.masksToBounds = true
        self.selectionStyle = .none
    }

    private func setData() {
        if let model = dishModel {
            self.dishNameLabel.text = model.name
            var attributesStr = ""
            _ = model.selectedAttributes.map{attributesStr += "\($0.name ?? ""), "}

            if model.menuSelectedGarnishedList.count > 0 {
                var detailText = ""
                var contentPrice: Double = Double(model.takeawayPrice ?? model.price ?? "0.00") ?? 0.00
                for garnish in model.menuSelectedGarnishedList.first! {
                    for commodity in garnish.selectCommodity {
                        print("\(commodity.commodity_name ?? "") --- \(commodity.price ?? "0.00")")
                        detailText += "- \(commodity.commodity_name ?? "")\r\n"
                        contentPrice += Double(commodity.price ?? "0.00") ?? 0.00
                    }
                }
                self.dishDetailLabel.text = detailText
                self.dishPriceLabel.text = "\(contentPrice.roundTo2f())\(euro))" 
                self.dishQuantityLabel.text = "x\(model.addedGarnishCount)"
            }else {
                self.dishDetailLabel.text = attributesStr
                self.dishPriceLabel.text = (model.price ?? "0.00") + euro
                self.dishQuantityLabel.text = "x\(model.quantity)"
            }
        }
    }

    @IBAction func addItemAction(_ sender: UIButton) {
        guard let model = dishModel else {return}
        delegate?.cartDishCellDidSelectAddItemAction(cell: self, dishModel: model)
    }

    @IBAction func subTractItemAction(_ sender: UIButton) {
        guard let model = dishModel else {return}
        delegate?.cartDishCellDidSelectSubtractItemAction(cell: self, dishModel: model)
    }


    
}
