//
//  GECRestaurantController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/14.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
import AudioToolbox
import SocketIO

let restaurenteScale: CGFloat = 0.30
class GECRestaurantController: UIViewController,UINavigationControllerDelegate, GECTakeInCartSocketDelegate {

    //MARK: -
    //MARK: Vals.

    @IBOutlet weak var takeOutOperationView: UIView!
    @IBOutlet weak var takeInOperationView: UIView!
    @IBOutlet weak var oldOrderButton: UIButton!
    @IBOutlet weak var newFoodsBUtton: UIButton!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    private var searchBar: UISearchBar?
    private lazy var simpleInfoView: GECRestaurantSimpleView = {
        let infoView = GECRestaurantSimpleView.loadNib("GECRestaurantSimpleView")
        infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDetailInfo(tap:))))
        return infoView
    }()

    lazy var takeAwayHublabel: GECCommonHubView = {
        let label = GECCommonHubView(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "不支持外卖".getLocaLized
        label.isUserInteractionEnabled = true
        self.view.addSubview(label)
        return label
    }()

    //MARK: HUB NaviBar
    private lazy var hubView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: statusBarHeight + naviBarHeight))
        v.backgroundColor = UIColor.themaSelectColor
        return v
    }()

    // titleView
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: statusBarHeight, width: screenWidth, height: naviBarHeight))
        label.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        label.textColor = .white
        label.textAlignment = .center
        hubView.addSubview(label)
        return label
    }()

    // FlowLayout
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth, height: 105)
        layout.minimumLineSpacing = 0.0
        return layout
    }()

    // imageY and contentInsetTop
    let contentInsetTop = GECHomeViewModel.restaurantImageViewHeight + GECHomeViewModel.restaurantTitleHeight + GECHomeViewModel.infoViewHeight * 0.6 + commonMargin * 2

    // infoY
    let infoY = -(GECHomeViewModel.infoViewHeight + GECHomeViewModel.restaurantTitleHeight + commonMargin * 2)

    // topView To Hidden Height
    let topHiddenHeight = naviBarHeight + statusBarHeight

    // BaseImageView
    private lazy var baseImageView: UIImageView = {
        let y = -contentInsetTop
        let frame = CGRect(x: 0, y: y - commonMargin, width: collectionView.frame.width, height: screenHeight * restaurenteScale )
        let imv = UIImageView(frame: frame)
        imv.image = UIImage(named: "homebackgroungIcon")
        return imv
    }()

    // titleView
    private lazy var titleView: JS_TitleView = {
        var style = JS_PageStyle()
        style.titleFont = UIFont(name: "PingFangSC-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)
        style.titleNolmalColor = UIColor.themaLightGrayColor
        style.titleSelectedColor = UIColor.themaSelectColor
        style.titleHeight = GECHomeViewModel.restaurantTitleHeight
        style.isShowBottomLine = true
        style.isShowBottomShadow = true
        style.bottomLineHeight = 1
        style.isScrollEnable = true
        style.titleViewBackgroundColor = self.view.backgroundColor ?? UIColor.themaLightBackgroundColor
        let titleY = contentInsetTop - GECHomeViewModel.restaurantTitleHeight - commonMargin
        let title = JS_TitleView(frame: CGRect(x: 0, y: titleY, width: screenWidth, height: GECHomeViewModel.restaurantTitleHeight), titles: nil, style: style)
        title.delegate = self
        return title
    }()

    lazy var storeDiscountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        self.collectionView.addSubview(label)
        return label
    }()

    //MARK: -
    //MARK: IBOutlet
    //CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cartBadgeCountLabel: UILabel!
    @IBOutlet weak var cartTipLabel: UILabel!
    @IBOutlet weak var allCartPriceLabel: UILabel!
    @IBOutlet weak var readyToOrderButton: UIButton!
    @IBOutlet weak var bottomBaseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var cartBaseView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var oldDishesCountLabel: UILabel!
    @IBOutlet weak var newDishesCountLabel: UILabel!

    //MARK: 动画参数
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        return gradient
    }()
    fileprivate lazy var animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "locations")
        return animation
    }()


    //MARK: - 自定义变量 以及 模型数据
    private var currentIndex: Int = 0
    //    let manager = SocketManager(socketURL: URL(string: "\(baseUrl)\(GECApis.socketUrl)")!, config: [.log(true), .compress])
    var socketClient = CartSocketSingleton.shared
    
    //MARK: -
    //MARK: Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getAllCommoditiesByThisStore()
        getDiscountByThisStore()
        updateCartPrices()
        listeningNotificationObserver()
    }

    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set navigationBar Transcult
        let navigation = self.navigationController as? GECNavigationController
        navigation?.enableScreenEdgePanGestureRecognizer(false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        if socketClient.delegate is GECTakeInCartViewController{
            socketClient.delegate = self
            self.collectionView.reloadData()
        }
    }

    //View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tapCartBaseViewAction()
        //Set default navigationBar
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        let navigation = self.navigationController as? GECNavigationController
        navigation?.enableScreenEdgePanGestureRecognizer(true)
    }

    deinit {
        gradient.removeAllAnimations()
        socketClient.cartSocketDisconnect()
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: 是否Root退出 删除商品
    private func checkDeinit(completed: @escaping()->()) {
        if navigationController?.children.count == 1 {
        }
    }

    //MARK: 监听Notification
    private func listeningNotificationObserver() {
        NotificationCenter.default.addObserver(forName: NotificationNames.updateRestauranteDishes, object: nil, queue: nil) { (_) in
            self.collectionView.reloadData()
            self.updateCartPrices()
        }

        NotificationCenter.default.addObserver(forName: NotificationNames.updateTakeInRestaurant, object: nil, queue: nil) {[weak self] (_) in
            GECHomeViewModel.takeInCartModel = nil
            GECHomeViewModel.totalDishesInCart = 0
            self?.getAllCommoditiesByThisStore()
        }

        NotificationCenter.default.addObserver(forName: NotificationNames.checkRestaurantDishsList, object: nil, queue: nil) { (notification) in
            guard let model = notification.userInfo?["model"] as? GECRestaurantDishModel, let isAdd = notification.userInfo?["isAdd"] as? Bool else { return }
            if model.menuSelectedGarnishedList.count > 0 {
              self.checkCurrenDishesList(model: model, isAdd: isAdd)
            }
            self.collectionView.reloadData()
            self.updateCartPrices()
        }
    }

    //MARK: SETUP
    // setup
    private func setup() {
        // set
        tableView.tableFooterView = UIView()
        // let infoDivece = UIDevice.current.model
        let cartHeaderTitleView = UIView(frame: CGRect(x: 0, y: -44, width: screenWidth, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: cartHeaderTitleView.bounds.width, height: cartHeaderTitleView.bounds.height))
        titleLabel.text = "购物车".getLocaLized
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cartHeaderTitleView.addSubview(titleLabel)
        tableView.addSubview(cartHeaderTitleView)
        tableView.contentInset.top = 44

        //判断是否是堂食
        if checkTakeInOrder() {
            //socket
            socketClient.delegate = self
            socketClient.cartSocketConnect()
            oldOrderButton.setTitle("我的单子".getLocaLized, for: .normal)
            newFoodsBUtton.setTitle("查看新菜".getLocaLized, for: .normal)
            self.navigationItem.title = "MESA \(GECHomeViewModel.scanInfos?.tableNum ?? "0")"
        }else {
            self.cartTipLabel.text = "\("还差".getLocaLized)\(GECHomeViewModel.selectedRestaurantModel?.takeawayMinimumConsumption ?? 0)\("即可下单".getLocaLized)"
            // set bottomBar
            setBottmBar()

            // set cartBaseView Tap
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapCartBaseViewAction))
            cartBaseView.addGestureRecognizer(tap)
            tableView.register(UINib(nibName: "GECPreCartDishesCell", bundle: nil), forCellReuseIdentifier: "GECPreCartDishesCell")
            tableView.sectionHeaderHeight = normalTableHeaderHeight
            tableView.delegate = self
            tableView.dataSource = self
        }

        // add HUB
        collectionView.frame.size.width = screenWidth
        hubView.alpha = 0
        view.insertSubview(hubView, belowSubview: self.cartBaseView)

        // cancel AutoInset
        collectionView.contentInsetAdjustmentBehavior = .never
        // set CollectionView contentInset
        collectionView.contentInset = UIEdgeInsets(top:contentInsetTop , left: 0, bottom: 0, right: 0)
        // add BaseImageView
        collectionView.addSubview(baseImageView)
        // setInfoView Frame
        simpleInfoView.customFrame = CGRect(x: commonMargin, y: infoY, width: self.collectionView.frame.width -  2 * commonMargin, height: GECHomeViewModel.infoViewHeight)
        storeDiscountLabel.frame = CGRect(x: 0, y: simpleInfoView.frame.origin.y - 25, width: screenWidth, height: 25)

        // add InfoView
        collectionView.addSubview(simpleInfoView)
        // register Cell
        collectionView.register(UINib(nibName: "GECRestaurantDishesCell", bundle: nil), forCellWithReuseIdentifier: GECHomeViewModel.dishesCellIdentifier)
        // set Layout For Collection
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self

        // add TitleView
        view.insertSubview(titleView, belowSubview: self.cartBaseView)

        // add RightNaviItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sousuo2_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(searchDishesAction))
    }

    //MARK: 判断是否隐藏下单条
    private func checkTakeInOrder() -> Bool {
        if GECHomeViewModel.selectedRestaurantModel?.takeawayStatus == 0 {
            takeOutOperationView.isHidden = true
            takeInOperationView.isHidden = true
            bottomHeight.constant = 0
            return false
        }

        if GECHomeViewModel.isTakeIn {
            takeOutOperationView.isHidden = true
            takeInOperationView.isHidden = false
            simpleInfoView.takeInHubLabel.isHidden = false
            return true
        }else {
            takeOutOperationView.isHidden = false
            takeInOperationView.isHidden = true
            simpleInfoView.takeInHubLabel.isHidden = true
            return false
        }
    }

    //MARK: BottomBar 设置底部条
    private func setBottmBar() {
        cartBadgeCountLabel.layer.cornerRadius = cartBadgeCountLabel.frame.width / 2
        cartBadgeCountLabel.layer.backgroundColor = UIColor.orange.cgColor
        cartBadgeCountLabel.layer.shadowColor = UIColor.clear.cgColor
        cartBadgeCountLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        cartBadgeCountLabel.layer.shadowRadius = 0
        cartBadgeCountLabel.layer.shadowOpacity = 0
        cartBadgeCountLabel.layer.shadowPath = UIBezierPath(roundedRect: cartBadgeCountLabel.bounds, cornerRadius: 0).cgPath

        readyToOrderButton.setTitle("去下单".getLocaLized, for: .normal)
        readyToOrderButton.layer.cornerRadius = 5
        readyToOrderButton.layer.masksToBounds = true
    }

    //MARK:  设置数值参数
    private func setData() {
        if let model = GECHomeViewModel.selectedRestaurantModel {
            titleView.titles = GECHomeViewModel.categoryNames
            titleLabel.text = model.name
            simpleInfoView.restaurantStore = model
        }
        self.collectionView.reloadData()
        scrollViewDidScroll(collectionView)
    }

    //MARK: - ACTIONS
    //MARK: Prepaer Order 准备订单
    @IBAction func readyToOrderAction(_ sender: UIButton) {
        let vc = GECCartViewController()

        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK:  查看购物车
    @IBAction func showCartListAction(_ sender: UIButton) {
        guard GECHomeViewModel.cartDishesList.count > 0 else {return}
        setupCartTableView()
    }
    
    //MARK: 查看堂食购物车
    @IBAction func showTakeInCartListAction(_ sender: Any) {
        if GECHomeViewModel.takeInCartModel == nil { return }
        let takeInCartVC = GECTakeInCartViewController()
        self.navigationController?.pushViewController(takeInCartVC, animated: true)
        
    }

    //MARK: 查看之前的订单
    @IBAction func showTakeInOldDishesListAction(_ sender: Any) {
        if GECHomeViewModel.takeInOrderModel == nil { return }
        let takeInOrderVC = GECTakeInOrderViewController()
        self.navigationController?.pushViewController(takeInOrderVC, animated: true)
    }


    //MARK: 监听Socket 更新购物车

    func socketUpdateTakeInCartOperationView() {
        self.updateTakeInCartOperationView(nil)
    }
    
    //    private func socketClientEvent() {
    //        socketClient.on(clientEvent: .connect) {data, ack in
    //            print("socket connected")
    //        }
    //        socketClient.on("message_\(GECHomeViewModel.scanInfos?.tableNum ?? "")") { (data, act) in
    //            guard let dataStr = data.first as? String else { return }
    //            if dataStr.count > 0{
    //                GECHomeViewModel.generatorTakeInCartJson(dataStr, completed: { (errorCode) in
    //                    self.updateTakeInCartOperationView(errorCode)
    //                })
    //            }else {
    //                GECHomeViewModel.totalDishesInCart = 0
    //                GECHomeViewModel.takeInCartModel = nil
    //                self.updateTakeInCartOperationView(nil)
    //            }
    //
    //        }
    //        socketClient.connect()
    //    }


    //MARK: 生成自适应TableView展示CartList
    private func setupCartTableView() {
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.25) {
            self.cartBaseView.alpha = 0.3
            self.tableView.transform = CGAffineTransform(translationX: 0, y: -screenHeight * 0.5)
        }
    }

    @objc private func tapCartBaseViewAction() {
        UIView.animate(withDuration: 0.25) {
            self.cartBaseView.alpha = 0.0
            self.tableView.transform = .identity
        }
    }

    //MARK:  展示餐馆信息 Action
    @objc private func showDetailInfo(tap: UITapGestureRecognizer) {
        let detailRestaurantVC = GECRestaurantDetailController()
        detailRestaurantVC.restaurantModel = GECHomeViewModel.selectedRestaurantModel
        self.navigationController?.pushViewController(detailRestaurantVC, animated: true)
    }

    //MARK: 搜索菜品 | Search Dishes
    @objc private func searchDishesAction() {
        if GECHomeViewModel.isSearchItemSelected == false {
            searchBar = UISearchBar()

            searchBar?.returnKeyType = .search
            searchBar?.placeholder = "请输入菜名".getLocaLized
            searchBar?.delegate = self
            searchBar?.frame.size.height = 36
            searchBar?.alpha = 0.0
            self.navigationItem.titleView = searchBar
            var searchBarTextField: UITextField?
            if #available(iOS 13, *) {
                searchBarTextField = searchBar?.searchTextField
                searchBar?.searchTextField.background = nil
            }else {
                if let searchBarbackground = searchBar?.value(forKeyPath: SystemKeyPaths.searchBarBackgroundKey) as? UIView {
                    searchBarbackground.removeFromSuperview()
                }
                if let tempSearchTextField = searchBar?.value(forKeyPath: SystemKeyPaths.searchBarTextFieldKey) as? UITextField {
                    searchBarTextField = tempSearchTextField
                }
            }
            // searchBar TextField
            searchBarTextField?.font = UIFont.systemFont(ofSize: 14)
            searchBarTextField?.backgroundColor = .white
            searchBarTextField?.layer.cornerRadius = 18
            searchBarTextField?.layer.masksToBounds = true
            UIView.animate(withDuration: 0.5, animations: {
                self.searchBar?.alpha = 1.0
            }) { (_) in
                GECHomeViewModel.isSearchItemSelected = true
                self.searchBar?.becomeFirstResponder()
            }
            self.navigationItem.setRightBarButton(UIBarButtonItem(title: "取消".getLocaLized, style: .done, target: self, action: #selector(searchDishesAction)), animated: true)
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationItem.titleView?.alpha = 0.0
            }) { (_) in
                self.navigationItem.titleView?.removeFromSuperview()
                GECHomeViewModel.isSearchItemSelected = false
            }
            self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "sousuo2_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(searchDishesAction)), animated: true)
            reStoreDishesList()
        }
    }
}

