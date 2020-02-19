//
//  AlertAction-Extension.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/16.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Lottie
extension UIAlertAction {
    
    func setTextColor(textColor: UIColor) {
        self.setValue(textColor, forKey: "_titleTextColor")
    }
    
}

extension UIViewController: NVActivityIndicatorViewable {
    /**
     * Show Error Message With Alert
     */
    func showErrorWithMessage(_ message: String) {
        let alert = UIAlertController(title: "提示".getLocaLized, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定".getLocaLized, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    func showSingleAlertWithMessage(_ message: String, acepted: (()->())?) {
             let alert = UIAlertController(title: "提示".getLocaLized, message: message, preferredStyle: .alert)
            let aceptAction = UIAlertAction(title: "确定".getLocaLized, style: .default) { (_) in
                acepted?()
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(aceptAction)
            self.present(alert, animated: true, completion: nil)
    }

    /// Normal Alert
    ///
    /// - Parameters:
    ///   - titleMessage: 标题
    ///   - contentMessage: 内容
    ///   - cancelTitle: 取消按钮名称
    ///   - aceptTitle: 确认按钮名称
    ///   - acepted: 确认回调
    ///   - canceled: 取消回调
    func showNormalAlert(_ titleMessage: String, contentMessage: String, cancelTitle: String = "取消".getLocaLized, aceptTitle: String = "确定".getLocaLized, aceptColor: UIColor = UIColor.systemBlueColor, acepted: (()->())?, canceled: (()->())?) {
        let alert = UIAlertController(title: titleMessage, message: contentMessage, preferredStyle: .alert)
        let aceptAction = UIAlertAction(title: aceptTitle, style: .default) { (_) in
            acepted?()
            alert.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (_) in
            canceled?()
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(aceptAction)
        aceptAction.setTextColor(textColor: aceptColor)
        self.present(alert, animated: true, completion: nil)
    }


    /// Show ProgressAnimation with NVActivityIndicatorView
    ///
    /// - Parameters:
    ///   - content: title  white and 13font
    ///   - size: size 30x30
    ///   - color: color = white
    func showLoadingAnimation(with content: String? = "", and size: CGSize? = CGSize(width: 25, height: 25), andColor color: UIColor? = .white) {
        self.startAnimating(size!, message: content!, messageFont: UIFont.systemFont(ofSize: 13), type: .lineSpinFadeLoader, color: color!, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil, fadeInAnimation: nil)
    }

}
