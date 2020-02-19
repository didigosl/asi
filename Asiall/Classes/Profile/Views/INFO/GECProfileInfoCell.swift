//
//  GECProfileInfoCell.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/12.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECProfileInfoCell: UITableViewCell {

    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var detailInfo: UILabel!
    @IBOutlet weak var detailIcon: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailIcon.layer.cornerRadius = detailIcon.frame.width / 2
        detailIcon.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
