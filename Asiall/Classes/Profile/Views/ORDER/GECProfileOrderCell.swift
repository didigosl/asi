//
//  GECProfileOrderCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/13.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECProfileOrderCell: UITableViewCell {


    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var orderTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeFlagLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var orderModel: GECOrderModel? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        baseView.layer.cornerRadius = 5
        baseView.layer.masksToBounds = true
        self.timeFlagLabel.text = "时间".getLocaLized
        self.orderImageView.layer.cornerRadius = self.orderImageView.frame.width * 0.5
        self.orderImageView.layer.masksToBounds = true
    }

    private func setData() {
        if let model = orderModel {
            orderImageView.image = UIImage(named: "profileIcon")
            timeLabel.text = model.createTime
            orderTitleLabel.text = model.no
            if let status = model.status{
                switch status {
                case 0:
                    //等待打包
                    statusLabel.text = "等待中⌛️".getLocaLized
                case 1:
                    //打包中
                    statusLabel.text = "制作中".getLocaLized
                case 2:
                    //配送中
                    statusLabel.text = "配送中🛵".getLocaLized
                case 3:
                    //已完成
                    statusLabel.text = "已送达".getLocaLized
                case 4,5:
                    //已完成
                    statusLabel.text = "已完成".getLocaLized
                case 6:
                    //已取消
                    statusLabel.text = "已取消".getLocaLized
                default:
                    break;
                }
            }
//            for item in lists {
//                if (item.guid ?? "").elementsEqual(model.storeGuid ?? ""), let logo = item.logo?.url {
//                    orderImageView.setImageWithUrl(logo)
//                    orderTitleLabel.text = item.name
//                }
//            }
        }
    }
    
}
