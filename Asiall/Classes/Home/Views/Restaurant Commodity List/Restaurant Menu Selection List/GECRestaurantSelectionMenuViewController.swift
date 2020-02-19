//
//  GECRestaurantSelectionMenuViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 06/09/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECRestaurantSelectionMenuViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "GECRestaurantMenuSelectionCell", bundle: nil), forCellReuseIdentifier: GECRestaurantMenuSelectionCell.identifier)
        tableView.backgroundColor = UIColor.themaBackgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        return tableView
    }()


    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage.imageWithColor(color: UIColor.themaSelectColor), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(color: UIColor.themaLightGrayColor), for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("保存".getLocaLized, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(saveGarnish), for: .touchUpInside)
        button.isEnabled = false
        self.view.addSubview(button)
        return button
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        self.navigationItem.title = GECHomeViewModel.selectedDishModel?.name
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.saveButton.topAnchor),

            saveButton.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            saveButton.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            saveButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: statusBarHeight > 22 ? 64 : 49)
            ])
    }

    @objc
    private func saveGarnish() {
        guard let originModel = GECHomeViewModel.selectedDishModel , let model = GECHomeViewModel.selectedDishModel?.copy() as? GECRestaurantDishModel, let garnishes = model.garnishes else { return }

        let copyModel = model.copy() as! GECRestaurantDishModel
        var copyGarnishes = [GECCommodityGarnishModel]()
        for item in garnishes {
            let tempCopyModel = item.copy() as! GECCommodityGarnishModel
            for commodity in item.selectCommodity {
                tempCopyModel.selectCommodity.append(commodity.copy() as! GECRestaurantDishModel)
            }
            copyGarnishes.append(tempCopyModel)
        }
        
        originModel.quantity += 1
        copyModel.addedGarnishCount += 1
        copyModel.menuSelectedGarnishedList.append(copyGarnishes)
        GECHomeViewModel.cartDishesList.append(copyModel)
        for garnish in garnishes {
            _ = garnish.selectCommodity.map{$0.garnishCommoditySelected = false}
            garnish.selectCommodity.removeAll()
        }

        NotificationCenter.default.post(name: NotificationNames.updateRestauranteDishes, object: nil)
        self.navigationController?.popViewController(animated: true)
    }

    private func checkSaveButton() {
        var canTouch: Bool = true
        if let menuModel = GECHomeViewModel.selectedDishModel, let garnishes = menuModel.garnishes {
            for (_,garnish) in garnishes.enumerated() {
                if !(garnish.selectCommodity.count == garnish.min_select_num ?? 0) {
                    canTouch = false
                }
            }
            saveButton.isEnabled = canTouch
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GECRestaurantSelectionMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return GECHomeViewModel.selectedDishModel?.garnishes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        if GECHomeViewModel.selectedDishModel?.garnishes?[section].isShowCommodity == true {
            if let garnishModel = GECHomeViewModel.selectedDishModel?.garnishes?[section] {
                if garnishModel.selectCommodity.count == garnishModel.min_select_num ?? 0 {
                    number = garnishModel.selectCommodity.count
                }else {
                    number = GECHomeViewModel.selectedDishModel?.garnishes?[section].commodityList?.count ?? 0
                }
            }
        }
        return number
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GECRestaurantMenuSelectionCell.identifier, for: indexPath) as! GECRestaurantMenuSelectionCell
        if let garnishModel = GECHomeViewModel.selectedDishModel?.garnishes?[indexPath.section] {
            if garnishModel.selectCommodity.count == garnishModel.min_select_num ?? 0 {
                cell.commodityModel = garnishModel.selectCommodity[indexPath.row]
            }else {
                cell.commodityModel = GECHomeViewModel.selectedDishModel?.garnishes?[indexPath.section].commodityList?[indexPath.row]
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = GECRestaurantMenuSelectionHeaderView()
        headerView.garnishModel = GECHomeViewModel.selectedDishModel?.garnishes?[section]
        headerView.tag = section
        headerView.delegate = self
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let garnishModel = GECHomeViewModel.selectedDishModel?.garnishes?[indexPath.section], var commodityModel = garnishModel.commodityList?[indexPath.row] {
            if garnishModel.selectCommodity.count == (garnishModel.min_select_num ?? 0) { // 这里列表展示的 已经是 选择的 商品了
                commodityModel = garnishModel.selectCommodity[indexPath.row]
            }
            commodityModel.garnishCommoditySelected = !commodityModel.garnishCommoditySelected

            if commodityModel.garnishCommoditySelected == true {
                garnishModel.selectCommodity.append(commodityModel)
            }else {
                var tempModels = garnishModel.selectCommodity
                for index in 0..<garnishModel.selectCommodity.count {
                    if (garnishModel.selectCommodity[index].commodity_guid ?? "").elementsEqual(commodityModel.commodity_guid ?? commodityModel.guid ?? "") {
                        tempModels.remove(at: index)
                    }
                }
                garnishModel.selectCommodity = tempModels
            }
            checkSaveButton()
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .none)
        }
    }
}


// MARK: - RestaurantMenuSelectionHeaderViewDelegate section点击
extension GECRestaurantSelectionMenuViewController: RestaurantMenuSelectionHeaderViewDelegate {
    func restaurantMenuSelectionHeaderViewSelect(section: Int) {
        GECHomeViewModel.selectedDishModel?.garnishes?[section].isShowCommodity = !(GECHomeViewModel.selectedDishModel?.garnishes?[section].isShowCommodity ?? false)
        tableView.reloadSections(IndexSet(arrayLiteral: section), with: .none)
    }
}
