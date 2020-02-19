//
//  GECTabBar.swift
//  G-eat
//
//  Created by 浩哲 夏 on 2019/1/9.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
class GECTabBar: UITabBar {

    private lazy var scanView: UIButton = {
        let scanView = UIButton()
        scanView.frame = CGRect(x: (self.bounds.width - GECMainViewModel.centerButtonSize.width) / 2, y: -commonMargin , width: GECMainViewModel.centerButtonSize.width, height: GECMainViewModel.centerButtonSize.height)
        scanView.addTarget(self, action: #selector(scanActionSelected), for: .touchUpInside)
        scanView.setBackgroundImage(UIImage(named: "scanIcon"), for: .normal)
        scanView.layer.shadowColor = UIColor.themaNormalColor.cgColor
        scanView.layer.shadowRadius = 5
        scanView.layer.shadowOffset = CGSize(width: -2, height: 2)
        scanView.layer.shadowOpacity = 0.3
        return scanView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let count = self.items?.count else {
            return
        }

        let widthItem : CGFloat = self.frame.width / (CGFloat)(count + 1)
        var i : CGFloat = 0

        for tabBar in self.subviews {
            if tabBar.isKind(of:NSClassFromString("UITabBarButton")!){
                if i == 0 {
                    tabBar.frame = CGRect(x: i * widthItem, y: tabBar.frame.origin.y, width: widthItem, height: tabBar.frame.height)
                }else if i == 1 {
                    tabBar.frame = CGRect(x: (i + 1) * widthItem, y: tabBar.frame.origin.y, width: widthItem, height: tabBar.frame.height)
                    self.addSubview(scanView)
                }
                i += 1
            }else if tabBar.isKind(of: NSClassFromString("_UIBarBackground")!) {
                if let imageView = tabBar.subviews.first {
                    imageView.removeFromSuperview()
                }
            }
        }
    }


//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if self.isHidden == false {
//            var vi = super.hitTest(point, with: event)
//            if vi == nil {
//                let newView = self.subviews[1]
//                let newPoint = newView.convert(point, from: self)
//                if newView.bounds.contains(newPoint) {
//                    vi = newView
//                }
//            }
//            return vi
//        }else {
//            return super.hitTest(point, with: event)
//        }
//    }

    //MARK: - Scan Action
    @objc private func scanActionSelected() {
        let scanVC = GECScanViewController()
        UIView.animate(withDuration: 0.5, animations: {
            self.scanView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.scanView.alpha = 0.1
        }) { (_) in
//            scanVC.modalPresentationStyle = .fullScreen
            UIApplication.shared.keyWindow?.rootViewController?.present(scanVC, animated: true, completion: {
                self.scanView.transform = .identity
                self.scanView.alpha = 1.0
            })
        }
    }
}
