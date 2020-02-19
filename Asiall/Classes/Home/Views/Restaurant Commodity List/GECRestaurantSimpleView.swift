//
//  GECRestaurantSimpleView.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/14.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECRestaurantSimpleView: UIView, CustomViewLoadable {

    @IBOutlet weak var businessHourStatusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var takeInHubLabel: UILabel!
    
    var restaurantStore: GECRestaurantsStoreModel? {
        didSet {
            setData()
        }
    }
    //设置 frame
    var customFrame: CGRect? { didSet { layoutIfNeeded() }}

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true

        logoImageView.layer.cornerRadius = logoImageView.frame.width * 0.5
        logoImageView.layer.masksToBounds = true

        businessHourStatusLabel.layer.cornerRadius = 5
        businessHourStatusLabel.layer.masksToBounds = true
    }

    // 设置内容
    private func setData() {
        if let model = restaurantStore {
            nameLabel.text = model.name
            if let url = model.logo?.url {
                logoImageView.setImageWithUrl(url)
            }
            if let status = model.open, status != 1 {
                businessHourStatusLabel.text = "已打烊".getLocaLized
                businessHourStatusLabel.backgroundColor = UIColor.lightGray
            }else {
                businessHourStatusLabel.text = "营业中".getLocaLized
                businessHourStatusLabel.backgroundColor = UIColor.themaTextSelectedBackgroundColor
            }
            if !GECHomeViewModel.isTakeIn {
                if model.takeawayStatus == 0 {
                    takeInHubLabel.isHidden = false
                    takeInHubLabel.text = "本店不支持外卖".getLocaLized
                }else if model.takeawayStatus == 2 {
                    takeInHubLabel.isHidden = false
                    takeInHubLabel.text = "本店支持点餐,但需到店取".getLocaLized
                }else {
                    takeInHubLabel.isHidden = true
                }
            }

            deliveryPrice.text = "€ \(model.takeawayMinimumConsumption ?? 0)"
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let customFrame = self.customFrame {
            self.frame = customFrame
        }
    }
}