// MARK: - 网络请求
extension GECRestaurantController {
    // MARK: 获取所有商品
    private func getAllCommoditiesByThisStore() {
        reStoreDishesList()
        guard let store = GECHomeViewModel.selectedRestaurantModel else {return}
        LottieAnimation.shared.startLottieAnimation("restaurantLoading")
        GECHomeViewModel.getAllCommodities(with: store.guid!) { [weak self](errorMsg) in
            LottieAnimation.shared.stopLottieAnimation()
            if GECHomeViewModel.isTakeIn {
                self?.getOldOrderItem()
                self?.getOldCartItemTakeIn()
            }
            if let error = errorMsg { // 如果有错误
                self?.showErrorWithMessage(error)
                return
            }
            GECHomeViewModel.getAllCategoryList {[weak self] in
                self?.setData()
            }
        }
    }

    private func getDiscountByThisStore() {
        guard let store = GECHomeViewModel.selectedRestaurantModel else {return}
        GECHomeViewModel.getDiscountByStoreId(id: store.guid ?? "") { [weak self] in
            guard let discountList = GECHomeViewModel.storeDiscountListModel else { return }
            var content = ""
            for (index,item) in discountList.enumerated() {
//                if ( index > 0 && index % 2 == 0) { content += "\r\n"}
                content += "Superio \(item.threshold ?? 0.00)€  - \(item.discount ?? 0.00)\(item.type == 1 ? "%": "€")"
                if index < discountList.count - 1 {
                    content += "\r\n"
                }
            }
            let height = content.getSizeWithFont(font: UIFont.systemFont(ofSize: 14, weight: .medium), maxSize: CGSize(width: screenWidth, height: self?.simpleInfoView.frame.origin.y ?? 0)).height
                self?.storeDiscountLabel.frame = CGRect(x: 0, y: (self?.simpleInfoView.frame.origin.y ?? 0) - height, width: screenWidth, height: height)
            self?.storeDiscountLabel.text = content
//            self?.startTextAnimation()
        }
    }

