//
//  GECMainHomeViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 20/12/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECMainHomeViewController: UIViewController {
    //MARK: 搜索框 1
    lazy var searchBar: GECCustomSearchView = {
        let v = GECCustomSearchView.loadNib("GECCustomSearchView")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        self.view.addSubview(v)
        return v
    }()
    
    //MARK: 菜品类型 4
    lazy var businessTitlesView: GECCustomBusinessView = {
        let v = GECCustomBusinessView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: GECCustomBusinessView.height))
        v.delegate = self
        v.backgroundColor = UIColor.init(hexString: "#FFE6DC") ?? UIColor.red
        return v
    }()

    //MARK: 餐厅列表 2
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UINib(nibName: "GECMainHomeRestaurantTableCell", bundle: nil), forCellReuseIdentifier: GECMainHomeRestaurantTableCell.identifier)
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        return table
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        getBusinessDatas {}
        
        NotificationCenter.default.addObserver(forName: NotificationNames.pushToRestaurante, object: nil, queue: nil) { [weak self](notification) in
            if let model = notification.object as? GECRestaurantsStoreModel {
                self?.showRestaurantVC(model: model)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set navigationBar Transcult
        self.navigationController?.navigationBar
            .setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        self.getCurrentLocationRequest()
    }

    //View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        GECHomeViewModel.currentRestaurantDishesList = nil
        //Set default navigationBar
        self.navigationController?.navigationBar
            .setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setLayout() {
        NSLayoutConstraint.activate([
            //搜索栏
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: GECCustomSearchView.height),

            //餐馆列表
            tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    //MARK: - 开始读取数据 {关注}
    private func getBusinessDatas(completed: @escaping ()->()) {
        GECHomeViewModel.getRestaurantBusinessListRequest {[weak self] (isError) in
            if isError == false {
                self?.businessTitlesView.reloadData()
            }
            completed()
        }
    }

    private func getRestaurentsDatas(params: [String: String]) {
        GECHomeViewModel.searchRestaurant(with: params, success: { [weak self] in
            self?.tableView.reloadData()
        }) { (_) in

        }
    }

    //MARK: - 是否允许定位
    private func checkIsCanUbication() {

    }

    private func getCurrentLocationRequest() {
        GECHomeViewModel.getCurrentLocation {[weak self] in
            if let _ = GECHomeViewModel.currentLocation {
                let params = self!.getLocationParams()
                self?.getRestaurentsDatas(params: params)
                self?.updateHeaderLocationUI()
            }
        }
    }

}

//MARK: - 代理 | 数据源
extension GECMainHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GECHomeViewModel.restauranteListModel?.collection?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GECMainHomeRestaurantTableCell.identifier) as! GECMainHomeRestaurantTableCell
        if let model = GECHomeViewModel.restauranteListModel?.collection?[indexPath.row] {
            cell.storeModel = model
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return businessTitlesView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return GECCustomBusinessView.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = GECHomeViewModel.restauranteListModel?.collection?[indexPath.row], model.disabled == 1 {
            self.showErrorWithMessage("无此商家信息".getLocaLized)
            return
        }
        if let model = GECHomeViewModel.restauranteListModel?.collection?[indexPath.row] {
            showRestaurantVC(model: model)
        }
    }

    //MARK: 展示餐馆
    private func showRestaurantVC(model: GECRestaurantsStoreModel) {
        let restaurantVc = GECRestaurantController()
               // 此处为外卖
               GECHomeViewModel.isTakeIn = false
               // 获取店信息
               GECHomeViewModel.selectedRestaurantModel = model
               GECHomeViewModel.selectedRestaurantModel?.following = true
               restaurantVc.hidesBottomBarWhenPushed = true
               self.navigationController?.pushViewController(restaurantVc, animated: true)
    }
}

//MARK: - 搜索界面
extension GECMainHomeViewController: GECCustomSearchViewDelegate {
    func customSearchViewDidSelectedSearchView() {
        //        if GECUserInfoModel.getUserInfoModel() == nil {
        //            let loginVC = GECLoginViewController()
        //            loginVC.loginCallback = {[weak self] _ in
        //                self?.beginRefresh()
        //            }
        //            self.present(loginVC, animated: true, completion: nil)
        //        }
        let searchViewController = GECHomeSearchViewController()
        let navi = GECNavigationController(rootViewController: searchViewController)
        self.present(navi, animated: true) {
        }
    }

    func customSearchViewDidSelectedLocationView() {
        self.getCurrentLocationRequest()
    }

    private func updateHeaderLocationUI() {
        searchBar.updateUI()
    }
}

//选择分类
extension GECMainHomeViewController: GECCustomBusinessViewDelegate {
    func customBusinessViewDidSelected(model: GECRestaurantBusinessModel) {
        let params = getLocationParams()
        self.getRestaurentsDatas(params: params)
    }

    private func getLocationParams() -> [String: String]{
        var params = ["zipCode": GECHomeViewModel.currentLocation?.placeMark.postalCode ?? "",
//        "longitude": "\(GECHomeViewModel.currentLocation?.location.coordinate.longitude ?? 0.00)",
//            "latitude": "\(GECHomeViewModel.currentLocation?.location.coordinate.latitude ?? 0.00)",
            "pageSize": "200"]
        if let guid = GECHomeViewModel.selectedBusinessModel?.guid, guid.count > 0 {
            params["mainBusinessGuid"] = guid
        }
        return params
    }
}
