//
//  GECRestaurantMenuSelectionCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 06/09/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECRestaurantMenuSelectionCell: UITableViewCell {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var commodityTitleLabel: UILabel!
    @IBOutlet weak var commodityPriceLabel: UILabel!

    static let identifier = "GECRestaurantMenuSelectionCell.identifier"

    var commodityModel: GECRestaurantDishModel? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setData() {
        if let model = commodityModel {
            commodityTitleLabel.text = model.commodity_name
            let price = Double(model.price ?? "0.00") ?? 0.00
            commodityPriceLabel.text = price == 0.00 ? "" : "+\(price.roundTo2f())€"
            selectButton.isSelected = model.garnishCommoditySelected
        }
    }
    
}
