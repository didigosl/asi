//
//  GECRestaurantCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/11.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECRestaurantCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var disableLabel: UILabel!
    @IBOutlet weak var disableHubView: UIView!

    var followRestaurantModel: GECRestaurantsStoreModel? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {

        super.awakeFromNib()
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.bgImageView.layer.cornerRadius = 16
        self.bgImageView.layer.masksToBounds = true

        logoImageView.layer.cornerRadius = 25
        logoImageView.layer.masksToBounds = true
    }

    private func setData() {
        if let model = followRestaurantModel {
            nameLabel.text = model.name
            directionLabel.text = "🧭: \(model.address?.address1 ?? "")"
            emailLabel.text = "📮: \(model.email ?? "")"
            contactLabel.text = "☎️: \(model.mobile ?? "")"

            if let url = model.logo?.url {
                logoImageView.setImageWithUrl(url)
            }else {
                logoImageView.image = UIImage(named: "profileIcon")
            }
            if let backgroundImage = model.appbackground?.url {
                bgImageView.setImageWithUrl(backgroundImage)
            }else {
                bgImageView.image = UIImage(named: "1")
            }
            if model.disabled == 1 {
                disableLabel.isHidden = false
                disableHubView.isHidden = false
            }else {
                disableLabel.isHidden = true
                disableHubView.isHidden = true
            }
        }
    }
}
