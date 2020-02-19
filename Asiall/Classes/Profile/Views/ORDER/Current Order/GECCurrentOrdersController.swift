//
//  GECCurrentOrdersController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/13.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
class GECCurrentOrdersController: GECBasicOrderViewController {


    //MARK: - Vars.

    //MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - 初始化
    override func configure() {
        tableView.register(UINib.init(nibName: "GECProfileOrderCell", bundle: nil), forCellReuseIdentifier: GECProfileViewModel.currentCellIdentifier)
        setData()

        NotificationCenter.default.addObserver(forName: NotificationNames.updateOrderList, object: nil, queue: nil) { (_) in
            self.updateOrderList()
        }
    }

    //MARK: 获取订单
    private func setData() {
        GECProfileViewModel.getOrderList(nil) { [weak self](errCode) in
            guard errCode == nil else {
                self?.refresh.endRefreshing()
                self?.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: errCode!)); return}
            self?.refresh.endRefreshing()
            self?.updateTableView()
        }
    }



    //刷新更新
    override func updateOrderList() {
        setData()
        NotificationCenter.default.post(name: NotificationNames.updateFollowRestaurant, object: nil)
    }

    override func updateTableView() {
        if GECProfileViewModel.currentOrderList.count > 0 {
            placeholder.isHidden = true
        }else {
            placeholder.isHidden = false
        }
        self.tableView.reloadData()
    }

    //MARK: - TableView Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GECProfileViewModel.currentOrderList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GECProfileViewModel.currentCellIdentifier, for: indexPath) as! GECProfileOrderCell
        cell.selectionStyle = .none
        cell.orderModel = GECProfileViewModel.currentOrderList[indexPath.row]
        return cell
    }

    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = GECProfileViewModel.currentOrderList[indexPath.row]
        let detailVc = GECDetailOrderController()
        detailVc.searchOrderModel = model
        GECHomeViewModel.dishesCount = model.itemCount ?? 1
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}
