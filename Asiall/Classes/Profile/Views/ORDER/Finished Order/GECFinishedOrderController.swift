//
//  GECFinishedOrderController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/13.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECFinishedOrderController: GECBasicOrderViewController {

    //MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    //MARK: - 初始化
    override func configure() {
        tableView.register(UINib(nibName: "GECProfileOrderCell", bundle: nil), forCellReuseIdentifier: GECProfileViewModel.finishedCellIdentifier)
        setData()
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

    //MARK: 更新
    override func updateOrderList() {
        setData()
    }

    override func updateTableView() {
        if GECProfileViewModel.finishedOrderList.count > 0 {
            placeholder.isHidden = true
            self.tableView.reloadData()
        }else {
            placeholder.isHidden = false
        }
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GECProfileViewModel.finishedOrderList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GECProfileViewModel.finishedCellIdentifier, for: indexPath) as! GECProfileOrderCell
        cell.selectionStyle = .none
        cell.orderModel = GECProfileViewModel.finishedOrderList[indexPath.row]
        return cell
    }

    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = GECProfileViewModel.finishedOrderList[indexPath.row]
        let detailVc = GECDetailOrderController()
        detailVc.searchOrderModel = model
        GECHomeViewModel.dishesCount = model.itemCount ?? 1
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}
