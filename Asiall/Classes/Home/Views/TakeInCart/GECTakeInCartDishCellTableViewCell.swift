//
//  GECTakeInCartDishCellTableViewCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 24/07/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECTakeInCartDishCellTableViewCell: UITableViewCell {

    //MARK: - Vars..
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var dishInCartCountLabel: UILabel!

    var itemModel: GECOrderItemModel? {
        didSet {
            setData()
        }
    }

    //Circle Life
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func setData() {
        if let model = itemModel {
            dishNameLabel.text = model.name
            dishPriceLabel.text = model.price
            dishInCartCountLabel.text = "x \(model.quantity ?? 0)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addDishToCartAction(_ sender: UIButton) {
        GECHomeViewModel.addToCartWithTakeIn( secondModel: itemModel, isAdd: true)
    }
    
    @IBAction func subtractDishFromCartAction(_ sender: UIButton) {
        GECHomeViewModel.addToCartWithTakeIn( secondModel: itemModel, isAdd: false)
    }
}
