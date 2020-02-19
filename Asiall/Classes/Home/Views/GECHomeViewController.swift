//
//  GECHomeViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/10.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
let homeCollectionScale: CGFloat = 0.29
let homeImageScale: CGFloat = 0.44
let titleLabelHeight: CGFloat = 30
class GECHomeViewController: UIViewController {

    //MARK: -
    //MARK: Vars.
    /// CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeHubView: UIView!
    @IBOutlet weak var introduceImageView: UIImageView!
    @IBOutlet weak var addNewRestaurentButton: UIButton!
    @IBOutlet weak var hubLabel: UILabel!
    /// SearchBar
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var orderAlertView: UILabel!
    
    @IBOutlet weak var orderAlertViewHeightConstraint: NSLayoutConstraint!
    
    /// 选中Cell
    private var highlightIndexPath: IndexPath?
    private var refreshSender: UIRefreshControl?

    // Title Label
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "您关注的餐馆".getLocaLized
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    /// FlowLayout
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let itemW = screenWidth * 0.9
        let itemH: CGFloat = screenHeight * 0.6
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.minimumInteritemSpacing = commonMargin * 2
        layout.minimumLineSpacing = commonMargin * 2
        layout.sectionInset = UIEdgeInsets(top:titleLabelHeight + commonMargin * 2, left: 0, bottom: 0, right: 0)
        return layout
    }()

    //MARK: -
    //MARK: Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
//        getRestaurantDatas
        beginRefresh()
        updateFromNotification()
    }

    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set navigationBar Transcult
        self.navigationController?.navigationBar
            .setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        guard let _ = GECUserInfoModel.getUserInfoModel() else {
//            beginRefresh()
//            return
//        }

    }

    //View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        GECHomeViewModel.currentRestaurantDishesList = nil
        //Set default navigationBar
        self.navigationController?.navigationBar
            .setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    //View DidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !GECHomeViewModel.isLoadingSearchBar {
            setSearchBar()
        }
    }

    //MARK: 搜索所有商家
    @IBAction func addRestaurentButtonAction(_ sender: UIButton) {
       showSearchBarController()
//        beginToSearchRestaurent(key: nil)
    }
    //MARK: 监听通知更新
    private func updateFromNotification() {
        NotificationCenter.default.addObserver(forName: NotificationNames.updateFollowRestaurant, object: nil, queue: nil) { (_) in
//            if (GECProfileViewModel.userInfoModel != nil) {
                self.beginRefresh()
//            }
        }
    }

    //MARK: - 开始读取数据
    private func getRestaurantDatas(completed: @escaping ()->()) {
        GECHomeViewModel.getRestaurentListRequest { (list) in
            completed()
            guard list != nil, list!.data != nil , list!.data!.count > 0 else { self.titleLabel.text = "您暂未关注任何商家".getLocaLized; return }
            self.titleLabel.text = "您关注的餐馆".getLocaLized;
            self.collectionView.reloadData()
        }
    }

    //MARK: 获取订单信息
    private func getOrderDatas() {
        GECProfileViewModel.getOrderList(nil) {[weak self] (errCode) in
            if errCode == nil {
                self?.setAlertView()
            }else {
                self?.orderAlertView.alpha = 0.0
                self?.orderAlertViewHeightConstraint.constant = 0
            }
        }
    }

    //MARK: 订单提示View 点击
    @objc private func alertViewCLickedAction() {
        let orderViewController = GECProfileOrderController()
        self.navigationController?.pushViewController(orderViewController, animated: true)
    }

    //MARK: 判断是否有订单
    private func setAlertView() {
        if GECProfileViewModel.currentOrderList.count > 0 {
            UIView.animate(withDuration: 0.25) {
                self.orderAlertViewHeightConstraint.constant = normalButtonHeight
                self.orderAlertView.alpha = 0.9
                self.collectionView.contentInset.top = normalButtonHeight
            }
        }else {
            UIView.animate(withDuration: 0.25, animations: {
                self.orderAlertView.alpha = 0.0
                self.orderAlertViewHeightConstraint.constant = 0
                self.collectionView.contentInset.top = 0
            }) { (_) in
                
            }
        }
    }
    //MARK: - 初始化
    /// Setup UI
    private func setup() {
        // initial collection and BaseViews
        hubLabel.text = "暂无任何商家, 请通过🔍, 或者扫码来收藏商家".getLocaLized
        addNewRestaurentButton.setTitle("添加商家".getLocaLized, for: .normal)
        addNewRestaurentButton.layer.cornerRadius = 8
        addNewRestaurentButton.layer.masksToBounds = true

        self.navigationItem.title = ""
        searchBar.placeholder = "  " + "搜索餐馆".getLocaLized
        searchBar.delegate = self

        orderAlertView.layer.cornerRadius = 10
        orderAlertView.layer.masksToBounds = true
        orderAlertViewHeightConstraint.constant = 0
        orderAlertView.text = "你有新订单,不要忘记哦".getLocaLized
        orderAlertView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(alertViewCLickedAction)))

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.register(UINib(nibName: "GECRestaurantCell", bundle: nil), forCellWithReuseIdentifier: GECHomeViewModel.restauRantCellIdentifier)

        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            let title = "下拉刷新".getLocaLized
            refreshControl.attributedTitle = NSAttributedString(string: title)
            refreshControl.addTarget(self,
                                     action: #selector(beginRefresh),
                                     for: .valueChanged)
            collectionView.refreshControl = refreshControl
            self.refreshSender = refreshControl
        }

        collectionView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: commonMargin * 0.5)
            ])
        /// 添加通知
        addNotificationObserver()

    }

    @objc
    private func beginRefresh() {
        let manager = NetworkReachabilityManager()
        manager?.listener = { status in
            if status == .notReachable { // 无网络
                self.hubLabel.text = "请求错误".getLocaLized
            }
        }
        getRestaurantDatas {
            self.checkRestaurantFormNull()
            self.getOrderDatas()
            self.refreshSender?.endRefreshing()
        }
    }

    //MARK: 添加扫描通知监听
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showTakeInRestaurante(notification:)), name: NotificationNames.showTakeInRestaurant, object: nil)
    }

    @objc //MARK: 展示堂食餐馆
    private func showTakeInRestaurante(notification: Notification) {
        guard let infos = notification.userInfo as? [String: String] else {return}
        GECHomeViewModel.checkScanInfos(info: infos["link"] ?? "") {[weak self] (errCode, guid) in
            if errCode != nil {
                self?.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: errCode!))
                return
            }else if (errCode == nil && guid == nil) {
                let takeInWebViewController = GECTakeInWebViewController()
                takeInWebViewController.hidesBottomBarWhenPushed = true
                takeInWebViewController.link = infos["link"] ?? ""

               let navi = GECNavigationController(rootViewController: takeInWebViewController)
                UIApplication.shared.keyWindow?.rootViewController?.present(navi, animated: true, completion: nil)
//                self?.navigationController?.pushViewController(takeInWebViewController, animated: true)
//                takeInWebViewController.hidesBottomBarWhenPushed = false
            }else {
                pushToDetailRestaurant(guid: guid!)
            }
        }
    }

    //MARK: push TakeIn 餐馆
    private func pushToDetailRestaurant(guid: String) {
//        guard let infos = GECHomeViewModel.scanInfos else { return }
        GECHomeViewModel.getStoreDetailInfo(guid) {[weak self] (errorCode) in
            if !(errorCode == nil) {
                self?.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: errorCode!))
                return
            }
            let restaurantVC = GECRestaurantDetailController()
            restaurantVC.restaurantModel = GECHomeViewModel.currentStoreInfo
