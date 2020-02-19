//
//  GECTakeInOrderViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 24/07/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
class GECTakeInOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Vars..
    lazy var tableView: UITableView = {
        let tab = UITableView(frame: CGRect.zero, style: .plain)
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.register(UINib(nibName: "GECTakeInOrderCell", bundle: nil), forCellReuseIdentifier: GECTakeInOrderCell.identifier)
        tab.rowHeight = 35
        tab.sectionHeaderHeight = 35
        tab.sectionFooterHeight = 44
        tab.delegate = self
        tab.dataSource = self
        self.view.addSubview(tab)
        return tab
    }()

    //MARK: - Circle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setup()
    }

    


    //MARK: - Functions
    private func setup() {
        self.title = "我的菜单".getLocaLized
        addLayoutConstraint()

    }

    private func addLayoutConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: commonMargin),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: commonMargin),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -commonMargin),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -commonMargin)
            ])
    }

   


    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return GECHomeViewModel.takeInOrderItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = GECHomeViewModel.takeInOrderItems["\(section)"]
        return items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GECTakeInOrderCell.identifier, for: indexPath) as! GECTakeInOrderCell
        if let item = GECHomeViewModel.takeInOrderItems["\(indexPath.section)"]?[indexPath.row] {
            cell.orderItemModel = item
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 35))
        let title = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height))
        if section == 0 {
            title.text = "首次下单".getLocaLized
        }else {
            title.text = "\("加菜".getLocaLized) \(section)"
        }
        headerView.addSubview(title)
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section !=  GECHomeViewModel.takeInOrderItems.count - 1 { return nil }
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        if let order = GECHomeViewModel.takeInOrderModel {
            priceLabel.text = "合计".getLocaLized + " \(order.actuallyPaidAmount ?? "0.00 €")"
        }
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -commonMargin),
            priceLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
            ])
        return footerView
    }
}
