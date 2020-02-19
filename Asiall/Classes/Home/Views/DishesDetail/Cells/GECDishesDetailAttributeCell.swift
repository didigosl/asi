//
//  GECDishesDetailAttributeCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 18/08/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECDishesDetailAttributeCell: UICollectionViewCell {
    
    @IBOutlet weak var attributeLabel: UILabel!
    var attributeModel: GECCommodityAttributeModel? {
        didSet {
            setData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
    }
    
    private func setData() {
        if let model = attributeModel {
            attributeLabel.text = model.name
            attributeLabel.isHighlighted = attributeModel?.isSelect ?? false
            if model.isSelect {
                self.backgroundColor = UIColor.themaSelectColor
            }else {
                self.backgroundColor = UIColor.white
            }
        }
    }
}
