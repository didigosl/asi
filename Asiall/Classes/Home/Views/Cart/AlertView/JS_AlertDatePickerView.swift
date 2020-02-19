//
//  JS_AlertDatePickerView.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/12.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
protocol AlertDatePickerDelegate {
    func datePickerDidChangedDateTime(date: Date, dateStr: String)
}
class JS_AlertDatePickerView: JS_AlertBaseView {

    var delegate: AlertDatePickerDelegate?
    private var datePicker: UIDatePicker!
    private let titleHeight: CGFloat = 30

    override func addAnimate() {
        UIApplication.shared.keyWindow?.addSubview(self.initAlertBaseView())
        self.isHidden = false

        UIView.animate(withDuration:TimeInterval(defaultTime), animations: {
            self.baseView.frame = self.appearFrame
        }) { (_) in
            self.cancelBtn.frame.origin.y = self.baseView.frame.maxY
            self.cancelBtn.isHidden = false
            self.addCustomSubViews()
        }
    }

    // 添加子控件
    func addCustomSubViews(){
        let titleLabel:UILabel = UILabel(frame: CGRect.init(x: 0, y: commonMargin, width: self.baseView.frame.width, height: titleHeight))
        titleLabel.text = "请选择时间".getLocaLized
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        titleLabel.textColor = UIColor.themaNormalColor
        self.baseView.addSubview(titleLabel)

         self.datePicker = UIDatePicker(frame: CGRect(x: commonMargin, y: titleLabel.frame.maxY + commonMargin, width: baseView.frame.width - commonMargin * 2, height: 200))

//        datePicker.addTarget(self, action: #selector(dateDidChanged(datePicker:)), for: .valueChanged)
        self.baseView.addSubview(datePicker)

        let trueBtn = UIButton()
        trueBtn.frame = CGRect.init(x: commonMargin * 2, y: datePicker.frame.maxY + commonMargin, width: self.baseView.frame.width - commonMargin * 4, height: normalButtonHeight)
        trueBtn.layer.masksToBounds = true
        trueBtn.layer.cornerRadius = normalButtonHeight * 0.5
        trueBtn.setTitleColor(UIColor.themaNormalColor, for: .highlighted)
        trueBtn.backgroundColor = UIColor.themaSelectColor
        trueBtn.setTitle("确定".getLocaLized, for: .normal)
        trueBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        trueBtn.setTitleColor(UIColor.white, for: .normal)
        trueBtn.addTarget(self, action: #selector(trueBtnClick), for: .touchUpInside)
        self.baseView.addSubview(trueBtn)
    }

    @objc private func trueBtnClick() {
        delegate?.datePickerDidChangedDateTime(date: self.datePicker.date, dateStr: "HH:mm".dateWithFormatter(date: self.datePicker.date))
        tapBtnAndcancelBtnClick()
    }
}
