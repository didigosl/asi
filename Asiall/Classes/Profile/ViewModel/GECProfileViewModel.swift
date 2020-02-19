//
//  GECProfileViewModel.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/11.
//  Copyright © 2019 GoEat. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire
//MARK: - GECProfileViewModel
struct GECProfileViewModel {
    //Identifier
    static let profileSettingcellIdentifier = "profileSettingcellIdentifier"

    //Local Datas
    static let settingDatas = [[SettingCellKeys.imageName: "profileinfo_icon",
                                SettingCellKeys.settingTitle: "个人信息".getLocaLized, SettingCellKeys.tag: 10001],
                               [SettingCellKeys.imageName: "order_icon",
                                SettingCellKeys.settingTitle: "我的订单".getLocaLized, SettingCellKeys.tag: 10002],
//                               [SettingCellKeys.imageName: "credit_icon", SettingCellKeys.settingTitle: "我的银行卡".getLocaLized, SettingCellKeys.tag: 10003],
                               [SettingCellKeys.imageName: "address_icon", SettingCellKeys.settingTitle: "收货地址".getLocaLized, SettingCellKeys.tag: 10004],
//                               [SettingCellKeys.imageName: "aboutus_icon",
//                                SettingCellKeys.settingTitle: "关于我们".getLocaLized, SettingCellKeys.tag: 10005],
    ]






}

// MARK: - 用户信息 GECProfileInfoViewModel
extension GECProfileViewModel {
    // identifier
    static let infoCellIdentifier = "infoCellIdentifier"
    static var selectedInfoType: InfoKeys.InfoEnums = .userName
    // profileIcon
    static var iconImage: UIImage?
    //UserInfoModel
    static var userInfoModel: GECUserInfoModel?

    // info datas
    static let infoDatas = [[InfoKeys.title: "头像".getLocaLized,
                             InfoKeys.infoType: InfoKeys.InfoEnums.icon],
                            [InfoKeys.title: "用户名".getLocaLized,
                             InfoKeys.infoType: InfoKeys.InfoEnums.userName],
                            [InfoKeys.title: "邮箱地址".getLocaLized,
                             InfoKeys.infoType: InfoKeys.InfoEnums.email],
                            [InfoKeys.title: "修改密码".getLocaLized,
                             InfoKeys.infoType: InfoKeys.InfoEnums.password],
                            [InfoKeys.title: "手机号".getLocaLized,
                             InfoKeys.infoType: InfoKeys.InfoEnums.phoneNUmber]]
    //MARK: 获取用户信息
    static func getUserInfoWithToken(completed: @escaping ((_ userInfo: GECUserInfoModel?)->())){
        if let _ = GECUserInfoModel.getUserInfoModel() {
            completed(userInfoModel)
            return
        }
        NetWork.request(urlConnection: baseUrl + GECApis.customerInfo, method: .get, success: { (response: [String : Any]?) in
            if let isError = response?["isError"] as? Bool, isError == false, let data = response?["data"] as? [String: Any] {
                // 序列化Data
                if self.serializedJsonToModel(response: data) {
                    completed(userInfoModel)
                }else {
                    completed(nil) // 错误
                }
            } }) { (error: Error?) in
                completed(nil) //错误
        }
    }

