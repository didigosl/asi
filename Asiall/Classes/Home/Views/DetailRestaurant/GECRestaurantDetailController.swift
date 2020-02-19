//
//  GECRestaurantDetailController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/16.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
import MapKit
class GECRestaurantDetailController: UIViewController {

    //MARK: - Vals.
    @IBOutlet weak var favoritButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var businessHoursLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var serversPls: UILabel!
    @IBOutlet weak var infoTitlePls: UILabel!
    @IBOutlet weak var directionPls: UILabel!
    @IBOutlet weak var hourPls: UILabel!
    @IBOutlet weak var contactPls: UILabel!
    @IBOutlet weak var collectionButton: UIButton!

    @IBOutlet weak var dissmissButton: UIButton!
    var restaurantModel: GECRestaurantsStoreModel?

    // 排列
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 90)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = miniMargin
        layout.sectionInset = UIEdgeInsets(top: 0, left: miniMargin, bottom: 0, right: miniMargin)
        return layout
    }()

    //MARK: -
    //MARK: Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setData()
        getDetailInfo()
    }

    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set navigationBar Transcult
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    //View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            //Set default navigationBar
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.shadowImage = nil
    }


    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: - 初始化
    ///setup
    private func setup() {
        logoImageView.layer.cornerRadius = logoImageView.frame.width * 0.5
        logoImageView.layer.masksToBounds = true

        favoritButton.layer.cornerRadius = 5
        favoritButton.layer.masksToBounds = true
        favoritButton.layer.borderWidth = 1
        favoritButton.layer.borderColor = UIColor.themaSelectColor.cgColor

        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.register(UINib(nibName: "GECRestaurantImageCell", bundle: nil), forCellWithReuseIdentifier: "GECRestaurantImageCell")
        collectionView.dataSource = self

        serversPls.text = "服务".getLocaLized
        infoTitlePls.text = "餐厅信息".getLocaLized
        directionPls.text = "餐厅地址".getLocaLized
        hourPls.text = "营业时间".getLocaLized
        contactPls.text = "联系电话".getLocaLized
        collectionButton.setTitle("关注".getLocaLized, for: .normal)
        collectionButton.setTitle("已关注".getLocaLized, for: .selected)

        /* 分享先隐藏
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(rightNaviItemToShareAction))
         */
    }

    //data
    private func setData() {
        guard let model = restaurantModel else {return}
        nameLabel.text = model.name
        directionLabel.text = "\(model.address?.address1 ?? "")"
        contactLabel.text = model.mobile
        changeFollowButtonStatus(status: model.following ?? false)
        if let url = model.logo?.url {
            logoImageView.setImageWithUrl(url)
        }
        if let morningTime = model.todayBusinessHours?.first, let afternoonTime = model.todayBusinessHours?.last {
            self.businessHoursLabel.text = "\("早上".getLocaLized) \(morningTime.startTime ?? "00:00") - \(morningTime.endTime ?? "00:00")  |  \("下午".getLocaLized) \(afternoonTime.startTime ?? "00:00") - \(afternoonTime.endTime ?? "00:00")"
        }
    }

    private func getDetailInfo() {
        guard let model = restaurantModel else {return}
        GECHomeViewModel.getStoreDetailInfo(model.guid ?? "") { (errorCode) in

        }
    }

    //MARK: 关注
    @IBAction func addToFavoritAction(_ sender: UIButton) {
        guard let _ = GECUserInfoModel.getUserInfoModel() else {
            self.present(GECLoginViewController(), animated: true, completion: nil)
            return
        }
        guard let model = restaurantModel, let guid = model.guid else {showErrorWithMessage("服务器错误".getLocaLized); return}

        if !(sender.isSelected) {
            GECHomeViewModel.followRestaturant(with: guid) { [weak self](error) in
                if error == nil {
                    self?.changeFollowButtonStatus(status: true)
                    self?.notificarToUpdateFollowRestaurant()
                    return
                }
                self?.showErrorWithMessage(error ?? "请求错误".getLocaLized)
            }
        }else {
            showNormalAlert("提示".getLocaLized, contentMessage: "已关注, 是否取消关注?".getLocaLized, acepted: {
                self.deleteFollowRestaurant()
            }, canceled: nil)
        }
    }


    //MARK: 取消
    private func deleteFollowRestaurant() {
        if self.favoritButton.isSelected == true {
            guard let model = restaurantModel, let guid = model.guid else {showErrorWithMessage("服务器错误".getLocaLized); return}
            GECHomeViewModel.deleteFollowRestaurant(with: guid) { [weak self] (error) in
                if error == nil {
                   self?.changeFollowButtonStatus(status: false)
                    self?.notificarToUpdateFollowRestaurant()
                    return
                }
                self?.showErrorWithMessage(error ?? "请求错误".getLocaLized)
            }
        }else {
            showNormalAlert("提示".getLocaLized, contentMessage: "无法取消关注".getLocaLized, acepted: {
                self.deleteFollowRestaurant()
            }, canceled: nil)
        }
    }

    //MARK: 更新按钮状态
    private func changeFollowButtonStatus(status: Bool) {
        self.favoritButton.isSelected = status
        self.restaurantModel?.following = status
        UIView.animate(withDuration: 0.25) {
            switch self.favoritButton.isSelected {
            case true:
                self.favoritButton.backgroundColor = .clear
                self.favoritButton.layer.borderColor = UIColor.themaBackgroundColor.cgColor
            default:
                self.favoritButton.backgroundColor = UIColor.themaSelectColor
                self.favoritButton.layer.borderColor = UIColor.themaSelectColor.cgColor
            }}
    }

    //MARK: 发送更新通知
    private func notificarToUpdateFollowRestaurant() {
        NotificationCenter.default.post(name: NotificationNames.updateFollowRestaurant, object: nil)
    }

    //MARK: - 开始准备导航
    @IBAction func showRutouerByCurrentLocation(_ sender: UIButton) {
        let alertVc = UIAlertController(title: "导航", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancelAction.setTextColor(textColor: .red)

        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) == true {
            let googleMap = UIAlertAction(title: "谷歌地图".getLocaLized, style: .default) { (_) in
                self.startToRouter(by: false)
            }
            alertVc.addAction(googleMap)
        }

        let systemMap = UIAlertAction(title: "苹果地图".getLocaLized, style: .default) { (_) in
            self.startToRouter(by: true)
        }

        alertVc.addAction(cancelAction)
        alertVc.addAction(systemMap)
        self.present(alertVc, animated: true, completion: nil)
    }


    //MARK: - 打开地图导航
    private func startToRouter(by isSystem: Bool) {
        let address = "\(restaurantModel?.address?.address1 ?? "")"
        LocationManager.sharedInstance.getReverseGeoCodedLocation(address: address, completionHandler: { (clLocation, clplaceMark, error) in
            let lat = clLocation?.coordinate.latitude ?? 0
            let log = clLocation?.coordinate.longitude ?? 0

            if isSystem {
                //获取目的的地标
                let destiItem = MKMapItem(placemark: MKPlacemark(placemark: clplaceMark!))
                let dic: [String : Any] = [
                    // 模型
                    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                    // 地图类型
                    MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue,
                    // 显示交通
                    MKLaunchOptionsShowsTrafficKey: true]

                //打开苹果自带地图的方法,这个open是类方法
                MKMapItem.openMaps(with: [destiItem], launchOptions: dic)
            }else {
                let urlStr = "comgooglemaps://maps.google.com/?q=\(lat),\(log)"
                UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: { (_) in

                })
            }//else
        }) // Location
    }

    @objc
    private func rightNaviItemToShareAction() {
        GECHomeViewModel.shareWithSystem(text: "G.Eat 点餐", and: UIImage(named: "logo3"), then: URL(string: "http://118.24.253.239/storeui/#/"))
    }
}

extension GECRestaurantDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GECRestaurantImageCell", for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }


}