    //MARK: 折扣动画
    private func startTextAnimation(){
        gradient.frame = storeDiscountLabel.bounds
        gradient.colors = [UIColor(white: 1.0, alpha: 0.3).cgColor, UIColor.yellow.cgColor, UIColor(white: 1.0, alpha: 0.3).cgColor]
        gradient.startPoint = CGPoint(x:-0.3, y:0.5)
        gradient.endPoint = CGPoint(x:1 + 0.3, y:0.5)
        gradient.locations = [0, 0.15, 0.3]
        storeDiscountLabel.layer.mask = gradient
        animation.fromValue = [0, 0.15, 0.3]
        animation.toValue = [1 - 0.3, 1 - 0.15, 1.0];
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = true
        animation.duration = 5
        gradient.add(animation, forKey: "musicTitle")

//        isAnimation = true
    }

    // MARK: 获取旧菜单
    private func getOldOrderItem() {
        if !GECHomeViewModel.isTakeIn { return }
        GECHomeViewModel.getOldCartOrderItem { (errCode) in
            if !(errCode == nil) {//self.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: errCode!));
                return}
            self.updateTakeInOldOrderOperationView(order: GECHomeViewModel.takeInOrderModel)
        }
    }

    private func getOldCartItemTakeIn() {
        GECHomeViewModel.getTakeInCartItems {
            self.updateTakeInCartOperationView(nil)
        }
    }