    //MARK: 更新用户信息
    static func updateCustomerInfo(completed: @escaping (()->()), failed: @escaping ((_ error: String)->())) {
        guard let userInfo = userInfoModel else { return }
        let params = ["name": userInfo.name ?? "",
                      "phone": userInfo.phone ?? "",
                      "email": userInfo.email ?? "",
                      "headImage": userInfo.headImage ?? ""]
        NetWork.request(urlConnection: baseUrl + GECApis.updateInfo, method: .post, parameter: params, success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false, let data = response["data"] as? [String: Any] {
                if serializedJsonToModel(response: data) {
                    completed()
                }else {
                    failed("保存信息失败".getLocaLized)
                }
            }else {
                failed ("保存信息失败".getLocaLized)
            }
        }) { (error) in
            failed("保存信息失败".getLocaLized)
        }
    }

    //MARK: 公用UserInfoModel序列化 方法
    static private func serializedJsonToModel(response: [String: Any]?) -> Bool {
        if let data = response {
            do {
                // 序列化Data
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                self.setDefaultUserInfoModel(jsonData: jsonData)
                // decoder 模型
                userInfoModel = try newJSONDecoder().decode(GECUserInfoModel.self, from: jsonData)
                return true
            }catch {
                return false // 错误
            }
        }
        return false
    }

    // MARK: 上传用户头像
    static func uploadImageInfo(completed: @escaping ((_ error: String?)->())) {
        guard let image = iconImage, let imageData = image.jpegData(compressionQuality: 0.2) else {
            userInfoModel?.headImage = ""
            completed("图片无效,请重新选择".getLocaLized); return}
        NetWork.multiformRequest(urlConnection: baseUrl + GECApis.uploadUserImage, method: .post, files: [(name: "file", data: imageData, fileName: "icon.jpg")]) { (response, error) in
            if error != nil {
                userInfoModel?.headImage = ""
                completed("上传失败".getLocaLized)
            }
            if let data = response?["data"] as? [String: Any], let url = data["url"] as? String {
                userInfoModel?.headImage = url
                updateCustomerInfo(completed: {
                    completed(nil)
                }, failed: { (error) in
                    userInfoModel?.headImage = ""
                    completed(error)
                })
            }else {
                userInfoModel?.headImage = "";
                completed("上传失败".getLocaLized) }
        }
    }

    //MARK: - 修改密码
    static func changePassword(old: String, new: String, confirm: String, completed: @escaping ((_ error: String?) -> ())) {
        let parameter = ["oldPassword": old,
                         "newPassword1": new,
                         "newPassword2": confirm]
        NetWork.request(urlConnection: baseUrl + GECApis.changePassword, method: .post, parameter: parameter, success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false {
                completed(nil)
            }else {
                completed("无法修改密码".getLocaLized)
            }
        }) { (error) in
            completed("无法修改密码".getLocaLized)
        }
    }
}

// MARK: - GECProfileAddressViewModel
extension GECProfileViewModel {
    //DirectionInfos
    static var directionInfo: GECAddressModel?
    static var userAddressList: GECAddressModelList? 
    //Identifier
    static let addressCellIdentifier = "addressCellIdentifier"
    //isNewDirection
    static var isNewDirection = false

    // MARK: 获取当前位置 Get Current Location
    static func getLocationInfos(finished: @escaping ((_ isSuccess: Bool)->())) {
        /**
         * locality - City eg. Madrid
         * State - Provinc / SubAdministrativeArea - Province eg. Madrid
         * SubLocality - 区域(Moratalaz) eg. Moratalaz
         * Thoroughfare - Street eg. Calle del Camino Viejo de Leganés
         * ZIP - Zip Post eg. 28001
         * Name / Street eg. Calle del Camino Viejo de Leganés, 225
         * SubThoroughfare eg. 1
         */
        LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation {(clLocation: CLLocation?, clPlaceMark: CLPlacemark?, error: NSError?) in
            if error == nil {
                directionInfo = setLocationInfoData(with: clPlaceMark)
                finished(true)
            }else {
                print("获取失败")
                finished(false)
            }
        }
    }

    // MARK: 定位 Set DirectionInfo
    private static func setLocationInfoData(with clp: CLPlacemark?) -> GECAddressModel {
        return GECAddressModel.init(id: 0, guid: nil, country: clp?.country, province: clp?.administrativeArea, city: clp?.locality, address1: clp?.thoroughfare, address2: clp?.subThoroughfare, address3: nil, phone: nil, createTime: nil, customerGuid: nil, longitude: "\((clp?.location?.coordinate.longitude ?? 0.00))", latitude: "\((clp?.location?.coordinate.latitude ?? 0.00))", contact: nil, defaultAddress: 0, zipcode: clp?.postalCode)
    }

