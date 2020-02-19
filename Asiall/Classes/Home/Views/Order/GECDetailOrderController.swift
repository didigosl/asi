//
//  GEDetailOrderController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/15.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECDetailOrderController: UIViewController {


    //MARK: -
    //MARK: Vars
    @IBOutlet weak var baseScrollView: UIScrollView!

    @IBOutlet weak var confirmOrderButton: UIButton!
    @IBOutlet weak var orderTimeOutLabel: UILabel!
    //MARK: tableView packge
    //Footer view
    lazy var footerView: GECOrderFooterCell = {
        let footer = GECOrderFooterCell.loadNib()
        return footer
    }()

    //MARK: - Bottom 确认订单 View
    @IBOutlet weak var operationView: UIView!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var operationHeight: NSLayoutConstraint!
    

    // Header view
    lazy var headerView: GECOrderHeaderCell = {
        let header = GECOrderHeaderCell.loadNib()
        return header
    }()

    // Tableview
    lazy var tableView: UITableView = {
        let tab = UITableView()
        tab.separatorStyle = .none
        tab.rowHeight = GECHomeViewModel.orderRowHeight
        tab.sectionHeaderHeight = GECHomeViewModel.orderHeaderHeight
        tab.sectionFooterHeight = GECHomeViewModel.orderFooterHeight
        tab.register(UINib(nibName: "GECOrderDishesCell", bundle: nil), forCellReuseIdentifier: "GECOrderDishesCell")
        return tab
    }()

    //MARK:- Bottom Info View
    // Devivery View
    lazy var deviveryView: GECOrderDeviveryInfoView = {
        let devivery = GECOrderDeviveryInfoView.loadNib("GECOrderDeviveryInfoView")
        return devivery
    }()

    // Info View
    lazy var infoView: GECOrderInfoView = {
        let info = GECOrderInfoView.loadNib()
        return info
    }()

    var searchOrderModel: GECOrderModel?

    //MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setData()
    }

    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set navigationBar Transcult
        let navigation = self.navigationController as? GECNavigationController
        navigation?.enableScreenEdgePanGestureRecognizer(false)
        self.tabBarController?.tabBar.isHidden = true
    }

    //View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Set default navigationBar、
        let navigation = self.navigationController as? GECNavigationController
        navigation?.enableScreenEdgePanGestureRecognizer(true)
        self.tabBarController?.tabBar.isHidden = false
    }

    //MARK: Setup UI 初始化
    private func setup() {
        self.title = "订单详情".getLocaLized
        view.backgroundColor = UIColor.themaBackgroundColor
        view.addSubview(baseScrollView)

        orderTimeOutLabel.text = "订单已经过期, 确认订单已经完成?".getLocaLized
        confirmOrderButton.setTitle("确定".getLocaLized, for: .normal)

        //计算tableView 高度 ( 根据模型数量 )
        let tableviewHeight = GECHomeViewModel.orderRowHeight * CGFloat(GECHomeViewModel.dishesCount) + GECHomeViewModel.orderFooterHeight + GECHomeViewModel.orderHeaderHeight
        tableView.frame = CGRect(x: miniMargin, y: miniMargin * 2, width: screenWidth - miniMargin * 2, height: tableviewHeight)

        // 加载tableView 头部和尾部视图
        baseScrollView.addSubview(tableView)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView

        tableView.dataSource = self
        tableView.delegate = self
        // 重新计算底部视图大小
        deviveryView.customFrame = CGRect(x: miniMargin, y: tableView.frame.maxY + miniMargin * 2, width: screenWidth - miniMargin * 2, height: GECHomeViewModel.orderDeviveryViewHeight)

        infoView.customFrame = CGRect(x: miniMargin, y: deviveryView.frame.maxY + miniMargin * 2, width: screenWidth - miniMargin * 2, height: GECHomeViewModel.orderInfoViewHeight)

        baseScrollView.addSubview(deviveryView)
        baseScrollView.addSubview(infoView)
        // 更新scrollView 内容滑动区域
        var offsetY = infoView.frame.maxY
        if offsetY < screenHeight {
            offsetY = screenHeight
        }
        operationView.isHidden = true
        self.view.insertSubview(operationView, at: self.view.subviews.count - 1)
        operationHeight.constant = statusBarHeight > 20 ? 64 : 44
        operationView.layoutIfNeeded()
        baseScrollView.contentSize = CGSize(width: 0, height: offsetY)
    }

    //MARK: 赋值
    private func setData() {
        if searchOrderModel == nil {
            headerView.storeNameLabel.text = GECHomeViewModel.selectedRestaurantModel?.name
            if let url = GECHomeViewModel.selectedRestaurantModel?.logo?.url {
                headerView.storeImageView.setImageWithUrl(url)
            }
            updateData(model: GECHomeViewModel.currentOrderModel)
        }else {
            guard let guid = searchOrderModel?.guid, let storeId = searchOrderModel?.storeGuid else {return}
            headerView.storeNameLabel.text = searchOrderModel?.no
            GECProfileViewModel.getOrderDetail(orderId: guid, storeId: storeId) {[weak self] (errCode) in
                if let err = errCode {
                    self?.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: err))
                    return
                }

                if (self?.searchOrderModel?.status ?? 0 ) < 4 {
                    self?.operationView.isHidden = checkTime(originTimeStr: GECProfileViewModel.orderDetailModel?.createTime ?? "", maxTime: 60 * 60 * 24)
                }

                self?.updateData(model: GECProfileViewModel.orderDetailModel)
                self?.tableView.reloadData()
            }
        }

    }

    @IBAction func confirmOrderButtonAction(_ sender: UIButton) {
        GECHomeViewModel.changeOrderStatus(guid: searchOrderModel?.guid ?? "") {
            NotificationCenter.default.post(name: NotificationNames.updateOrderList, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }

    //MARK: 更新
    private func updateData(model: GECTakeAwayOrderModel?) {
        footerView.orderModel = model
        infoView.orderModel = model
        deviveryView.orderModel = model
    }
}

extension GECDetailOrderController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchOrderModel == nil {
            return GECHomeViewModel.cartDishesList.count
        }else {
            return GECProfileViewModel.orderDetailModel?.items?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GECOrderDishesCell", for: indexPath) as! GECOrderDishesCell
        if searchOrderModel == nil {
            cell.dishModel = GECHomeViewModel.cartDishesList[indexPath.row]
        }else {
            if let model = GECProfileViewModel.orderDetailModel?.items?[indexPath.row] {
                cell.orderDishModel = model
            }
        }
        return cell
    }
}
