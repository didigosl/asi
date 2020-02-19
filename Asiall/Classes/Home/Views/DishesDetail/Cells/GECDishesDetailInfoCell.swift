//
//  GECDishesDetailInfoCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 18/08/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECDishesDetailInfoCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
