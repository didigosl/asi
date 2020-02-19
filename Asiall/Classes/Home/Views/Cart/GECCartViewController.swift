//
//  GECCartViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/15.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECCartViewController: UIViewController {

    //MARK: -
    //MARK: Vars.

    /**
     * 手势
     */
    lazy var deliveryTap = UITapGestureRecognizer(target: self, action: #selector(deliveryTimeGEstureTap(tap:)))
    lazy var paymentTap = UITapGestureRecognizer(target: self, action: #selector(paymentGestureTap(tap:)))
    lazy var directionTap = UITapGestureRecognizer(target: self, action: #selector(directionGestureTap(tap:)))

    // tableview
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoBaseView: UIView!
    @IBOutlet weak var directionView: UIView!
    // info divivery
    @IBOutlet weak var diviveryTimeView: UIView!
    @IBOutlet weak var diviveryTimeLabel: UILabel!
    // info payment
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var payMethodLabel: UILabel!
    // info client
    @IBOutlet weak var directionPlaceholder: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientPhone: UILabel!
    @IBOutlet weak var clientDirection: UILabel!
    @IBOutlet weak var submitOrderButton: UIButton!
    @IBOutlet weak var timePls: UILabel!
    @IBOutlet weak var paymentPls: UILabel!
    @IBOutlet weak var cofirmButton: UIButton!



    
    // FooterView
    private var footerView: GECCartFooterView = {
        let v = GECCartFooterView.loadNib()
        return v
    }()
    //MARK: -
    //MARK: Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getUserAddress() // 获取用户地址
        getPayMethod() //获取支付方式
        updateFooterViewData() // 更新底部价格
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - Setup UI 更新UI
    private func setup() {
        directionPlaceholder.isHidden = true
        directionPlaceholder.text = "收货地址".getLocaLized
        // tableView cornerRadius 切圆角
        infoBaseView.layer.cornerRadius = 5
        infoBaseView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        submitOrderButton.layer.cornerRadius = submitOrderButton.frame.height / 2
        submitOrderButton.layer.masksToBounds = true

        // tableView 设置参数
        tableView.register(UINib(nibName: "GECCartDishesCell", bundle: nil), forCellReuseIdentifier: GECHomeViewModel.cartDishCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = GECHomeViewModel.cartFooterHeight
        footerView.customSize = CGSize(width: screenWidth, height: GECHomeViewModel.cartFooterHeight)
        tableView.tableFooterView = footerView
        tableView.contentInset = UIEdgeInsets(top: middleMargin, left: 0, bottom: submitOrderButton.frame.height + middleMargin, right: 0)

        //设置 点击手势Gesture
        directionView.addGestureRecognizer(directionTap)
        paymentView.addGestureRecognizer(paymentTap)
        diviveryTimeView.addGestureRecognizer(deliveryTap)
        let date = Date(timeIntervalSinceNow: 30 * 60) // 30分钟后
        diviveryTimeLabel.text = "\("大约".getLocaLized)\("HH:mm".dateWithFormatter(date: date))\("送达".getLocaLized)"


        if GECHomeViewModel.selectedRestaurantModel?.takeawayStatus == 1 {
            timePls.text = "送达时间".getLocaLized
        }else {
            timePls.text = "预计到店取时间".getLocaLized
        }
        paymentPls.text = "付款方式".getLocaLized
        cofirmButton.setTitle("提交订单".getLocaLized, for: .normal)
    }

    //MARK: 更新地址
    private func updateAddress(addressModel: GECAddressModel?) {
        self.directionPlaceholder.isHidden = false
        if let model = addressModel {
            self.clientName.text = model.contact
            let address = "\(model.address1 ?? "")  \(model.address2 ?? ""), \(model.address3 ?? ""), \(model.city ?? "")"
            self.clientDirection.text = address
            self.clientPhone.text = model.phone
            self.directionPlaceholder.isHidden = true
        }
    }

    //MARK: 更新支付方式
    private func updatePayMethod(payMethod: GECStorePayMethodModel?) {
        self.payMethodLabel.text = checkPayMethod(name: payMethod?.systemName ?? "Cash")
    }

    //MARK: 更新底部价格
    private func updateFooterViewData() {
        footerView.cartPriceModel = GECHomeViewModel.cartPriceModel
        if (Double(GECHomeViewModel.cartPriceModel?.actuallyPaidAmount ?? "0.00") ?? 0.00) < (GECHomeViewModel.selectedRestaurantModel?.takeawayMinimumConsumption ?? 0.00 ){
            self.cofirmButton.isEnabled = false
            self.cofirmButton.setBackgroundImage(UIImage.imageWithColor(color: UIColor.themaLightGrayColor), for: .normal)
        }else {
            self.cofirmButton.isEnabled = true
            self.cofirmButton.setBackgroundImage(UIImage.imageWithColor(color: UIColor.themaSelectColor), for: .normal)
        }
    }

    //MARK: - Request
    //MARK: 地址获取
    private func getUserAddress() {
        guard let storeGuid = GECHomeViewModel.selectedRestaurantModel?.guid else {return}
        GECHomeViewModel.getAllAddressRequest(storeGuid: storeGuid) { [weak self](errCode) in
            if errCode != nil {self?.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: errCode!))}
            self?.updateAddress(addressModel: GECHomeViewModel.defaultAddress)
        }
    }

    //MARK: 获取支付信息
    private func getPayMethod() {
        guard let storeGuid = GECHomeViewModel.selectedRestaurantModel?.guid else {return}
        GECHomeViewModel.getPayMethods(storeGuid: storeGuid) {[weak self] (errorCode) in
            if errorCode != nil {
                self?.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: errorCode!))
            }
            self?.updatePayMethod(payMethod: GECHomeViewModel.defaultPayMethod)
        }
    }

    private func confirmOrder(completed: @escaping(()->())) {
        showLoadingAnimation()
        guard let storeGuid = GECHomeViewModel.selectedRestaurantModel?.guid, let userGuid = GECUserInfoModel.getUserInfoModel()?.guid else { return }
        GECHomeViewModel.confirmToOrder(deliveryGuid: userGuid, storeGuid: storeGuid, remark: footerView.textView.palceholdertextView.text) { [weak self] (errCode) in
            self?.stopAnimating()
            if errCode != nil {
                self?.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: errCode!))
                return
            }
            completed()
        }
    }

    // MARK: - Action
    //MARK: 提交订单
    @IBAction func submitOrderAction(_ sender: UIButton) {
        confirmOrder {
            let detail = GECDetailOrderController()
            GECHomeViewModel.dishesCount = GECHomeViewModel.cartDishesList.count
            NotificationCenter.default.post(name: NotificationNames.updateFollowRestaurant, object: nil)
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }

    // MARK: 选择地址
    @objc func directionGestureTap(tap: UITapGestureRecognizer) {
        let addressViewController = GECProfileAddressController()
        addressViewController.cartAddressList = GECHomeViewModel.userAddressList
        addressViewController.selectedAddressCallback = {[weak self] (model) in
            GECHomeViewModel.defaultAddress = model
            self?.updateAddress(addressModel: model)
        }
        self.navigationController?.pushViewController(addressViewController, animated: true)
    }

    //MARK: 送达时间修改
    @objc func deliveryTimeGEstureTap(tap: UITapGestureRecognizer) {
        let alertDatePickerView = JS_AlertDatePickerView()
        alertDatePickerView.delegate = self
        alertDatePickerView.addAnimate()
    }

    //MARK: 选择支付方式
    @objc func paymentGestureTap(tap: UITapGestureRecognizer) {
        selectPaymentAlert()
    }

    /// 支付方式弹窗
    private func selectPaymentAlert() {
        let alert = UIAlertController(title: "支付方式".getLocaLized, message: "请选择支付方式".getLocaLized, preferredStyle: .actionSheet)
        var creditAction: UIAlertAction?
        var offLineAction: UIAlertAction?
        var coupongAction: UIAlertAction?
        for item in GECHomeViewModel.storePayMethodList {
            if let systemName = item.systemName {
                switch systemName {
                case "Cash":
                    creditAction = UIAlertAction(title: "现金支付".getLocaLized, style: .default) {[weak self] (_) in
                        GECHomeViewModel.defaultPayMethod = item
                        self?.updatePayMethod(payMethod: item)
                    }
                case "Visa":
                    offLineAction = UIAlertAction(title: "信用卡支付".getLocaLized, style: .default) {[weak self] (_) in
                        GECHomeViewModel.defaultPayMethod = item
                        self?.updatePayMethod(payMethod: item)
                    }
                default:
                    coupongAction = UIAlertAction(title: "代金券支付".getLocaLized, style: .default) {[weak self] (_) in
                        GECHomeViewModel.defaultPayMethod = item
                        self?.updatePayMethod(payMethod: item)
                    }
                }
            }
        }

        let cancelAction = UIAlertAction(title: "取消".getLocaLized, style: .cancel, handler: nil)

        if let credit = creditAction { alert.addAction(credit)
            credit.setTextColor(textColor: UIColor.themaNormalColor)
        }
        if let offLine = offLineAction { alert.addAction(offLine)
            offLine.setTextColor(textColor: UIColor.themaNormalColor)
        }
        if let coupon = coupongAction { alert.addAction(coupon)
            coupon.setTextColor(textColor: UIColor.themaNormalColor)
        }
        alert.addAction(cancelAction)
        cancelAction.setTextColor(textColor: UIColor.red)
        self.present(alert, animated: true, completion: nil)
    }

    private func checkPayMethod(name: String) -> String{
        switch name {
        case "Cash":
            return "现金支付".getLocaLized
        case "Visa":
            return "信用卡支付".getLocaLized
        default:
            return"代金券支付".getLocaLized
        }
    }
}



