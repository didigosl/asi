//
//  GECAddressCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/12.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECAddressCell: UITableViewCell {
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    var delegate: GECProfileAddressCellDelegate?
    var addressModel: GECAddressModel? {
        didSet {
            setData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.baseView.layer.cornerRadius = 5
        self.baseView.layer.masksToBounds = true
        self.baseView.layer.borderWidth = 1
        self.selectionStyle = .none }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func editActionSelected(_ sender: UIButton) {
        delegate?.addressCellDidSelectedEditAction(cell: self, model: addressModel!)
    }

    private func setData() {
        if let model = addressModel {
            nameLabel.text = model.contact
            phoneLabel.text = model.phone
            let completAddress = "\(model.address1 ?? "") \(model.address2 ?? ""), \(model.address3 ?? ""), \(model.zipcode ?? ""), \(model.city ?? "")"
            directionLabel.text = completAddress
            
            if let flag = model.defaultAddress, flag == 1 {
                self.baseView.backgroundColor = .white
                self.baseView.layer.borderColor = UIColor.themaSelectColor.cgColor
                self.selectButton.isSelected = true
            }else {
                self.baseView.layer.borderColor = UIColor.themaLightBackgroundColor.cgColor
                self.selectButton.isSelected = false
            }
        }
    }

}