    //MARK: 是否有空值 Check Direction Info
    static func checkDirectionInfo(addressModel: GECAddressModel, finished: ((_ isSuccess: Bool)->())) {
        if let ads = addressModel.address1, let pho = addressModel.phone, let zip = addressModel.zipcode, let stn = addressModel.address2, let dn = addressModel.address3, let ct = addressModel.city, let pr = addressModel.province, let cn = addressModel.country, let _ = addressModel.defaultAddress, let ca = addressModel.contact, ads.count > 0, zip.count > 0, stn.count > 0, dn.count > 0, ct.count > 0, pr.count > 0, cn.count > 0, ca.count > 0, pho.count > 0 {
            finished(true)
        }else {
            finished(false)
        }
    }
    
    //MARK: 创建 和 更新 地址
    static func saveAddressRequest(addressModel: GECAddressModel, completed: @escaping((_ errorCode: Int?)->())) {
        var params: [String: Any] = [
            GECAddressModel.CodingKeys.contact.rawValue: addressModel.contact ?? "",
            GECAddressModel.CodingKeys.phone.rawValue: addressModel.phone ?? "",
            GECAddressModel.CodingKeys.province.rawValue: addressModel.province ?? "",
            GECAddressModel.CodingKeys.city.rawValue: addressModel.city ?? "",
            GECAddressModel.CodingKeys.country.rawValue: addressModel.country ?? "",
            GECAddressModel.CodingKeys.address1.rawValue: addressModel.address1 ?? "",
            GECAddressModel.CodingKeys.address2.rawValue: addressModel.address2 ?? "",
            GECAddressModel.CodingKeys.address3.rawValue: addressModel.address3 ?? "",
            GECAddressModel.CodingKeys.latitude.rawValue: Double(addressModel.latitude ?? "0.00") ?? 0,
            GECAddressModel.CodingKeys.longitude.rawValue: Double(addressModel.longitude ?? "0.00") ?? 0,
            GECAddressModel.CodingKeys.defaultAddress.rawValue: ( addressModel.defaultAddress ?? 0 ) == 1 ? true : false,
            GECAddressModel.CodingKeys.zipcode.rawValue: addressModel.zipcode ?? "0"
        ]
        var url = ""
        if addressModel.guid == nil {
            url = "\(baseUrl)\(GECApis.createAddress)"
        }else {
            params["guid"] = addressModel.guid ?? ""
            url = "\(baseUrl)\(GECApis.updateAddress)"
        }
        NetWork.request(urlConnection: url, method: .post, parameter: params, success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false {
                completed(nil)
            }else {
                completed(ErrorCode.CREATE_ADDRESS_ERROR)
            }
        }) { (_) in
            completed(ErrorCode.SERVER_ERROR)
        }
    }

    //MARK: 删除地址
    static func deleteAddressRequest(model: GECAddressModel, completed: @escaping(_ errCode: Int?)->()) {
        guard let guid = model.guid else { completed(ErrorCode.ERROR_ADDRESS_INFO); return }
        let url = "\(baseUrl)\(GECApis.deleteAddress)"
        NetWork.request(urlConnection: url, method: .post, parameter: ["guid": guid], success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false {
                completed(nil)
            }else { completed(ErrorCode.CANT_DELETE_ADDRESS)}
        }) { (_) in
            completed(ErrorCode.SERVER_ERROR)
        }
    }
}

// MARK: - GECProfileOrderViewModel
extension GECProfileViewModel {
    static var currentOrderList: [GECOrderModel] = []
    static var finishedOrderList: [GECOrderModel] = []
    static var canceledOrderList: [GECOrderModel] = []
    static var orderDetailModel: GECTakeAwayOrderModel?
    //order titles
    static let ordersTitles = ["进行中".getLocaLized, "已完成".getLocaLized, "已取消".getLocaLized]

