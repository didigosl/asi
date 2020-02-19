//
//  GECCommonHubView.swift
//  G-eatClient
//
//  Created by JS_Coder on 16/08/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECCommonHubView: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.layer.backgroundColor = UIColor.white.cgColor;
        self.textColor = UIColor.themaSelectColor
        self.textAlignment = .center
        self.layer.shadowColor = UIColor.themaNormalColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = homeTopAlertHeight * 0.5;
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
        self.alpha = 0.0
    }

}
