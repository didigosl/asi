//
//  JS_AlertBaseView.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/12.
//  Copyright © 2019 GoEat. All rights reserved.
//


/*弹框的基础图*/
import UIKit
class JS_AlertBaseView: UIView ,UIGestureRecognizerDelegate{

    //白色view用来装一些控件
    var baseView: UIView =  UIView()
    var initialFrame: CGRect = CGRect.init(x: screenWidth/2 - 10, y: screenHeight/2 - 10, width: 1, height: 1)
    var appearFrame: CGRect = CGRect.init(x: 40, y: (screenHeight - 335) / 2, width: screenWidth - 80, height: 335)
    //取消按钮
    var cancelBtn: UIButton = UIButton()
    //背景区域的颜色和透明度
    var backgroundColor1:UIColor  = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
    var defaultTime:CGFloat = 0.25

    //初始化视图
    func initAlertBaseView() -> UIView {
        self.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.backgroundColor = backgroundColor1
        self.isHidden = true
        //设置添加地址的View
        self.baseView.frame = initialFrame
        baseView.backgroundColor = UIColor.white
        baseView.layer.masksToBounds = true
        baseView.layer.cornerRadius = 10
        self.addSubview(baseView)

        cancelBtn = UIButton.init()
        cancelBtn.frame = CGRect.init(x:(screenWidth - normalButtonHeight)/2, y: baseView.frame.maxY + commonMargin, width: normalButtonHeight, height: normalButtonHeight)
        cancelBtn.tag = 1
        cancelBtn.setImage(UIImage(named: "quxiao_icon"), for: .normal)
        cancelBtn.isHidden = true
        cancelBtn.addTarget(self, action: #selector(tapBtnAndcancelBtnClick), for: .touchUpInside)
        self.addSubview(cancelBtn)
        return self
    }
    //弹出的动画效果
    func addAnimate() {

    }
    //收回的动画效果
    @objc func tapBtnAndcancelBtnClick() {
        for view in baseView.subviews {
            view.removeFromSuperview()
        }
        UIView.animate(withDuration: TimeInterval(defaultTime), animations: {
            self.cancelBtn.isHidden = true
            self.baseView.frame = self.initialFrame
            self.cancelBtn.frame.origin.y = self.baseView.frame.maxY
        }) { (_) in
            self.isHidden = true
        }

    }
}