    //MARK: 搜索订单
    static func getOrderList(_ status: Int?, completed: @escaping((_ errorCode: Int?)->())) {
        guard (GECUserInfoModel.getUserInfoModel() != nil) else {
            completed(ErrorCode.LOGIN_ERROR)
            return
        }
        let url = "\(baseUrl)\(GECApis.searchOrder)"
        var params = ["pageSize": 500]
        if let sts = status {
            params["status"] = sts
        }
        NetWork.request(urlConnection: url, method: .post, parameter: params, success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false, let data = response["data"] as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    let orderList = try newJSONDecoder().decode(GECSearchOrderList.self, from: jsonData)
                    checkOrders(orderList)
                    completed(nil)
                }catch {
                    clearOldOrderData()
                    completed(ErrorCode.SEARCH_ERROR)
                }
            }
        }) { (_) in
            clearOldOrderData()
            completed(ErrorCode.SERVER_ERROR)
        }
    }

    //分类 订单类型
    static func checkOrders(_ orderList: GECSearchOrderList) {
        clearOldOrderData()
        if let collections = orderList.collection {
            for item in collections {
                if let status = item.status {
                    if status == 0 || status == 1 || status == 2 || status == 3{
                        currentOrderList.append(item)
                    }
                    if status == 4 || status == 5 {
                        finishedOrderList.append(item)
                    }
                    if status == 6{
                        canceledOrderList.append(item)
                    }
                }
            }
        }
    }

    static private func clearOldOrderData() {
        currentOrderList.removeAll()
        finishedOrderList.removeAll()
        canceledOrderList.removeAll()
    }

    //MARK: 获取订单详情
    static func getOrderDetail(orderId: String, storeId: String, completed: @escaping((_ errCode: Int?)->())) {
        let url = "\(baseUrl)\(GECApis.orderDetail)?guid=\(orderId)&storeGuid=\(storeId)"
        NetWork.request(urlConnection: url, method: .get, success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false, let data = response["data"] as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    orderDetailModel = try newJSONDecoder().decode(GECTakeAwayOrderModel.self, from: jsonData)
                    completed(nil)
                }catch {
                    completed(ErrorCode.DETAIL_ORDER_ERROR)
                }
            }else {
                completed(ErrorCode.DETAIL_ORDER_ERROR)
            }
        }) { (_) in
            completed(ErrorCode.SEARCH_ERROR)
        }
    }
}

//MARK: - GECCurrentOrderViewModel
extension GECProfileViewModel {
    //identifier
    static let currentCellIdentifier = "currentCellIdentifier"
    
}

//MARK: - GECFinishedOrderViewModel
extension GECProfileViewModel {
    //identifier
    static let finishedCellIdentifier = "finishedCellIdentifier"

}

//MARK: - GECCanceledOrderViewModel
extension GECProfileViewModel {
    static let canceledCellIdentifier = "canceledCellIdentifier"
}

//MARK: - GECProfileCreditCardViewModel
extension GECProfileViewModel {
    static let creditCardCellIdentifeir = "creditCardCellIdentifeir"
    static let cardRowHeight: CGFloat = 115
    static var isCreditValid: Bool = false
    static var creditCardNumber: String?
    // cardNumber Format
    static func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        let arrOfCharacters = Array(trimmedString.suffix(trimmedString.count))
        var modifiedCreditCardString = ""

        if(arrOfCharacters.count > 0)
        {
            for i in 0...arrOfCharacters.count-1
            {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count)
                {
                    modifiedCreditCardString.append(" ")
                }
            }
        }; return modifiedCreditCardString
    }

    static func validateAddCardAction( name: String?, time: String?, cvv: String?, canAdd: ((_ can: Bool)->())) {
        if isCreditValid && creditCardNumber != nil{
            guard let name = name, let time = time, let cvv = cvv else {canAdd(false); return}
            guard name.count > 0, time.count == 5, cvv.count == 3 else {canAdd(false); return}
            canAdd(true)
        }else {
            canAdd(false)
        }
    }
}

