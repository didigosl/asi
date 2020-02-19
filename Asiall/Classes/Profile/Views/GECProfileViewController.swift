//
//  GECProfileViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/11.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

let profileTopScale: CGFloat = 0.25
class GECProfileViewController: UIViewController {



    @IBOutlet weak var loginOutButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var profileIconBaseView: UIView!
    @IBOutlet weak var profileIconImageView: UIImageView!
    @IBOutlet weak var profileTopViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!


    //MARK: -
    //MARK: Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getUserInfo()

        // Do any additional setup after loading the view.
    }

    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set navigationBar Transcult
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        //更新perfil
        updateProfile(model: GECProfileViewModel.userInfoModel)
    }

    //View Will Disappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Set default navigationBar
        //        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        //        self.navigationController?.navigationBar.shadowImage = nil
    }

    //MARK: - setup
    private func setup() {
        //        profileTopViewHeightContraint.constant = screenHeight * profileTopScale
        profileIconBaseView.layer.cornerRadius = profileIconBaseView.frame.width / 2
        profileIconBaseView.layer.masksToBounds = true
        profileIconImageView.layer.cornerRadius = profileIconImageView.frame.width * 0.5
        profileIconImageView.layer.masksToBounds = true
        self.navigationItem.title = ""
        loginOutButton.isHidden = true
        loginOutButton.setTitle("退出登陆".getLocaLized, for: .normal)
        /// setup tableview
        tableView.register(UINib(nibName: "GECProfileSettingCell", bundle: nil), forCellReuseIdentifier: GECProfileViewModel.profileSettingcellIdentifier)
        tableView.rowHeight = screenHeight * 0.5 / CGFloat (GECProfileViewModel.settingDatas.count + 2) - commonMargin / 2
        tableView.backgroundColor = self.view.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func loginActionSelected(_ sender: Any) {
        if GECProfileViewModel.userInfoModel != nil {
            let vc = GECProfileInfoController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        if GECProfileViewModel.loginModel != nil , GECProfileViewModel.userInfoModel != nil{return}
        let loginVC = GECLoginViewController()
        self.present(loginVC, animated: true) {
            loginVC.loginCallback = {(completed: Bool) in
                if completed {
                    self.getUserInfo()
                }else {
                    self.showErrorWithMessage("登陆失败".getLocaLized)
                }/*else */}/*block*/}
    }

    //登出
    @IBAction func loginOutAction(_ sender: UIButton) {
        self.showNormalAlert("退出登陆".getLocaLized, contentMessage: "确定要退出登陆吗,将无法点餐哦".getLocaLized, acepted: { [weak self] in
            if GECLoginModel.getLoginModel() != nil {
                UserDefaults.standard.setValue(nil, forKey: DefaultsKeys.loginKey)
                UserDefaults.standard.setValue(nil, forKey: DefaultsKeys.userInfoKey)
                GECProfileViewModel.userInfoModel = nil
                GECProfileViewModel.loginModel = nil
                self?.updateProfile(model: nil)
                NotificationCenter.default.post(name: NotificationNames.updateFollowRestaurant, object: nil)
            }
            }, canceled: nil)
    }
    
    private func getUserInfo() {
        if GECProfileViewModel.loginModel == nil {
            guard let loginModel = GECLoginModel.getLoginModel() else {return}
            GECProfileViewModel.loginModel = loginModel
        }
        guard let _ = GECProfileViewModel.loginModel else {return}
        self.showLoadingAnimation()
        GECProfileViewModel.getUserInfoWithToken { [weak self](info: GECUserInfoModel?) in
            self?.stopAnimating()
            self?.updateProfile(model: info)
        }
    }

    private func updateProfile(model: GECUserInfoModel?) {
        if let model = model {
            loginButton.setTitle(model.name, for: .normal)
            profileIconImageView.setImageWithUrl(model.headImage ?? "")
            loginOutButton.isHidden = false
        }else {
            loginButton.setTitle("登陆".getLocaLized, for: .normal)
            profileIconImageView.setImageWithUrl("")
            loginOutButton.isHidden = true
        }
    }
}



// MARK: - UITableViewDelegate
extension GECProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) {
            if cell.tag != SettingCellTag.ABOUT.rawValue, GECProfileViewModel.loginModel == nil {
                self.showNormalAlert("提示".getLocaLized, contentMessage: "是否前往登录".getLocaLized, acepted: {
                    self.loginActionSelected(self.loginButton)
                }, canceled: nil)
            }
            switch cell.tag {
            case SettingCellTag.INFO.rawValue:
                let vc = GECProfileInfoController()
                self.navigationController?.pushViewController(vc, animated: true)
            case SettingCellTag.ORDER.rawValue:
                let vc = GECProfileOrderController()
                self.navigationController?.pushViewController(vc, animated: true)
            case SettingCellTag.CREDIT.rawValue:
                let vc = GECProfileCreditController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case SettingCellTag.ADDRESS.rawValue:
                let vc = GECProfileAddressController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case SettingCellTag.ABOUT.rawValue:
                let vc = GECProfileAboutUsController()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension GECProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GECProfileViewModel.settingDatas.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GECProfileViewModel.profileSettingcellIdentifier, for: indexPath) as! GECProfileSettingCell
        cell.selectionStyle = .none
        let settingData = GECProfileViewModel.settingDatas[indexPath.row]
        if let image = settingData[SettingCellKeys.imageName] as? String, let title = settingData[SettingCellKeys.settingTitle] as? String, let tag = settingData[SettingCellKeys.tag] as? Int {
            cell.settingIcon.image = UIImage(named: image)
            cell.settingTitle.text = title
            cell.tag = tag
        }
        return cell
    }

}