    //MARK: 更新购物车价格
    private func updateCartPrices() {
        GECHomeViewModel.caculateCart {[weak self] (errorMsg) in
            if GECHomeViewModel.isTakeIn {
                self?.updateTakeInCartOperationView(errorMsg)
            }else {
                self?.updateTakeOutCartOperationView(errorMsg)
            }
            self?.view.isUserInteractionEnabled = true
        }
    }

    //MARK: 刷新堂食 购物车
    private func updateTakeInCartOperationView(_ errorMsg: Int?) {
        newDishesCountLabel.text = "( \(GECHomeViewModel.totalDishesInCart) )"
        self.collectionView.reloadData()
    }

    //MARK: 刷新堂食旧菜单
    private func updateTakeInOldOrderOperationView(order: GECTakeAwayOrderModel?) {
        self.oldDishesCountLabel.text = "( \(0) )"
        if let model = order {
            self.oldDishesCountLabel.text = "( \(model.totalsItemsCount))"
        }
    }

    //MARK: 刷新外卖 购物车
    private func updateTakeOutCartOperationView(_ erroMsg: Int?) {
        let total = GECHomeViewModel.cartPriceModel?.actuallyPaidAmount
            ?? "0.00"
        let miniumPrice = Double(GECHomeViewModel.selectedRestaurantModel?.takeawayMinimumConsumption ?? 0)
        let discount = GECHomeViewModel.cartPriceModel?.discountAmount ?? "0.00"

        if erroMsg != nil {
            if erroMsg! == ErrorCode.NON_PRODUCT {
                self.discountLabel.isHidden = true
                self.cartBadgeCountLabel.text = "0"
                self.cartBadgeCountLabel.isHidden = true
                self.cartTipLabel.text = "\("还差".getLocaLized)\(miniumPrice.roundTo2f())€\("即可下单".getLocaLized)"
                self.readyToOrderButton.isHidden = true
                self.allCartPriceLabel.text = ""
                return
            }else {
                self.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: erroMsg!))
            }
        }

        self.cartBadgeCountLabel.isHidden = false
        self.discountLabel.isHidden = !((Double(discount) ?? 0.00) > 0)
        self.cartBadgeCountLabel.text = "\(GECHomeViewModel.totalDishesInCart)"
        self.discountLabel.attributedText = "\(discount)".underLine()
        self.allCartPriceLabel.text = "\(total) €"
        if (Double(total) ?? 0.00) >= miniumPrice {
            self.cartTipLabel.text = ""
            self.readyToOrderButton.isHidden = false
        }else {
            self.cartTipLabel.text = "\("还差".getLocaLized)\((miniumPrice - (Double(total) ?? 0.00)).roundTo2f())\("即可下单".getLocaLized)"
            self.readyToOrderButton.isHidden = true
        }
    }
}