//            restaurantVC.hidesBottomBarWhenPushed = true
            let navi = GECNavigationController(rootViewController: restaurantVC)
            UIApplication.shared.keyWindow?.rootViewController?.present(navi, animated: true, completion: {
                restaurantVC.dissmissButton.isHidden = false
            })
//            self?.navigationController?.pushViewController(restaurantVC, animated: true)
        }
    }

    

    //MARK: 是否无商家
    private func checkRestaurantFormNull() {
        if let list = GECHomeViewModel.followListModel?.data, list.count > 0 {
            placeHubView.isHidden = true
        }else {
            placeHubView.isHidden = false
        }
        collectionView.reloadData()
    }

    // play video // 播放视频
    @IBAction func playVideo(_ sender: UIButton) {
        let url = URL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")
        //        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "aquaman.mp4", ofType: nil)!))
        let player = AVPlayer(url: url!)

        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = true
        self.parent?.present(playerController, animated: true, completion: {
            player.play()
        })
    }
    

}

// MARK: - UICollectionViewDataSource
extension GECHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GECHomeViewModel.followListModel?.data?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GECHomeViewModel.restauRantCellIdentifier, for: indexPath) as! GECRestaurantCell
        if let model = GECHomeViewModel.followListModel?.data?[indexPath.row] {
            cell.followRestaurantModel = model
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension GECHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = GECHomeViewModel.followListModel?.data?[indexPath.row], model.disabled == 1 {
            self.showNormalAlert("提示".getLocaLized, contentMessage: "Este restaurante ha cancelado el servicio, ¿dejar de seguir a ".getLocaLized + (model.name ?? "") + "?", cancelTitle: "暂时保留".getLocaLized, aceptTitle: "删除".getLocaLized, aceptColor: UIColor.red, acepted: {
                GECHomeViewModel.deleteFollowRestaurant(with: model.guid ?? "", completed: {[weak self] (_) in
                    self?.beginRefresh()
                })
            }, canceled: nil)
            return
        }
        let cell = collectionView.cellForItem(at: indexPath)
        highlightIndexPath = indexPath
        UIView.animate(withDuration: 0.25, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            let restaurantVc = GECRestaurantController()
            // 此处为外卖
            GECHomeViewModel.isTakeIn = false
            // 获取店信息
            GECHomeViewModel.selectedRestaurantModel = GECHomeViewModel.followListModel?.data?[indexPath.row]
            GECHomeViewModel.selectedRestaurantModel?.following = true
            restaurantVc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(restaurantVc, animated: true)
            cell?.transform = .identity
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        highlightIndexPath = indexPath
        UIView.animate(withDuration: 0.25) {
            print("缩小 frame")
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if highlightIndexPath == indexPath {
            UIView.animate(withDuration: 0.25) {
                print("恢复 frame")
                cell?.transform = .identity
                return
            }
        }
    }

}
// MARK: - Custom SearchBar
extension GECHomeViewController {
    // Custom SearchBar
    private func setSearchBar() {
        GECHomeViewModel.isLoadingSearchBar = true
        searchBar.tintColor = UIColor.themaNormalColor
        // searchBar backgroundView
//        var searchBarBackground: UIView!
        if #available(iOS 13, *) {
            searchBar.searchTextField.background = UIImage()
        } else {
            if let searchBarbackground = searchBar.value(forKeyPath: SystemKeyPaths.searchBarBackgroundKey) as? UIView {
                searchBarbackground.removeFromSuperview()
            }
        }

        var searchBarTextField: UITextField!
        // searchBar TextField
        if #available(iOS 13, *) {
            searchBarTextField = searchBar.searchTextField
        }else {
            if let tempSearchBar = searchBar.value(forKeyPath: SystemKeyPaths.searchBarTextFieldKey) as? UITextField {
                searchBarTextField = tempSearchBar
            }
        }
            searchBarTextField.layer.backgroundColor = UIColor.white.cgColor
            searchBarTextField.layer.borderColor = UIColor.themaSelectColor.cgColor
            searchBarTextField.layer.borderWidth = 0.5
            searchBarTextField.layer.cornerRadius = 18
            searchBarTextField.layer.masksToBounds = true

            // systemImageView
            if let searchImageView = searchBarTextField.subviews[1] as? UIImageView {
                // Add custom logo image
                let iconImage = UIImageView(image: UIImage(named: "logo2"))
                iconImage.frame = CGRect(x: searchImageView.frame.origin.x + 2, y: ( searchBarTextField.frame.height - searchLogoSize ) / 2, width: searchLogoSize, height: searchLogoSize)

                searchBarTextField.insertSubview(iconImage, at: 1)

                // Add custom searchIcon image
                let searchIcon = UIImageView(image: UIImage(named: "sousuo_icon"))
                searchIcon.frame = CGRect(x: iconImage.frame.maxX + commonMargin, y: searchImageView.frame.origin.y, width: searchImageView.frame.width, height: searchImageView.frame.height)
                searchBarTextField.insertSubview(searchIcon, at: 2)

                // set positionTextField
                searchImageView.isHidden = true
                searchBar.searchTextPositionAdjustment = UIOffset(horizontal: iconImage.frame.width + commonMargin, vertical: 0)
                // set textFieldContent
                let textFieldContent = searchBarTextField.subviews[4]
                textFieldContent.frame = CGRect(x: commonMargin, y: textFieldContent.frame.origin.y, width: textFieldContent.frame.width - iconImage.frame.width, height: textFieldContent.frame.height)
            }
        }
    }

