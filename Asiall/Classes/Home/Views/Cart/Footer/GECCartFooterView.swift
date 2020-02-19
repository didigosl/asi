//
//  GECCartFooterView.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/15.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECCartFooterView: UITableViewHeaderFooterView, CustomViewLoadable {

    var customFrame: CGRect? { didSet { layoutIfNeeded() }}
    var customSize: CGSize? { didSet { layoutIfNeeded() }}
    @IBOutlet weak var remarkPls: UILabel!
    @IBOutlet weak var totalPricePls: UILabel!
    @IBOutlet weak var discountPricePls: UILabel!
    @IBOutlet weak var actuallyPricePls: UILabel!
    /*----------------------------------------------*/
    @IBOutlet weak var textView: PlaceholderTextView!
    @IBOutlet weak var actuallyPrice: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!

    /// 购物车价格
    var cartPriceModel: GECCartPriceModel? {
        didSet {
            setData()
        }
    }

    // 生命周期
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
        setup()
    }

    // 初始化
    private func setup() {
        self.remarkPls.text = "备注".getLocaLized
        self.totalPricePls.text = "商品金额".getLocaLized
        self.discountPricePls.text = "折扣金额".getLocaLized
        self.actuallyPricePls.text = "应付".getLocaLized
    }

    // 设置 输入框 格式
    private func setupTextView() {
        //设置是否显示计算label
        textView.isShowCountLabel = true
        //限制字数
        textView.limitWords = 100
        //是否return关闭键盘
        textView.isReturnHidden = true
        textView.placeholderGlobal = "请输入你要编写的内容".getLocaLized + "~~~"
        textView.placeholderColorGlobal = UIColor.themaLightGrayColor
        textView.countLabelFont = UIFont(name: "PingFangSC-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        textView.placeholderFont = UIFont(name: "PingFangSC-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
        textView.textFont = UIFont(name: "PingFangSC-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
        textView.countLabelColor = UIColor.themaSelectColor
        textView.textViewColor = UIColor.themaNormalColor
    }

    // 赋值
    private func setData() {
        if let model = cartPriceModel {
            self.totalPrice.text = "\((model.total ?? "0.00"))€"
            self.discountPrice.text = "- \((model.discountAmount ?? "0.00"))€"
            self.actuallyPrice.text = "\((model.actuallyPaidAmount ?? "0.00"))€"
        }
    }

    // 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        if let customFrame = self.customFrame {
            self.frame = customFrame
        }
        if let customSize = self.customSize {
            self.frame.size = customSize
        }
    }
}
