//
//  GECTakeInCartViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 24/07/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit


class GECTakeInCartViewController: UIViewController, GECTakeInCartSocketDelegate {

    let cellIdentifier = "GECTakeInCartDishCellTableViewCell"
    //MARK: - Vars.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomOperationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var continueToBuyButton: UIButton!

    lazy var footerView: GECCartFooterView = {
        let footer = GECCartFooterView.loadNib()
        return footer
    }()
    let socketSingleton = CartSocketSingleton.shared

    //MARK: - Circle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setData()
    }

    //MARK: - 初始化
    private func setup() {
        self.title = "选中菜品".getLocaLized
        //tableView
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.register(UINib(nibName: "GECTakeInCartDishCellTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = footerView
        tableView.sectionFooterHeight = GECHomeViewModel.cartFooterHeight
        footerView.customSize = CGSize(width: screenWidth, height: GECHomeViewModel.cartFooterHeight)
        tableView.tableFooterView = footerView
    }

    private func setData() {
        if let model = GECHomeViewModel.takeInCartModel {
            footerView.totalPrice.text = "\(model.actuallyPaidAmount ?? "0.00") €"
            footerView.actuallyPrice.text = footerView.totalPrice.text
            footerView.discountPrice.text = "- 0.00€"
        }
        socketSingleton.delegate = self
//        socketSingleton.cartSocketConnect()
    }

    //MARK - Functions
    @IBAction func continueToBuyTouchUpInsideAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func placeToOrderTouchUpInsideAction(_ sender: Any) {
        GECHomeViewModel.takeInOrder { (isFinished) in
            if isFinished {
                self.showSingleAlertWithMessage("下单成功".getLocaLized, acepted: {
                    NotificationCenter.default.post(name: NotificationNames.updateTakeInRestaurant, object: nil)
                    self.navigationController?.popViewController(animated: true)
                })
            }else {
                self.showErrorWithMessage("服务器错误".getLocaLized)
            }
        }
    }
}

extension GECTakeInCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GECHomeViewModel.takeInCartModel?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GECTakeInCartDishCellTableViewCell
        if let itemModel = GECHomeViewModel.takeInCartModel?.items?[indexPath.row] {
            cell.itemModel = itemModel
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "本次挑选的菜品".getLocaLized
    }

    func socketUpdateTakeInCartOperationView() {
        self.tableView.reloadData()
        setData()
    }
    
}