// MARK: - 预览购物操作 代理
extension GECRestaurantController: UICollectionViewDelegate {

    //MARK: 图片点击 进入详情页
    func dishesCellImageSelected(cell: GECRestaurantDishesCell) {
        if GECHomeViewModel.selectedRestaurantModel?.takeawayStatus == 0 { return }
        guard let indexPath = self.collectionView.indexPath(for: cell) else {return}

        guard let model = GECHomeViewModel.currentRestaurantDishesList?[currentIndex].commodites?[indexPath.row] else {return }
        let detailVc = GECDishesDetailController()
        detailVc.dishModel = model

        // 增减回调
        detailVc.detailDishViewAction = {(model, isPlus, canRemove) in
            if isPlus {
                self.addDishFunction(model: model, indexPath: indexPath)
            }else {
                self.subtractDishFunction(model: model, canDelete: canRemove)
            }
        }
        self.navigationController?.pushViewController(detailVc, animated: true)
    }

    //MARK: - 删减产品
    func resCellDishSubtractQuantity(cell: GECRestaurantDishesCell, model: GECRestaurantDishModel, canDelete: Bool) {
        if let indexPath = self.collectionView.indexPath(for: cell as GECRestaurantDishesCell) {
            if GECHomeViewModel.isTakeIn {
                GECHomeViewModel.addToCartWithTakeIn(model: model, isAdd: false)
            }else {
                playSystemSoundWithSubtract()
                subtractDishFunction(model: model, canDelete: canDelete)
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
    }

    // 添加方法抽取
    private func addDishFunction(model: GECRestaurantDishModel, indexPath: IndexPath?) {
        playSystemSoundWithPlus()
        GECHomeViewModel.addDishToCart(model: model)
        updateCartPrices()
        if let index = indexPath {
            UIView.performWithoutAnimation {
                self.collectionView.reloadItems(at: [index])
            }
        }
    }

    // 删减方法抽取
    private func subtractDishFunction(model: GECRestaurantDishModel, canDelete: Bool) {
        playSystemSoundWithSubtract()
        self.view.isUserInteractionEnabled = false
        if canDelete {
            GECHomeViewModel.removeDishFromCart(with: model)
        }else {
            GECHomeViewModel.subtractFromCart(with: model)
        }
        updateCartPrices()
    }

    // 预览购物车 与 主界面 同时刷新
    private func reloadCartAndMainView(cartCell: GECPreCartDishesCell?) {
        UIView.performWithoutAnimation {
            tableView.reloadData()
            collectionView.reloadData()
        }
    }

    //MARK: ScrollDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.self) {
            let titleY = contentInsetTop - GECHomeViewModel.restaurantTitleHeight - commonMargin
            let offsetY = contentInsetTop - (-scrollView.contentOffset.y)

            /* 计算透明度*/
            var delta = offsetY / (naviBarHeight + statusBarHeight)
            delta = CGFloat.maximum(delta, 0)
            if delta >= 1 {
                delta = 1
            }
            hubView.alpha = delta

            /* 计算 titleY */
            var newTitleY = titleY - offsetY
            if newTitleY <= hubView.frame.height {
                newTitleY = hubView.frame.height
            }
            titleView.frame.origin.y = newTitleY

            /* 向下拉 放大图片*/
            if offsetY < 0 {
                baseImageView.frame.origin.y = -contentInsetTop + offsetY - commonMargin
                var scale =  1 + (-(offsetY / GECHomeViewModel.restaurantImageViewHeight))
                if scale >= 1.5 { scale = 1.5}
                baseImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }
}

// MARK: - UISearchBarDelegate 搜索
extension GECRestaurantController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.count > 0 {
            searchBar.resignFirstResponder()
            LottieAnimation.shared.startLottieAnimation("restaurantLoading")
            GECHomeViewModel.searchDishesFromRestaurant(key: text) {
                LottieAnimation.shared.stopLottieAnimation()
                self.collectionView.reloadData()
            }
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }

    //重置 List
    private func reStoreDishesList() {
        searchBar?.resignFirstResponder()
        GECHomeViewModel.searchRestaurantDishes = nil
        self.collectionView.reloadData()
    }

    //MARK: 套餐选择
    private func showMenuSelectionViewController() {
        let menuSelectionViewController = GECRestaurantSelectionMenuViewController()
        self.navigationController?.pushViewController(menuSelectionViewController, animated: true)
    }
}


// MARK: - JS_TitleViewDelegate
extension GECRestaurantController: JS_TitleViewDelegate {
    func titleView(titleView: JS_TitleView, targetIndex: Int) {
        reStoreDishesList()
        currentIndex = targetIndex
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: true)
    }
}

