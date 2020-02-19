//
//  GECCustomHomeTitleView.swift
//  G-eatClient
//
//  Created by JS_Coder on 20/12/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECCustomHomeTitleView: UIView, CustomViewLoadable {
    @IBOutlet weak var welcomeContentLabel: UILabel!
    @IBOutlet weak var nameContentLabel: UILabel!
    static let height: CGFloat = 44
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.welcomeContentLabel.text = "欢迎使用".getLocaLized
        self.nameContentLabel.text = "Asiall"
    }

}