// MARK: - UITableViewDataSource
extension GECCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GECHomeViewModel.cartDishesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GECHomeViewModel.cartDishCellIdentifier, for: indexPath) as! GECCartDishesCell
        cell.dishModel = GECHomeViewModel.cartDishesList[indexPath.row]
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if GECHomeViewModel.cartDishesList[indexPath.row].menuSelectedGarnishedList.count > 0{
            return UITableView.automaticDimension
        }else {
            return GECHomeViewModel.cartRowHeight
        }
    }

}

// MARK: 时间选择器 Delegate
extension GECCartViewController: AlertDatePickerDelegate {
    func datePickerDidChangedDateTime(date: Date, dateStr: String) {
        self.diviveryTimeLabel.text = "\("大约".getLocaLized)\(dateStr)\("送达".getLocaLized)"
    }
}

// MARK: - UITableViewDelegate
extension GECCartViewController: UITableViewDelegate {

}

extension GECCartViewController: GECCartDishCellDelegate {
    func cartDishCellDidSelectAddItemAction(cell: GECCartDishesCell, dishModel: GECRestaurantDishModel) {
        guard let index = tableView.indexPath(for: cell) else { return }
        if let _ = dishModel.menuSelectedGarnishedList.first {
            dishModel.addedGarnishCount += 1
        }else {
            GECHomeViewModel.addDishToCart(model: dishModel)
        }
        updateView(index: index, model: dishModel, isAdd: true)
    }