// MARK: - UISearchBarDelegate
extension GECHomeViewController: UISearchBarDelegate {
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(false, animated: true)
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(false, animated: true)
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if let key = searchBar.text, key.count > 0 {
//            beginToSearchRestaurent(key: key)
//        }
//    }


    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showSearchBarController()
        return false
    }
    private func resignSearchBar() {
        self.searchBar.resignFirstResponder()
    }

//    private func beginToSearchRestaurent(key: String?) {
//        GECHomeViewModel.searchRestaurant(with: key, success: {
//            self.resignSearchBar()
//            let searchResultsVC = GECHomeSearchResultsViewController()
//            searchResultsVC.restaurantCollections = GECHomeViewModel.searchRestaurantList?.collection
//            searchResultsVC.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(searchResultsVC, animated: true)
//        }) { (msg) in
//            self.showErrorWithMessage(msg)
//        }
//    }

    private func showSearchBarController() {
        if GECUserInfoModel.getUserInfoModel() == nil {
            let loginVC = GECLoginViewController()
            loginVC.loginCallback = {[weak self] _ in
                self?.beginRefresh()
            }
            self.present(loginVC, animated: true, completion: nil)
        }
        let searchViewController = GECHomeSearchViewController()
        let navi = GECNavigationController(rootViewController: searchViewController)
        self.present(navi, animated: true) {
        }
    }
}
