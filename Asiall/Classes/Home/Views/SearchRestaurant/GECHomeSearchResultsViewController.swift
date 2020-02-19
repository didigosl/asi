//
//  GECHomeSearchResultsViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/3.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECHomeSearchResultsViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tab = UITableView()
        tab.rowHeight = 64
        tab.dataSource = self
        tab.delegate = self
        view.addSubview(tab)
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.register(UINib(nibName: "GECHomeSearchRestaurantCell", bundle: nil), forCellReuseIdentifier: "search_restaurant".getIdentifier)
        return tab
    }()
    var restaurantCollections: [GECRestaurantsStoreModel]?

    //MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "搜索餐馆".getLocaLized
        autoLayoutSubView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setDatas()
    }

    // 布局
    private func autoLayoutSubView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
    }

    private func setDatas() {
        if (restaurantCollections?.count == 0) {            self.tableView.separatorStyle = .none
            self.showSingleAlertWithMessage("无此商家,请重新搜索".getLocaLized) {
                self.navigationController?.popViewController(animated: true)
            }
        }else {
            self.tableView.separatorStyle = .singleLine
            tableView.reloadData()
        }
    }

}

extension GECHomeSearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantCollections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "search_restaurant".getIdentifier, for: indexPath) as! GECHomeSearchRestaurantCell
        if let model = restaurantCollections?[indexPath.row] {
            cell.restaurantModel = model
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailVC = GECRestaurantDetailController()
       let model = restaurantCollections?[indexPath.row]
//        self.navigationController?.pushViewController(detailVC, animated: true)
        self.navigationController?.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NotificationNames.pushToRestaurante, object: model)
        })
    }
}