    func cartDishCellDidSelectSubtractItemAction(cell: GECCartDishesCell, dishModel: GECRestaurantDishModel) {
        guard let index = tableView.indexPath(for: cell) else { return }

        if let _ = dishModel.menuSelectedGarnishedList.first {
            if dishModel.addedGarnishCount - 1 == 0 {
                GECHomeViewModel.cartDishesList.remove(at: GECHomeViewModel.cartDishesList.index(of: dishModel) ?? 0)
            }else {
                dishModel.addedGarnishCount -= 1
            }
        }else {
            if dishModel.quantity - 1 == 0 {
                GECHomeViewModel.removeDishFromCart(with: dishModel)
            }else {
                GECHomeViewModel.subtractFromCart(with: dishModel)
            }
        }
        updateView(index: index, model: dishModel, isAdd: false)
    }

    private func updateView(index: IndexPath, model: GECRestaurantDishModel, isAdd: Bool) {
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
        GECHomeViewModel.caculateCart { [weak self] (_) in
            NotificationCenter.default.post(name: NotificationNames.checkRestaurantDishsList, object: nil, userInfo: ["model": model, "isAdd": isAdd])
            self?.updateFooterViewData()
            if GECHomeViewModel.cartDishesList.count == 0 {
                self?.showSingleAlertWithMessage("您已清空购物车".getLocaLized, acepted: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
}
