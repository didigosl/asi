//
//  GECPreCartDisheHeaderView.swift
//  G-eatClient
//
//  Created by JS_Coder on 08/09/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
protocol PreCartDisheHeaderViewDelegate {
    func preCartDisheHeaderViewAddButtonAction(dishModel: GECRestaurantDishModel, headerView: GECPreCartDisheHeaderView)
    
    func preCartDisheHeaderViewSubtractButtonAction(dishModel: GECRestaurantDishModel, headerView: GECPreCartDisheHeaderView,  canDelete: Bool)
}
class GECPreCartDisheHeaderView: UIView, CustomViewLoadable {

    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    var delegate: PreCartDisheHeaderViewDelegate?
    var dishModel: GECRestaurantDishModel? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func subtractButtonAction(_ sender: UIButton) {
        if let model = dishModel {
            if model.quantity - 1 == 0 { delegate?.preCartDisheHeaderViewSubtractButtonAction(dishModel: model, headerView: self, canDelete: true)
                return
            }
            delegate?.preCartDisheHeaderViewSubtractButtonAction(dishModel: model, headerView: self, canDelete: false)
        }
    }

    @IBAction func addButtonAction(_ sender: UIButton) {
        if let model = dishModel {
            delegate?.preCartDisheHeaderViewAddButtonAction(dishModel: model, headerView: self)
        }
    }

    private func setData() {
        guard let model = dishModel else { return }
        countLabel.text = "\(model.quantity)"
        dishNameLabel.text = model.name
        if model.menuSelectedGarnishedList.count > 0 {
            addButton.isHidden = true
            subtractButton.isHidden = true
            countLabel.isHidden = true
        }else {
            addButton.isHidden = false
            subtractButton.isHidden = false
            countLabel.isHidden = false
        }
        var attStr = ""
        for (index,att) in model.selectedAttributes.enumerated() {
            attStr += "[\(att.name ?? "")]"
            if index < model.selectedAttributes.count - 1 {
                attStr += " , "
            }
        }
        attributeLabel.text = attStr
    }

}
