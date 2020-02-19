//
//  GECProfileOrderController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/11.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECProfileOrderController: UIViewController {

    @IBOutlet weak var baseView: UIView!
    lazy var orderPageView: JSPageView = {
        var style = JS_PageStyle()
        style.titleNolmalColor = UIColor.themaLightGrayColor
        style.titleSelectedColor = UIColor.themaSelectColor
        style.isShowBottomLine = true
        style.bottomLineHeight = 1.5
        style.titleViewHeight = 35
        style.titleHeight = 35
        style.isShowBottomShadow = true
        style.bottomLineColor = UIColor.themaSelectColor
        style.titleFont = UIFont(name: "PingFangSC-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let frame = CGRect(x: 0, y: commonMargin / 2, width: baseView.frame.width, height: baseView.frame.height)
        let page = JSPageView(frame: frame, titles: GECProfileViewModel.ordersTitles, style: style, childController: [GECCurrentOrdersController(),GECFinishedOrderController(),GECCanceledOrderController()], parentController: self)
        page.backgroundColor = UIColor.themaLightBackgroundColor
        return page
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的订单".getLocaLized
        self.baseView.frame.size = CGSize(width: screenWidth, height: screenHeight - naviBarHeight - statusBarHeight)
        self.baseView.addSubview(orderPageView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

}
