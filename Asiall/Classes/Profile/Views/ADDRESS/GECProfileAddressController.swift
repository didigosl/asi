//
//  GECProfileAddressController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/11.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECProfileAddressController: UIViewController {
typealias addressCallBack = ((_ addressModel: GECAddressModel)->())
    //MARK: -
    //MARK: Vars.
    // tableView
    @IBOutlet weak var tableView: UITableView!
    // bottom button
    @IBOutlet weak var bottomButton: UIButton!

    var selectedAddressCallback: addressCallBack?
    var addressList: GECAddressModelList? {
        didSet {
            setAddress()
            self.tableView.reloadData()
        }
    }

    var cartAddressList: GECAddressModelList? {
        didSet {
            setAddress()
        }
    }

    //MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateAddressObserver()
        if cartAddressList == nil {
            getAddressRequest()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    //MARK: 删除监听
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - setup
    private func setup() {
        view.backgroundColor = .white
        self.title = "地址管理".getLocaLized
        // set tableView
        tableView.register(UINib(nibName: "GECAddressCell", bundle: nil), forCellReuseIdentifier: GECProfileViewModel.addressCellIdentifier)
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self

        // set bottom button
        bottomButton.setTitle("添加地址".getLocaLized, for: .normal)
        bottomButton.setTitleColor(.white, for: .normal)
        bottomButton.backgroundColor = UIColor.themaSelectColor
    }

    //MARK: 设置从购物车获取的地址
    private func setAddress() {
        if let list = self.addressList {
            GECProfileViewModel.userAddressList = list
            _ = list.map({
                if let flag = $0.defaultAddress, flag == 1 {
                    GECProfileViewModel.directionInfo = $0
                }
            })
        }else if let list = self.cartAddressList {
            GECProfileViewModel.userAddressList = list
            _ = list.map({
                if let flag = $0.defaultAddress, flag == 1 {
                    GECProfileViewModel.directionInfo = $0
                }
            })
        }
    }

    //MARK: 获取最新地址
    private func getAddressRequest() {
        self.showLoadingAnimation()
        GECHomeViewModel.getAllAddressRequest(storeGuid: "address") {[weak self] (errCode) in
            self?.stopAnimating()
            if let errCode = errCode {
                self?.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: errCode))
                return
            }
            self?.addressList = GECHomeViewModel.userAddressList
        }
    }

    //MARK: - Actions
    //MARK: 添加新地址
    @IBAction func addNewDirectionAction(_ sender: UIButton) {
        GECProfileViewModel.isNewDirection = true
        let vc = GECGestionDirectController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: 监听更新地址通知
    private func updateAddressObserver() {
        NotificationCenter.default.addObserver(forName: NotificationNames.updateAddress, object: nil, queue: nil) { (_) in
            self.getAddressRequest()
        }
    }

    //MARK: 删除地址
    private func deleteAddressRequest(model: GECAddressModel, completed: @escaping (_ canremove: Bool)->()) {
        self.showLoadingAnimation(andColor: UIColor.themaSelectColor)
        GECProfileViewModel.deleteAddressRequest(model: model) { [weak self] (errCode) in
            self?.stopAnimating()
            if let err = errCode {
                self?.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: err))
                completed(false)
                return
            }
            completed(true)
        }
    }
}

// MARK: - UITableViewDataSource
extension GECProfileAddressController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GECProfileViewModel.userAddressList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GECProfileViewModel.addressCellIdentifier, for: indexPath) as! GECAddressCell
        if let model = GECProfileViewModel.userAddressList?[indexPath.row] {
            cell.addressModel = model
        }
        cell.delegate = self
        return cell
    }
}


// MARK: - 编辑地址
extension GECProfileAddressController: GECProfileAddressCellDelegate {
    func addressCellDidSelectedEditAction(cell: GECAddressCell, model: GECAddressModel) {
        GECProfileViewModel.isNewDirection = false
        let editAddressViewController = GECGestionDirectController()
        editAddressViewController.addressModel = model
        self.navigationController?.pushViewController(editAddressViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension GECProfileAddressController: UITableViewDelegate {

    //MARK: - 选中地址
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var addModel:GECAddressModel?
        if let cartAddressList = self.cartAddressList, cartAddressList.count > 0{
            addModel = cartAddressList[indexPath.row]
        }else {
            addModel = addressList?[indexPath.row]
        }
        selectedAddressCallback?(addModel!)
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - 删除样式 iOS 11.0 *
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: UIContextualAction.Style.destructive, title: "删除".getLocaLized) { (delete, tableView, canRemove) in
            let alert = UIAlertController(title: "提示".getLocaLized, message: "删除后将无法恢复,是否删除地址".getLocaLized, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消".getLocaLized, style: .default, handler: { (_) in
                canRemove(false)
            })
            let aceptAction = UIAlertAction(title: "确定".getLocaLized, style: .destructive, handler: { (_) in
                if let model = self.addressList?[indexPath.row] {
                    self.deleteAddressRequest(model: model, completed: { (isCan) in
                        canRemove(true)
                    })
                }else if let model = self.cartAddressList?[indexPath.row] {
                    self.deleteAddressRequest(model: model, completed: { (isCan) in
                        canRemove(true)
                    })
                }else {
                    self.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: ErrorCode.ERROR_ADDRESS_INFO))
                    canRemove(false)
                }
            })
            alert.addAction(cancelAction)
            alert.addAction(aceptAction)
            aceptAction.setTextColor(textColor: UIColor.red)
            cancelAction.setTextColor(textColor: UIColor.themaNormalColor)
            self.present(alert, animated: true, completion: nil)
        }
        let swipe = UISwipeActionsConfiguration(actions: [action])
        return swipe
    }
}
