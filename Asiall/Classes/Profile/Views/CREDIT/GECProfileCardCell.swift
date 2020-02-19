//
//  GECProfileCardCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/13.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECProfileCardCell: UITableViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardInfoLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var baseContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        baseContentView.layer.cornerRadius = 5
        baseContentView.layer.masksToBounds = true
        baseContentView.layer.borderWidth = 1

        cardImageView.layer.cornerRadius = 3
        cardImageView.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
