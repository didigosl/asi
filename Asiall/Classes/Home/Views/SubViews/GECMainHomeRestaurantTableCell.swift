//
//  GECMainHomeRestaurantTableCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 20/12/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECMainHomeRestaurantTableCell: UITableViewCell {

    @IBOutlet weak var restaurentImageView: UIImageView!
    static let identifier = "GECMainHomeRestaurantTableCell_identifier"

    var storeModel: GECRestaurantsStoreModel! {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        restaurentImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    private func setData() {
        self.restaurentImageView.setImageWithUrl(storeModel.logo?.url ?? "")

       
    }

}
