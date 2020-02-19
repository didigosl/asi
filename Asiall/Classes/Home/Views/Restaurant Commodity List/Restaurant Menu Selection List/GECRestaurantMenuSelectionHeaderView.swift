//
//  GECRestaurantMenuSelectionHeaderView.swift
//  G-eatClient
//
//  Created by JS_Coder on 06/09/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
protocol RestaurantMenuSelectionHeaderViewDelegate {
    func restaurantMenuSelectionHeaderViewSelect(section: Int)
}
class GECRestaurantMenuSelectionHeaderView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor.themaNormalColor
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()

    lazy var inputImageView: UIImageView = {
        let inputImage = UIImageView(image: UIImage(named: "into_icon"))
        inputImage.translatesAutoresizingMaskIntoConstraints = false
        inputImage.sizeToFit()
        self.addSubview(inputImage)
        return inputImage
    }()

    var delegate: RestaurantMenuSelectionHeaderViewDelegate?

    var garnishModel: GECCommodityGarnishModel? {
        didSet {
            setData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerViewTapGesture))
        self.addGestureRecognizer(tapGesture)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func headerViewTapGesture() {
        delegate?.restaurantMenuSelectionHeaderViewSelect(section: self.tag)
    }

    private func setup() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: commonMargin),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.rightAnchor.constraint(equalTo: self.inputImageView.leftAnchor, constant: -commonMargin),

            inputImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            inputImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -commonMargin)
            ])
    }

    private func setData() {
        if let model = garnishModel {
            titleLabel.text = model.name
            if model.isShowCommodity == true {
                    self.inputImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.5))
            }else {
                    self.inputImageView.transform = .identity
            }
        }
    }

}
