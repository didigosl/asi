//
//  GECCustomBusinessCollectionCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 20/12/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECCustomBusinessCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    static let identifier = "GECCustomBusinessCollectionCell_identifier"
    var businessModel: GECRestaurantBusinessModel? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.layer.borderWidth = 1.0
        self.backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.size.width * 0.5
    }

    private func setData() {
        guard let model = businessModel else { return }
        self.titleLabel.text = model.name
        if model.isSelect {
            self.titleLabel.textColor = UIColor.themaSelectColor
            self.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }else {
            self.titleLabel.textColor = UIColor.themaNormalColor
            self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
}
