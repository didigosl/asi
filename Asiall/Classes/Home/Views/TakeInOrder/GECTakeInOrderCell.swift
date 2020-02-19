//
//  GECTakeInOrderCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 24/07/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECTakeInOrderCell: UITableViewCell {

    static let identifier = "GECTakeInOrderCellIdentifier"
    //Vars.
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!

    var orderItemModel: GECOrderItemModel? {
        didSet {
            setData()
        }
    }

    //Circle Life
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.themaLightBackgroundColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    private func setData() {
        guard let model = orderItemModel else {return}
        itemNameLabel.text = model.name
        itemCountLabel.text = "x \(model.quantity ?? 1)"
        itemPriceLabel.text = "\(model.total ?? "0.00") €"
    }
}