// MARK: - UICollectionDelegate
//MARK: 添加商品
extension GECRestaurantController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if GECHomeViewModel.selectedRestaurantModel?.takeawayStatus == 0 { return }
        if let model = getCurrentModel(indexPath) {
            GECHomeViewModel.selectedDishModel = model
            if model.garnishes?.count ?? 0 > 0 {
                showMenuSelectionViewController()
                return
            }
            if model.attributes?.count ?? 0 > 0 {
                dishesCellImageSelected(cell: collectionView.cellForItem(at: indexPath) as! GECRestaurantDishesCell)
                return
            }
            if GECHomeViewModel.isTakeIn {
                playSystemSoundWithPlus()
                GECHomeViewModel.addToCartWithTakeIn(model: model, isAdd: true)
            }else {
                addDishFunction(model: model, indexPath: indexPath)
            }
        }
    }

    //MARK: 获取最新 Model
    private func getCurrentModel(_ indexPath: IndexPath) -> GECRestaurantDishModel? {
        if let searchs = GECHomeViewModel.searchRestaurantDishes, let dishes = searchs["搜索记录".getLocaLized] {
            return dishes[indexPath.row]
        }else {
            if let model = GECHomeViewModel.currentRestaurantDishesList?[currentIndex].commodites?[indexPath.row] {
                return model
            }
        }
        return nil
    }
}