// MARK: - 文案
extension GECProfileViewModel {

    static var docInfosModel: GECDoccumentInfoModel?

    //MARK: - 获取文案列表
    static func getDocumentInfosRequest(completed: @escaping (_ errCode: Int?)->()) {
        let url = "http://super.g-eat.es/manage/v1/article/all?page=1&categoryId=\(getCurrentLanguage() == 1 ? 1 : 2)"
        NetWork.request(urlConnection: url, method: .get, success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false, let data = response["data"] as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    docInfosModel = try newJSONDecoder().decode(GECDoccumentInfoModel.self, from: jsonData)
                    completed(nil)
                }catch {
                    completed(ErrorCode.DOC_INFO_ERROR)
                }
            }else {
                completed(ErrorCode.SERVER_ERROR)
            }
        }) { (error) in

        }
    }

}

//MARK: - 注册 登陆
extension GECProfileViewModel {

    /*Val. 属性*/
    static var loginModel: GECLoginModel?

    /// Register Request 注册请求
    ///
    /// - Parameters:
    ///   - parameters: 注册信息 Key: Value
    ///   - completed: 是否注册成功 Bool
    static func registerRequest(parameters: [String: Any], completed: @escaping ((Bool)->())) {

        NetWork.request(urlConnection: baseUrl + GECApis.register, method: .post, parameter: parameters, success: { (response: [String: Any]? ) in
            if let isError = response?["isError"] as? Bool, isError == false{
                completed(true)
            }else { completed(false) }
        }) { (error) in
            completed(false)
        }
    }

    /// Login Request 登陆请求
    ///
    /// - Parameters:
    ///   - parameters: 登陆信息 Key: Value
    ///   - completed: 是否登陆成功 Bool
    static func loginRequest(parameters: [String: Any], completed: @escaping ((Bool)->())) {
        NetWork.request(urlConnection: baseUrl + GECApis.login, method: .post, parameter: parameters, success: { (response: [String: Any]?) in
            if let isError = response?[errorKey] as? Bool, isError == false, let data = response?["data"] as? [String: Any] {
                do {
                    // 序列化Data
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    // decoder 模型
                    loginModel = try newJSONDecoder().decode(GECLoginModel.self, from: jsonData)
                    setDefaultLoginModel(jsonData: jsonData)
                    completed(true)
                }catch {
                    completed(false)
                }
            }else { completed(false) }
        }) { (error) in
            completed(false)
        }
    }

    //MARK: 公用LoginInfo本地存储
    static private func setDefaultLoginModel(jsonData: Data) {
        UserDefaults.standard.setValue(jsonData, forKey: DefaultsKeys.loginKey)
    }


    //MARK: 公用UserInfo本地存储
    static private func setDefaultUserInfoModel(jsonData: Data) {
        UserDefaults.standard.setValue(jsonData, forKey: DefaultsKeys.userInfoKey)
    }
}

//MARK: - Tag
enum SettingCellTag: Int {
    case INFO = 10001
    case ORDER = 10002
    case CREDIT = 10003
    case ADDRESS = 10004
    case ABOUT = 10005
}

//MARK: Validate Card
enum ValidateEnum {
    case visaCard(_: String)
    case masterCard(_: String)
    case emailAddress(_: String)
    var isRight: Bool {
        var predicateStr: String!
        var currentObject: String!
        switch self {
        case let .visaCard(str):
            predicateStr = "^4[0-9]{12}(?:[0-9]{3})?$"
            currentObject = str
        case let .masterCard(str):
            predicateStr = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
            currentObject = str
        case let .emailAddress(str):
            predicateStr = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            currentObject = str
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", predicateStr)
        return predicate.evaluate(with:currentObject)
    }
}

protocol GECProfileAddressCellDelegate {
    func addressCellDidSelectedEditAction(cell: GECAddressCell, model: GECAddressModel)
}
