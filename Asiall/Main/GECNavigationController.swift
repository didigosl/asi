//
//  GECNavigationController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/10.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECNavigationController: UINavigationController,UIGestureRecognizerDelegate {

    override func loadView() {
        super.loadView()
        var normalTextColor = UIColor(hexString: "#4B5257")!
        var bgImageColor = UIColor.white
        if #available(iOS 13.0, *) {
            navigationBar.barTintColor = UIColor(dynamicProvider: { (traitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    normalTextColor = .white
                    bgImageColor = UIColor(hexString: "#4B5257")!
                    return UIColor(hexString: "#4B5257")!
                case .light:
                    return .white
                case .unspecified:
                    return .white
                }
            })
        }
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: normalTextColor]
        navigationBar.setBackgroundImage(UIImage.imageWithColor(color: bgImageColor), for: .default)
        navigationBar.tintColor = normalTextColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set PopGesture
        //Get system gesture && view
//        if let gesture = interactivePopGestureRecognizer {
//            gesture.delegate = nil
//        }

        interactivePopGestureRecognizer?.delegate = self
//        self.delegate = self
//        let gestView = gesture.view
//        //get target
//        let targets = (gesture.value(forKey: "_targets") as? [NSObject])?.first
//        guard let target = targets?.value(forKey: "_target") else {
//            return
//        }
//        let action = Selector(("handleNavigationTransition:"))
//        //create new gesture
//        let panGes = UIScreenEdgePanGestureRecognizer(target: target, action: action)
//        panGes.delegate = self
//        gestView?.addGestureRecognizer(panGes)
    }



    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            var image: UIImage?
            if [GECRestaurantController.self, GECCartViewController.self,GECRestaurantDetailController.self,GECDishesDetailController.self].contains(where: {
                viewController.isKind(of: $0) }) {
                image = UIImage(named: "Arrow")} else {
                image = UIImage(named: "back_icon")
            }
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickReturn))
        }
        super.pushViewController(viewController, animated: animated)
        }


    //Pop
    @objc func clickReturn(){
        // 如果是订单页面将返回首页
        if let orderVC = self.children.last as? GECDetailOrderController, let VC = orderVC.navigationController?.children[1] as? GECRestaurantController {
            removeAllCartList()
            self.popToViewController(VC, animated: true)
            return
        }
        // 如果是餐馆界面并且有订单..
        guard let _ = self.children.last as? GECRestaurantController, GECHomeViewModel.cartDishesList.count > 0 else { popViewController(animated: true); return }
        self.showNormalAlert("提示".getLocaLized, contentMessage: "如果退出将删除所有购物车商品".getLocaLized, aceptColor: .red, acepted: {
            self.removeAllCartList()
            self.popViewController(animated: true)
        }, canceled: nil)
    }

    //MARK: 清理购物车餐品
    private func removeAllCartList() {
        GECHomeViewModel.removeAllCartDishes()
         NotificationCenter.default.post(name: NotificationNames.updateRestauranteDishes, object: nil)

    }
    //pop gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !isEnableEdegePan { // 禁用边缘侧滑手势
            return false
        }
        return children.count > 1
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if !isEnableEdegePan { // 禁用边缘侧滑手势
            return false
        }
        return children.count > 1
    }

    fileprivate var isEnableEdegePan = true

    /// 启用、禁用屏幕边缘侧滑手势
    func enableScreenEdgePanGestureRecognizer(_ isEnable: Bool) {
        isEnableEdegePan = isEnable
    }
}
