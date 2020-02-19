//
//  UIView-Extension.swift
//  Tools
//
//  Created by JS_Coder on 11/20/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import UIKit
//MARK: - Toast
extension UIView{
    //Shake Direction
    public enum ShakeDirection: Int {
        case horizontal  //
        case vertical  //
    }

    /**
     Shake
     @param direction:
     @param times：shake count（5）
     @param interval：shake repat speed（0.1s）
     @param delta：float（2）
     @param completion：completed
     */
    public func shake(direction: ShakeDirection = .horizontal, times: Int = 5,
                      interval: TimeInterval = 0.1, delta: CGFloat = 2,
                      completion: (() -> Void)? = nil) {
        //Animate
        UIView.animate(withDuration: interval, animations: { () -> Void in
            switch direction {
            case .horizontal:
                self.layer.setAffineTransform( CGAffineTransform(translationX: delta, y: 0))
                break
            case .vertical:
                self.layer.setAffineTransform( CGAffineTransform(translationX: 0, y: delta))
                break
            }
        }) { (complete) -> Void in
            //completed
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: { () -> Void in
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) -> Void in
                    completion?()
                })
            }
                //loading animate
            else {
                self.shake(direction: direction, times: times - 1,  interval: interval,
                           delta: delta * -1, completion:completion)
            }
        }
    }


    /// Show Alert like Toast android
    ///
    /// - Parameters:
    ///   - text: text will to show
    ///   - showTime: time to display (default = 0.5)
    ///   - dissmissTime: time to disappear (default = 1.5)
    func showToast(withString text: String, _ showTime: Double = 0.5, _ removeTime: Double = 1.5){
        let toast = UILabel()
        toast.numberOfLines = 0
        toast.lineBreakMode = .byWordWrapping
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        toast.textColor = .white
        toast.layer.cornerRadius = 10.0
        toast.layer.masksToBounds = true
        toast.textAlignment = .center
        toast.font = UIFont.systemFont(ofSize: 15)
        toast.text = text
        toast.alpha = 0.0
        
        let maxSize = CGSize(width: self.bounds.width - 40, height: self.bounds.height)
        var expectedSize = toast.sizeThatFits(maxSize)
        var lbWidth = maxSize.width
        var lbHeight = maxSize.height
        if maxSize.width >= expectedSize.width{
            lbWidth = expectedSize.width
        }
        if maxSize.height >= expectedSize.height{
            lbHeight = expectedSize.height
        }
        
        expectedSize = CGSize(width: lbWidth, height: lbHeight)
        toast.frame.size = expectedSize
        toast.center = self.center
        toast.tag = 1008610086
        self.addSubview(toast)
        
        UIView.animate(withDuration: showTime, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations: {
            toast.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: removeTime, animations: {
                toast.alpha = 0.0
            }, completion: { (_) in
                toast.removeFromSuperview()
            })
        }
    }
    // remove FromSuperView
   private func removeForceToast(){
        for t in self.subviews{
            if t is UILabel, t.tag == 1008610086{
                t.removeFromSuperview()
            }
        }
    }

    //MARK: - Corner
    /// addCorner
    ///
    /// - Parameters:
    ///   - roudingCorners: UIRectCorner
    ///   - cornerSize: size
    func addCorner(roudingCorners: UIRectCorner, cornerSize: CGSize){
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roudingCorners, cornerRadii: cornerSize)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path.cgPath
        layer.mask = cornerLayer
    }


    ///设置 View 圆角
    ///
    /// - Parameter borderColor: 边框颜色
    func setRadiuCorner(borderColor: UIColor? = UIColor.themaNormalColor, radius: CGFloat = 10) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor!.cgColor
        self.layer.borderWidth = 1
    }
}

extension UILabel {
    
}