// MARK: - UICollectionViewDataSource
extension GECRestaurantController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let searchs = GECHomeViewModel.searchRestaurantDishes, searchs.count > 0 {
            return searchs["搜索记录".getLocaLized]?.count ?? 0
        }
        if let dishesList = GECHomeViewModel.currentRestaurantDishesList, dishesList.count > 0 {
            return dishesList[currentIndex].commodites?.count ?? 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GECHomeViewModel.dishesCellIdentifier, for: indexPath) as! GECRestaurantDishesCell
        if let searchs = GECHomeViewModel.searchRestaurantDishes, searchs.count > 0 {
            if let model = searchs["搜索记录".getLocaLized]?[indexPath.row] {
                cell.dishModel = model
            }
        }else {
            if let model = GECHomeViewModel.currentRestaurantDishesList?[currentIndex].commodites?[indexPath.row] {
                cell.dishModel = model
            }
        }
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension GECRestaurantController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return GECHomeViewModel.cartDishesList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GECHomeViewModel.cartDishesList[section].menuSelectedGarnishedList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GECPreCartDishesCell", for: indexPath) as! GECPreCartDishesCell
        cell.dishModel = GECHomeViewModel.cartDishesList[indexPath.section]
//        cell.quantityLabel.text = "\(GECHomeViewModel.cartDishesList[indexPath.section].addedGarnishCount)"
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = GECPreCartDisheHeaderView.loadNib()
        header.dishModel = GECHomeViewModel.cartDishesList[section]
        header.tag = section
        header.delegate = self
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dishModel = GECHomeViewModel.cartDishesList[section]
        if dishModel.selectedAttributes.count > 0 {
            return 49
        }else {
            return 34
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension GECRestaurantController: PreCartDisheHeaderViewDelegate, DishesCellProtocol {
    // 预览购物车 删减产品
    func preCartCellDishSubtractQuantity(cell: GECPreCartDishesCell, model: GECRestaurantDishModel, canDelete: Bool) {
        if let _ = model.menuSelectedGarnishedList.first {
            if canDelete == true {
                GECHomeViewModel.cartDishesList.remove(at: GECHomeViewModel.cartDishesList.index(of: model) ?? 0)
            }else {
                model.addedGarnishCount -= 1
            }
            checkCurrenDishesList(model: model, isAdd: false)
            updateCartPrices()
            reloadCartAndMainView(cartCell: nil)
        }
    }

    // 预览购物车 添加产品
    func cellDishAugmentQuantity(cell: GECPreCartDishesCell, model: GECRestaurantDishModel) {
        if let _ = model.menuSelectedGarnishedList.first {
            model.addedGarnishCount += 1
            checkCurrenDishesList(model: model, isAdd: true)
            updateCartPrices()
            reloadCartAndMainView(cartCell: nil)
        }
    }

    func preCartDisheHeaderViewAddButtonAction(dishModel: GECRestaurantDishModel, headerView: GECPreCartDisheHeaderView) {
        addDishFunction(model: dishModel, indexPath: nil)
        reloadCartAndMainView(cartCell: nil)
    }

    func preCartDisheHeaderViewSubtractButtonAction(dishModel: GECRestaurantDishModel, headerView: GECPreCartDisheHeaderView, canDelete: Bool) {
        subtractDishFunction(model: dishModel, canDelete: canDelete)
        reloadCartAndMainView(cartCell: nil)
        if canDelete {
            if GECHomeViewModel.cartDishesList.count == 0 {
                self.tapCartBaseViewAction()
                return
            }
        }
    }

    private func checkCurrenDishesList(model: GECRestaurantDishModel, isAdd: Bool) {
        if let dishesList = GECHomeViewModel.currentRestaurantDishesList?[currentIndex].commodites {
            for dish in dishesList {
                if (dish.guid ?? dish.commodity_guid ?? dish.guid ?? "").elementsEqual(model.guid ?? model.commodity_guid ?? "") {
                    dish.quantity += isAdd == true ? 1 : -1
                    if dish.quantity <= 0 {dish.quantity = 0}
                    break
                }
            }
        }
    }
}
