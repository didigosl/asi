//
//  GECHomeSearchRestaurantCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/3.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECHomeSearchRestaurantCell: UITableViewCell {
    //MARK: - Vals
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var followImageView: UIImageView!

    var restaurantModel: GECRestaurantsStoreModel? {
        didSet {
            setData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        logoImageView.layer.cornerRadius = logoImageView.frame.width * 0.5
        logoImageView.layer.masksToBounds = true
        // Initialization code
    }

    private func setData() {
        guard let model = restaurantModel else {return}
        nameLabel.text = model.name
        directionLabel.text = model.address?.address1
        contactLabel.text = model.mobile
        followImageView.image = ((model.following != nil) && (model.following! == true)) ? UIImage(named: "follow_icon") : UIImage(named: "un_follow_icon")
        if let url = model.logo?.url {
            logoImageView.setImageWithUrl(url)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
