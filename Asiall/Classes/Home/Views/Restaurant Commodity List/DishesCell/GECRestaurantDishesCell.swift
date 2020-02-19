//
//  GECRestaurantDishesCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/14.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECRestaurantDishesCell: UICollectionViewCell {

    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var dishTitleLabel: UILabel!
    @IBOutlet weak var dishContentLabel: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var removeDishView: UIView!

    
    weak var delegate: DishesCellProtocol?
    var dishModel: GECRestaurantDishModel? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        dishImageView.layer.cornerRadius = 5
        dishImageView.layer.masksToBounds = true

        // 添加tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeDishesAction))
        removeDishView.addGestureRecognizer(tap)
        dishImageView.isUserInteractionEnabled = true
        let imageIconoTap = UITapGestureRecognizer(target: self, action: #selector(goToDetailMenu))
        dishImageView.addGestureRecognizer(imageIconoTap)
    }

    //MARK: - SET DATA
    private func setData() {
        if let model = dishModel {
            dishTitleLabel.text = model.name
            dishPrice.text = "\(model.price ?? "0.00")€"
            dishContentLabel.text = model.commoditeDescription
            if GECHomeViewModel.isTakeIn, let items = GECHomeViewModel.takeInCartModel?.items {
                for item in items {
                    if let guid = item.commodityGuid, guid.elementsEqual(model.guid ?? "") {
                        model.quantity = item.quantity ?? 0
                    }
                }
            }
            quantityLabel.text = "\(model.quantity)"
            
            if model.quantity == 0 {
                removeDishView.alpha = 0.0
            }else {
                self.removeDishView.alpha = 1.0
            }

            if let imageUrl = model.images?.first?.url {
                self.imageWidthConstraint.constant = 75
                dishImageView.setImageWithUrl(imageUrl, placeImage: "nullImage_icon")
            }else {
                self.imageWidthConstraint.constant = 0
            }
        }
    }
}


// MARK: - Target Gesture
extension GECRestaurantDishesCell {
    @objc private func removeDishesAction() {
        if let model = dishModel {
            if model.quantity - 1 == 0 {
                UIView.animate(withDuration: 0.15) {
                    self.removeDishView.alpha = 0
                }
                delegate?.resCellDishSubtractQuantity(cell: self, model: model, canDelete: true)
                return
            }
             delegate?.resCellDishSubtractQuantity(cell: self, model: model, canDelete: false)
        }
    }
    @objc private func goToDetailMenu() {
        delegate?.dishesCellImageSelected(cell: self)
    }
}
