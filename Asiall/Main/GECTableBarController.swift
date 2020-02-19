//
//  GECTableBarController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/10.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
class GECTableBarController: UITabBarController {

    //MARK: -
    //MARK: Vars
    // controllers
    let childsControllers = [[ControllersKeys.className: GECMainHomeViewController.self,
                              ControllersKeys.tableTitle: "首页".getLocaLized, ControllersKeys.tabImage: "home"],
                             [ControllersKeys.className: GECProfileViewController.self, ControllersKeys.tableTitle: "我的".getLocaLized, ControllersKeys.tabImage: "profile"]]



//    private lazy var scanView: UIButton = {
//        let scanView = UIButton()
//        scanView.frame = CGRect(x: (tabBar.bounds.width - GECMainViewModel.centerButtonSize.width) / 2, y: -commonMargin, width: GECMainViewModel.centerButtonSize.width, height: GECMainViewModel.centerButtonSize.height)
//        scanView.setImage(UIImage(named: "scanIcon"), for: .normal)
//
//        scanView.addTarget(self, action: #selector(scanActionSelected), for: .touchUpInside)
//        scanView.layer.shadowColor = UIColor.themaNormalColor.cgColor
//        scanView.layer.shadowRadius = 5
//        scanView.layer.shadowOffset = CGSize(width: -2, height: 2)
//        scanView.layer.shadowOpacity = 0.3
//        return scanView
//    }()

    //MARK: -
    //MARK: Life
    override func loadView() {
        super.loadView()
        let tab = UITabBarItem.appearance()
        // Set Font and Color
        tab.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.themaSelectColor, NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)], for: .selected)

        tab.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.themaNormalColor, NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)], for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeTabBarToCustom()
        listingNeedToLogin()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: -
    //MARK: Method
    private func setup() {
        if #available(iOS 13, *) {
            self.tabBar.unselectedItemTintColor = UIColor.themaLightGrayColor
        }
        for (_,item) in childsControllers.enumerated(){
            addChild(initialControllers(dict: item))
        }
    }

    private func listingNeedToLogin() {
        weak var weakSelf = self
        NotificationCenter.default.addObserver(forName: NotificationNames.needToLogin, object: nil, queue: nil) { (_) in
            
            weakSelf?.showSingleAlertWithMessage("您的登陆已失效, 请重新登陆".getLocaLized, acepted: {
                let loginVC = GECLoginViewController()
                weakSelf?.present(loginVC, animated: true, completion: nil)
            })
        }
    }

    private func changeTabBarToCustom(){
        let tabBar = GECTabBar(frame: self.tabBar.frame)
        setValue(tabBar, forKey: "tabBar")
//        tabBar.addSubview(scanView)
    }
    
    private func initialControllers(dict: [String: Any]) -> UIViewController {
        guard let cls = dict[ControllersKeys.className] as? UIViewController.Type,
            let title = dict[ControllersKeys.tableTitle] as? String,
            let image = dict[ControllersKeys.tabImage] as? String
            else {
                return UIViewController()
        }

        let vc = cls.init()
        vc.title = title
        vc.tabBarItem.image = UIImage(named: image + "_normal")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: image + "_selected")?.withRenderingMode(.alwaysOriginal)
        let nav = GECNavigationController(rootViewController: vc)
        return nav
    }

    

}
