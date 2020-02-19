//
//  GECGestionDirectController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/12.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
import CoreLocation
class GECGestionDirectController: UIViewController {

    //MARK: -
    //MARK: Vars.
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationTagLabel: UILabel!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var zipPostTextField: UITextField!
    @IBOutlet weak var streetNumberTextField: UITextField!
    @IBOutlet weak var doorNumberTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var defaultSwitch: UISwitch!
    @IBOutlet weak var phoneTextFiled: UITextField!
    @IBOutlet weak var contactNameTextField: UITextField!

    @IBOutlet weak var saveDirectionButton: UIButton!



    @IBOutlet weak var defaultLabelPls: UILabel!
    @IBOutlet weak var receiveAddressPls: UILabel!
    @IBOutlet weak var streetPls: UILabel!
    @IBOutlet weak var zipPostPls: UILabel!
    @IBOutlet weak var streetNumberPls: UILabel!
    @IBOutlet weak var doorNumberPls: UILabel!
    @IBOutlet weak var cityNamePls: UILabel!
    @IBOutlet weak var provincePls: UILabel!
    @IBOutlet weak var countryPls: UILabel!
    @IBOutlet weak var defaultAddressPls: UILabel!
    @IBOutlet weak var phonePls: UILabel!
    @IBOutlet weak var contactNamePls: UILabel!

    var addressModel: GECAddressModel?

    //MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setData()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }

    //MARK: setup
    private func setup() {

        self.title = GECProfileViewModel.isNewDirection
            ? "添加地址".getLocaLized
            : "编辑地址".getLocaLized
        self.locationTagLabel.text = GECProfileViewModel.isNewDirection
            ? "定位当前位置".getLocaLized
            : "收货地址".getLocaLized
        self.locationButton.setTitle("点击定位".getLocaLized, for: .normal)

        receiveAddressPls.text = "当前位置".getLocaLized
        streetPls.text = "街道".getLocaLized
        zipPostPls.text = "邮编".getLocaLized
        streetNumberPls.text = "街道号".getLocaLized
        doorNumberPls.text = "门牌号".getLocaLized
        cityNamePls.text = "城市".getLocaLized
        provincePls.text = "省份".getLocaLized
        countryPls.text = "国家".getLocaLized
        phonePls.text = "电话".getLocaLized
        contactNamePls.text = "联系人".getLocaLized
        saveDirectionButton.setTitle("保存地址".getLocaLized, for: .normal)
        defaultLabelPls.text = "默认地址".getLocaLized
        self.defaultSwitch.addTarget(self, action: #selector(changeDefaultAddressValue), for: .valueChanged)
    }

    //MARK: 赋值
    private func setData() {
        if let model = addressModel {
            locationButton.isSelected = true
            streetTextField.text = model.address1
            zipPostTextField.text = model.zipcode
            streetNumberTextField.text = model.address2 // 暂定街道号码
            doorNumberTextField.text = model.address3 // 暂定门牌号码
            cityTextField.text = model.city
            provinceTextField.text = model.province
            countryTextField.text = model.country
            defaultSwitch.setOn((model.defaultAddress ?? 0) == 1, animated: true)
            phoneTextFiled.text = model.phone
            contactNameTextField.text = model.contact
        }
    }

    //MARK: 抽取 - 设置placeholder
    private func setTextField(textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
    }

    //MARK: - Actions
    //MARK:  定位 begin to get current ubication
    @IBAction func beginLocationAction(_ sender: UIButton) {
        self.startAnimating(CGSize(width: 25, height: 25), message: "正在获取当前位置".getLocaLized, messageFont: UIFont.systemFont(ofSize: 13), type: .ballScaleMultiple, color: UIColor.themaSelectColor, textColor: UIColor.themaSelectColor)
        GECProfileViewModel.getLocationInfos {[weak self] (isSuccess) in
            self?.stopAnimating()
            if isSuccess == true, let addressInfo = GECProfileViewModel.directionInfo {
                if self?.addressModel == nil {addressInfo.defaultAddress = 1}
                self?.addressModel = addressInfo
                self?.setData()
            }else {
                self?.showErrorWithMessage("无法定位,请查看定位许可".getLocaLized)
            }
        }
    }

    //MARK: 保存更新地址信息
    @IBAction func saveAndUpdateDirectionInfos(_ sender: UIButton) {
        updateAddressModelWhenToSaveAddress()
        guard let model = addressModel else {return}
        GECProfileViewModel.checkDirectionInfo(addressModel: model) { [weak self](isSuccess: Bool) in
            if isSuccess {
                self?.saveAddressRequest()
            }else { self?.showErrorWithMessage("缺少地址信息, 请检查".getLocaLized)}
        }
    }

    //MARK: 切换是否默认地址选项
   @objc func changeDefaultAddressValue() {
       self.defaultSwitch.isOn = !self.defaultSwitch.isOn
    }

    //MARK: 更新地址
    private func updateAddressModelWhenToSaveAddress() {
        if addressModel == nil {addressModel = GECAddressModel(id: nil, guid: nil, country: nil, province: nil, city: nil, address1: nil, address2: nil, address3: nil, phone: nil, createTime: nil, customerGuid: nil, longitude: "0.00", latitude: "0.00", contact: nil, defaultAddress: nil, zipcode: nil)}
        addressModel?.address1 = streetTextField.text
        addressModel?.phone = phoneTextFiled.text
        addressModel?.zipcode = zipPostTextField.text
        addressModel?.address2 = streetNumberTextField.text
        addressModel?.address3 = doorNumberTextField.text
        addressModel?.city = cityTextField.text
        addressModel?.province = provinceTextField.text
        addressModel?.country = countryTextField.text
        addressModel?.defaultAddress = defaultSwitch.isOn == true ? 1 : 0
        addressModel?.contact = contactNameTextField.text
    }
}

// MARK: - 网络请求
extension GECGestionDirectController {
    private func saveAddressRequest() {
        guard let model = addressModel else {return}
        GECProfileViewModel.saveAddressRequest(addressModel: model) {[weak self] (errCode) in
            if errCode != nil {
                self?.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: errCode!))
                return
            }
            self?.doSometingAlfterCreateOEditAddressRequest()
        }
    }

    private func doSometingAlfterCreateOEditAddressRequest() {
        NotificationCenter.default.post(name: NotificationNames.updateAddress, object: nil)
        self.showNormalAlert("", contentMessage: "地址保存成功".getLocaLized, acepted: {
            self.navigationController?.popViewController(animated: true)
        }, canceled: nil)
    }
}

// MARK: - UITextFieldDelegate
extension GECGestionDirectController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case streetTextField:
            zipPostTextField.becomeFirstResponder()
        case zipPostTextField:
            streetNumberTextField.becomeFirstResponder()
        case streetNumberTextField:
            doorNumberTextField.becomeFirstResponder()
        case doorNumberTextField:
            cityTextField.becomeFirstResponder()
        case cityTextField:
            provinceTextField.becomeFirstResponder()
        default:
            provinceTextField.resignFirstResponder()
        }
        return true
    }
}
