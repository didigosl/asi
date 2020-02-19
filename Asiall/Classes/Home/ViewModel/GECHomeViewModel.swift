//
//  GECHomeViewModel.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/11.
//  Copyright © 2019 GoEat. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
struct GECHomeViewModel {
    static let restauRantCellIdentifier = "restauRantCellIdentifier"
    static var isLoadingSearchBar = false
    static var isTakeIn = false
}

// MARK: - GECRestaurantViewModel
extension GECHomeViewModel {
    //MARK: Vars...
    static var isSearchItemSelected: Bool = false
    static let infoViewHeight: CGFloat = 105
    static let restaurantImageViewHeight: CGFloat = 210
    static let restaurantTitleHeight: CGFloat = 35
    static let dishesCellIdentifier = "dishesCellIdentifier"
    static var categoryNames = [String]()
    static var searchRestaurantList: GECSearchRestaurantsModels?

    static var restauranteListModel: GECSearchRestaurantsModels?
    static var followListModel: GECRestaurantFollowListModel?
    static var selectedRestaurantModel: GECRestaurantsStoreModel?
    static var currentRestaurantDishesList: GECRestaurantDishesList?
    static var searchRestaurantDishes: [String: [GECRestaurantDishModel]]?
    static var storeDiscountListModel: GECStoreDiscountListModel?
    static var currentLocation: (placeMark: CLPlacemark, location: CLLocation)?
    //MARK: 菜品类型 分类
    static var businessModelList: GECRestaurantBusinessList?
    static var selectedBusinessModel: GECRestaurantBusinessModel?

    static var scanInfos: (storeId: String, tableGuid: String, tableNum: String)?
    static var takeInOrderModel: GECTakeAwayOrderModel? {
        didSet {
            splitOldOrderItems()
        }
    }
    static var takeInOrderItems: [String: [GECOrderItemModel]] = [:]
    static var takeInCartModel: GECTakeInDishesCartModel?
    static var selectedDishModel: GECRestaurantDishModel?


    //MARK: - functions
    static func getCurrentLocation( completion: @escaping ()->()) {
        LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation { (location: CLLocation?, placeMark: CLPlacemark?, error: NSError?) in
            if let loc = location , let pls = placeMark {
                currentLocation = (placeMark: pls, location: loc)
                LocationManager.sharedInstance.destroyLocationManager()
            }
            completion()
        }
    }

    //MARK: 获取关注商家列表
    static func getRestaurentListRequest(completed: @escaping ((_: GECRestaurantFollowListModel?)->())) {
        NetWork.request(urlConnection: baseUrl + GECApis.followRestaurant, method: .get, success: { (response) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                followListModel = try newJSONDecoder().decode(GECRestaurantFollowListModel.self, from: jsonData)
                completed(followListModel)
            }catch (_){
                completed(nil)
            }
        }) { (error: Error?) in
            completed(nil)
        }
    }

    //MARK: 获取 菜品 分类
    static func getRestaurantBusinessListRequest(completed: @escaping (_ isErr: Bool?)->()) {
        NetWork.request(urlConnection: baseUrl + GECApis.getMainBusiness, method: .get, success: { (response) in
            guard let data = response["data"] else {completed(true);return}
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                businessModelList = try newJSONDecoder().decode(GECRestaurantBusinessList.self, from: jsonData)
                setBusinessList()
                completed(false) } catch {
                    completed(true)
            }
        }) { (error) in
            completed(true)
        }
    }

    private static func setBusinessList() {
        let allBusinessModel = GECRestaurantBusinessModel(id: 0, guid: "", name: "全部".getLocaLized, status: 1, priority: 0, createdAt: "", updatedAt: "", statusText: "")
        allBusinessModel.isSelect = true
        selectedBusinessModel = allBusinessModel
        businessModelList?.insert(allBusinessModel, at: 0)
    }


    static func checkScanInfos(info: String, completed: (_ errorCode: Int?, _ guid: String?)->()){
        let infos = info.split(separator: "?")
        guard let storeUrl = infos.last?.description else {
            completed(ErrorCode.ERROR_QR_CODE, nil)
            return
        }

        let stores = storeUrl.split(separator: "&")
        if stores.count == 1 {
            let path = stores.last?.description ?? ""
            let newPath = path.replacingOccurrences(of: "storeGuid=", with: "")
            completed(nil, newPath)
        }else {
            completed(nil, nil)
        }
    }

    //MARK: 搜索商家 根据店名
    static func searchRestaurant(with name: String?, success: @escaping (()->()), failed: @escaping ((_ error: String)->())) {
        guard let userInfo = GECUserInfoModel.getUserInfoModel()?.guid else {failed("暂未登陆".getLocaLized); return}
        var requestUrl = "\(baseUrl)\(GECApis.searchRestaurant)?"
        if name != nil {
            requestUrl += "q=\(name!)&uid=\(userInfo)&pageSize=1000"
        }else {
            requestUrl += "uid=\(userInfo)&pageSize=1000"
        }
        NetWork.request(urlConnection: requestUrl, method: .get, success: { (response: [String : Any]?) in
            do {
                if let json = response {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    searchRestaurantList = try newJSONDecoder().decode(GECSearchRestaurantsModels.self, from: jsonData)
                    success()
                }}catch (_) {
                    failed("服务器错误".getLocaLized)
            }
        }) { (error) in
            failed("服务器错误".getLocaLized)
        }
    }

    //MARK: 搜索商家 根据业务分类
    static func searchRestaurant(with params: [String: String], success: @escaping (()->()), failed: @escaping ((_ error: String)->())) {
        var requestUrl = "\(baseUrl)\(GECApis.searchRestaurant)?"
        for (key,value) in params {
            requestUrl = "\(requestUrl)\(key)=\(value)&"
        }
        NetWork.request(urlConnection: requestUrl, method: .get, success: { (response: [String : Any]?) in
            do {
                if let json = response {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    restauranteListModel = try newJSONDecoder().decode(GECSearchRestaurantsModels.self, from: jsonData)
                    success()
                }}catch (_) {
                    failed("服务器错误".getLocaLized)
            }
        }) { (error) in
            failed("服务器错误".getLocaLized)
        }
    }


    // MARK: 获取商家商品
    static func getAllCommodities(with storeGuid: String, completed: @escaping ((_ errorMsg: String?)->())) {
        //        if let dishesList = selectedRestaurantModel?.dishesList {
        //             currentRestaurantDishesList = dishesList
        //            completed(nil)
        //            return
        //        }
        let url = baseUrl + "\(GECApis.getAllCommodity)?storeGuid=\(storeGuid)"
        NetWork.request(urlConnection: url, method: .get, success: { (response) in
            if let data = response["data"] as? [[String: Any]] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    let dishesList = try newJSONDecoder().decode(GECRestaurantDishesList.self, from: jsonData)
                    selectedRestaurantModel?.dishesList = dishesList
                    currentRestaurantDishesList = dishesList
                    completed(nil)
                }catch {
                    completed("服务器错误".getLocaLized)
                }
            }
        }) { (error) in
            completed("服务器错误".getLocaLized)
        }
    }

    //MARK: 获取商家折扣
    static func getDiscountByStoreId(id: String, completed: @escaping ()->()) {
        let url = "\(baseUrl)\(GECApis.getDiscountInfos)?storeGuid=\(id)"
        NetWork.request(urlConnection: url, method: .get, success: { (response) in
            if let data = response["data"] as? [[String: Any]]{
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                    storeDiscountListModel = try? newJSONDecoder().decode(GECStoreDiscountListModel.self, from: jsonData)
                }
            }
            completed()
        }) { (_) in
            completed()
        }
    }

    //MARK: - 搜索商家商品
    static func searchDishesFromRestaurant(key: String, completed: ()->()) {
        let mayusKey = key.uppercased()
        if let restaurentDishesList = currentRestaurantDishesList {
            var tempList: [String: [GECRestaurantDishModel]] = [:]
            var tempDishes: [GECRestaurantDishModel] = []
            for item in restaurentDishesList {
                if let dishes = item.commodites {
                    _ = dishes.map{ if (($0.name ?? "").uppercased()).contains(mayusKey) {
                        tempDishes.append($0)
                        }}
                }
            }
            tempList["搜索记录".getLocaLized] = tempDishes
            searchRestaurantDishes = tempList
            completed()
        }
    }

    //MARK: 获取takeIn 订单
    static func getOldCartOrderItem(completed: @escaping(_ errorCode: Int?)->()) {
        guard let infos = scanInfos else {return}
        NetWork.request(urlConnection: baseUrl + "\(GECApis.oldOrder)\(infos.tableGuid)", method: .get, parameter: nil, header: nil, success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false, let data = response["data"] as? [String: Any] {
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                    takeInOrderModel = try? newJSONDecoder().decode(GECTakeAwayOrderModel.self, from: jsonData)
                    completed(nil)
                }else {
                    completed(ErrorCode.ERROR_NULL_OLD_ORDER)
                }
            }else {
                completed(ErrorCode.ERROR_NULL_OLD_ORDER)
            }
        }) { (error) in
            completed(ErrorCode.SERVER_ERROR)
        }
    }



    //MARK: 拆分旧订单加菜顺序
    static func splitOldOrderItems() {
        takeInOrderItems.removeAll()
        guard let items = takeInOrderModel?.items else { return }
        for item in items {
            takeInOrderModel?.totalsItemsCount += item.quantity ?? 0
            guard let seq = item.seq else {continue}
            if var orderItems = takeInOrderItems["\(seq)"] {
                orderItems.append(item)
                takeInOrderItems["\(seq)"] = orderItems
            }else {
                var tempArr: [GECOrderItemModel] = []
                tempArr.append(item)
                takeInOrderItems["\(seq)"] = tempArr
            }
        }
    }

    //MARK: 堂食和Socket 数据解析
    static func generatorTakeInCartJson(_ jsonStr: String, completed: (_ errorMsg: Int?)->()) {
        if jsonSerializationTakeInCart(jsonStr: jsonStr) {
            completed(nil)
        }else {
            completed(ErrorCode.SERVER_ERROR)
        }
    }

    // MARK: 解析Json
    private static func jsonSerializationTakeInCart(jsonStr: String) -> Bool {
        guard let json = stringValueDic(jsonStr),
            let result = json["result"] as? [String: Any] else { return false}
        if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) {
            takeInCartModel = try? newJSONDecoder().decode(GECTakeInDishesCartModel.self, from: jsonData)
            totalDishesInCart = 0
            if let items = takeInCartModel?.items {
                for item in items {
                    totalDishesInCart += item.quantity ?? 0
                }
            }
            return true
        }else {
            return false
        }
    }

    // MARK: 字符串转字典
    static func stringValueDic(_ str: String) -> [String : Any]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }

    //MARK: 获取所有分类名
    static func getAllCategoryList(completed: (()->())){
        categoryNames.removeAll()
        if let list = currentRestaurantDishesList {
            for index in 0..<list.count {
                categoryNames.append(list[index].name ?? "未知名".getLocaLized)
            }
            if list.count == 0 {
                categoryNames.append("无商品")
            }
        }
        completed()
    }


    //MARK: 本地存储
    static func setDefaultWithKey(key: String, data: Data) {
        UserDefaults.standard.setValue(data, forKey: key)
    }

}

// MARK: - GECCartViewModel
extension GECHomeViewModel {
    static let cartDishCellIdentifier = "cartDishCellIdentifier"
    static let cartRowHeight: CGFloat = 70
    static let cartFooterHeight: CGFloat = 230
    static var cartDishesList: [GECRestaurantDishModel] = []
    static var dishesCount: Int = 1
    static var cartPriceModel: GECCartPriceModel?
    static var totalDishesInCart: Int = 0
    static var userAddressList: [GECAddressModel] = []
    static var defaultAddress: GECAddressModel?
    static var storePayMethodList: [GECStorePayMethodModel] = []
    static var defaultPayMethod: GECStorePayMethodModel?
    static var currentOrderModel: GECTakeAwayOrderModel?

    //MARK: 添加到购物车
    static func addDishToCart(model: GECRestaurantDishModel){
        var isNewDish: Bool = true
        for dishModel in cartDishesList {
            if dishModel.guid!.elementsEqual(model.guid!) {
                dishModel.quantity += 1
                isNewDish = false
            }
        }
        if isNewDish {
            model.quantity += 1
            cartDishesList.append(model)
        }
    }


    //MARK: - 堂食添加到购物车
    static func addToCartWithTakeIn(model: GECRestaurantDishModel? = nil, secondModel: GECOrderItemModel? = nil, isAdd: Bool) {

        if let tableGuid = scanInfos?.tableGuid {
            var parameter: [String: Any] = ["tableGuid": tableGuid]
            var jsonItems: [[String: Any]] = []
            var canAddNew: Bool = true
            let currentItem: [String : Any] = ["commodityGuid": (secondModel == nil ? (model?.guid ?? "") : (secondModel?.commodityGuid ?? "")), "quantity": 1]
            if  let items = takeInCartModel?.items, items.count > 0 {
                for item in items {
                    if (secondModel == nil ? (model?.guid ?? "") : (secondModel?.commodityGuid ?? "")).elementsEqual(item.commodityGuid ?? "x") {
                        canAddNew = false
                        if isAdd {
                            item.quantity! += 1
                        }else {
                            item.quantity! -= 1
                        }
                        if item.quantity! == 0 {
                            model?.quantity = 0
                            secondModel?.quantity = 0
                            continue
                        }
                    }
                    var temp: [String: Any] = [:]
                    temp["commodityGuid"] = item.commodityGuid ?? ""
                    temp["quantity"]  = item.quantity ?? 1
                    jsonItems.append(temp)
                }
            }

            if canAddNew {
                jsonItems.append(currentItem)
            }
            parameter["items"] = jsonItems
            NetWork.request(urlConnection: baseUrl + GECApis.takeInAddToCart, method: .post, parameter: parameter, header: nil, success: { (response) in

            }) { (error) in

            }
        }
    }

    //MARK: 获取堂食购物车
    static func getTakeInCartItems(completed: @escaping ()->()) {
        guard let tableGuid = scanInfos?.tableGuid else { return }
        NetWork.request(urlConnection: baseUrl + GECApis.takeInAddToCart + tableGuid  , method: .get, parameter: nil, header: nil, success: { (response) in
            if let result = response["data"] as? String {
                _ = jsonSerializationTakeInCart(jsonStr: result)
            }
            completed()
        }) { (error) in
            completed()
        }
    }

    //MARK: 堂食下单
    static func takeInOrder(_ completed: @escaping (_ isFinished: Bool)->()) {
        guard let cartModel = takeInCartModel, let tableGuid = scanInfos?.tableGuid, let items = cartModel.items else { completed(false); return}
        var jsonItems: [[String: Any]] = []
        for item in items {
            let temp: [String: Any] = ["commodityGuid": item.commodityGuid ?? "",
                                       "quantity": item.quantity ?? 1]
            jsonItems.append(temp)
        }
        let parameter: [String: Any] = ["items": jsonItems,
                                        "tableGuid": tableGuid,
        ]
        NetWork.request(urlConnection: baseUrl + GECApis.takeInOrder, method: .post, parameter: parameter, header: nil, success: { (response) in
            completed(true)
        }) { (error) in
            completed(false)
        }
    }

    //MARK: 更改订单状态
    static func changeOrderStatus(guid: String, completed: @escaping ()->()) {
        let params: [String: Any] = ["status": 4,
                                     "guid": guid]
        NetWork.request(urlConnection: baseUrl + GECApis.changeOrderStatus, method: .post, parameter: params, header: nil, success: { (response) in
            completed()
        }) { (_) in
            completed()
        }
    }

    //MARK: 减购物车产品
    static func subtractFromCart(with model: GECRestaurantDishModel) {
        for dishModel in cartDishesList{
            if dishModel.guid!.elementsEqual(model.guid!) {
                dishModel.quantity -= 1
            }
        }
    }

    //MARK: 删购物车产品
    static func removeDishFromCart(with model: GECRestaurantDishModel) {
        for (index,dishModel) in cartDishesList.enumerated() {
            if dishModel.guid!.elementsEqual(model.guid!) {
                dishModel.quantity = 0
                if let attributes = dishModel.attributes {
                    _ = attributes.map{$0.isSelect = false}
                }
                cartDishesList.remove(at: index)
            }
        }
    }

    //MARK: 删除全部产品
    static func removeAllCartDishes() {
        for item in cartDishesList {
            item.quantity = 0
        }
        cartDishesList.removeAll()
    }

    static func checkCurrenDishesList(index: Int, model: GECRestaurantDishModel, isAdd: Bool) {
        if let dishesList = currentRestaurantDishesList?[index].commodites {
            for dish in dishesList {
                if (dish.guid ?? dish.commodity_guid ?? dish.guid ?? "").elementsEqual(model.guid ?? model.commodity_guid ?? "") {
                    dish.quantity += isAdd == true ? 1 : -1
                    if dish.quantity <= 0 {dish.quantity = 0}
                    break
                }
            }
        }
    }

    // MARK: 计算购物车价格
    static func caculateCart(completed: @escaping ((_ errorMsg: Int?)->())) {
        totalDishesInCart = 0
        guard cartDishesList.count > 0, let selectStore = selectedRestaurantModel else { completed(ErrorCode.NON_PRODUCT); return }
        var items: [[String: Any]] = []
        for dishModel in cartDishesList {
            if dishModel.menuSelectedGarnishedList.count > 0 {
                totalDishesInCart += dishModel.addedGarnishCount
                for _ in 0..<dishModel.addedGarnishCount {
                    for garnishModelArr in dishModel.menuSelectedGarnishedList {
                        var item: [String: Any] = [:]
                        var garnishsItem: [String] = []
                        item["commodityGuid"] = dishModel.guid!
                        item["quantity"] = 1
                        for garnish in garnishModelArr {
                            for commodity in garnish.selectCommodity {
                                garnishsItem.append(commodity.commodity_guid!)
                            }
                        }
                        item["garnish"] = garnishsItem
                        items.append(item)
                    }
                }
            }else {
                totalDishesInCart += dishModel.quantity
                var item: [String: Any] = [:]
                item["commodityGuid"] = dishModel.guid!
                item["quantity"] = dishModel.quantity
                items.append(item)
            }
        }
        let params: [String: Any] = ["items": items,
                                     "storeGuid": selectStore.guid!]
        NetWork.request(urlConnection: baseUrl + GECApis.orderCalculate, method: .post, parameter: params, success: { (response) in
            if let error = response["isError"] as? Bool, error == false, let data = response["data"] as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    let cartPriceModel = try newJSONDecoder().decode(GECCartPriceModel.self, from: jsonData)
                    self.cartPriceModel = cartPriceModel

                    completed(nil)
                }catch {
                    completed(ErrorCode.NON_CACULATE_PRICE)
                }
            }else {
                completed(ErrorCode.NON_CACULATE_PRICE)
            }

        }) { (error) in
            completed(ErrorCode.SERVER_ERROR)
        }
    }

    //MARK: 获取用户地址
    static func getAllAddressRequest(storeGuid: String, completed: @escaping(_ errCode: Int?)->()) {
        let url = "\(baseUrl)\(GECApis.getAllAddress)?storeGuid=\(storeGuid)"
        NetWork.request(urlConnection: url, method: .get, success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false, let data = response["data"] as? [[String: Any]] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    let tempAddressList = try newJSONDecoder().decode(GECAddressModelList.self, from: jsonData)
                    defaultAddress = nil
                    userAddressList = tempAddressList
                    _ = userAddressList.map({
                        if let defaultFlag = $0.defaultAddress, defaultFlag == 1{
                            defaultAddress = $0
                        }
                    })
                    completed(nil)
                }catch {
                    completed(ErrorCode.NON_ADDRESS)
                }
            }else {
                completed(ErrorCode.NON_ADDRESS)
            }
        }) { (error) in
            completed(ErrorCode.SERVER_ERROR)
        }
    }

    //MARK: 获取支付方式
    static func getPayMethods(storeGuid: String, completed: @escaping((_ errorCode: Int?)->())) {
        let url = "\(baseUrl)\(GECApis.getPayMethods)?storeGuid=\(storeGuid)"
        NetWork.request(urlConnection: url, method: .get, success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false, let data = response["data"] as? [[String: Any]], data.count > 0 {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    storePayMethodList = try newJSONDecoder().decode(GECStorePayMethodsList.self, from: jsonData)
                    _ = storePayMethodList.map({
                        if let systemName = $0.systemName, systemName.elementsEqual("Cash") {
                            defaultPayMethod = $0
                        }
                    })
                    completed(nil)
                }catch {
                    completed(ErrorCode.ERROR_FORMATTER)
                }
            }else {
                completed(ErrorCode.NON_PAY_METHOD)
            }
        }) { (_) in
            completed(ErrorCode.SERVER_ERROR)
        }
    }

    //MARK: 确认下单
    static func confirmToOrder(deliveryGuid: String, storeGuid: String, remark: String = "", completed: @escaping((_ errorCode: Int?)->())) {
        let url = "\(baseUrl)\(GECApis.confirmOrder)"
        var params: [String: Any] = [
            "deliveryInfo": ["guid": self.defaultAddress?.guid ?? ""],
            "deliveryFee": selectedRestaurantModel?.takeawayMinimumConsumption ?? 0,
            "remarks": remark,
            "storeGuid": storeGuid,
            "paymentMethod": defaultPayMethod?.systemName ?? "Cash",
            "zipCode": Int(defaultAddress?.zipcode ?? "0") ?? 0,
            "deliveryTime": "yyyy-MM-dd HH:mm:ss".dateWithFormatter
        ]
        var items: [[String: Any]] = []
        for dishModel in cartDishesList {
            if dishModel.menuSelectedGarnishedList.count > 0 {
                totalDishesInCart += dishModel.addedGarnishCount
                for _ in 0..<dishModel.addedGarnishCount {
                    for garnishModelArr in dishModel.menuSelectedGarnishedList {
                        var item: [String: Any] = [:]
                        var garnishsItem: [String] = []
                        item["commodityGuid"] = dishModel.guid!
                        item["quantity"] = 1
                        for garnish in garnishModelArr {
                            for commodity in garnish.selectCommodity {
                                garnishsItem.append(commodity.commodity_guid!)
                            }
                        }
                        item["garnish"] = garnishsItem
                        items.append(item)
                    }
                }
            }else {
                var attribute: [String] = []
                _ = dishModel.selectedAttributes.map{attribute.append($0.guid ?? "")}
                items.append(["commodityGuid": dishModel.guid ?? "", "quantity": dishModel.quantity, "attributes": attribute])
            }

        }
        params["items"] = items
        NetWork.request(urlConnection: url, method: .post, parameter: params, success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false, let data = response["data"] as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    currentOrderModel = try newJSONDecoder().decode(GECTakeAwayOrderModel.self, from: jsonData)
                    completed(nil)
                }catch (_){
                    completed(ErrorCode.ERROR_FORMATTER)
                }
            }else {
                completed(ErrorCode.OUT_SERVICE)
            }
        }) { (_) in
            completed(ErrorCode.SERVER_ERROR)
        }
    }


}


// MARK: - GECOrderViewMocel
extension GECHomeViewModel {
    static let orderDishesCellIdentifier = "orderDishesCellIdentifier"

    static let orderFooterHeight: CGFloat = 100
    static let orderHeaderHeight: CGFloat = 50
    static let orderDeviveryViewHeight: CGFloat = 210
    static let orderInfoViewHeight: CGFloat = 250
    static let orderRowHeight: CGFloat = 60
}

//MARK: - 商家详情
extension GECHomeViewModel {

    //MARK: 当前商家详情
    static var currentStoreInfo: GECRestaurantsStoreModel?

    //MARK: 关注商家
    ///
    /// - Parameters:
    ///   - storeId: 店铺Id
    ///   - completed: 回调
    static func followRestaturant(with storeId: String, completed: @escaping ((_ error: String?)->())) {
        NetWork.request(urlConnection: baseUrl + GECApis.followRestaurant, method: .post, parameter: ["storeGuid": storeId], success: { (response) in
            if let error = response["isError"] as? Bool, error == true {
                completed("请求关注失败")
            }else {
                completed(nil)
            }
        }) { (error) in
            completed("请求失败")
        }
    }

    //MARK: 获取商家详情
    static func getStoreDetailInfo(_ guid: String, completed: @escaping (_ error: Int?)->()) {
        let url = "\(baseUrl)\(GECApis.storeDetailInfo)?guid=\(guid)"
        NetWork.request(urlConnection: url, method: .get, success: { (response) in
            if let isError = response["isError"] as? Bool, isError == false {
                if let data = response["data"] as? [String: Any] {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                        currentStoreInfo = try? newJSONDecoder().decode(GECRestaurantsStoreModel.self, from: jsonData)
                        completed(nil)
                    }else {
                        completed(ErrorCode.ERROR_FORMATTER)
                    }
                }else { completed(ErrorCode.NULL_STORE_ERROR) }
            }else {
                completed(ErrorCode.NULL_STORE_ERROR)
            }
        }) { (_) in
            completed(ErrorCode.SEARCH_ERROR)
        }
    }

    //MARK: 取消关注餐馆
    static func deleteFollowRestaurant(with storeId: String, completed: @escaping ((_ error: String?)->())) {
        NetWork.request(urlConnection: baseUrl + GECApis.deleteRestaurantFollow, method: .post, parameter: ["storeGuid": storeId], success: { (response) in
            if let error = response["isError"] as? Bool, error == true {
                completed("请求关注失败")
            }else {
                completed(nil)
            }
        }) { (error) in
            completed("请求失败")
        }
    }

    //MARK: 分享功能
    static func shareWithSystem(text: String, and image: UIImage?, then url: URL?) {
        let items = [text, image ?? UIImage(named: "logo3")!, url ?? URL(string: "www.google.es")!] as [Any]
        let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVc.completionWithItemsHandler = { activity, success, items, error in

        }
        UIApplication.shared.keyWindow?.rootViewController?.present(activityVc, animated: true, completion: nil)
    }
}

//MARK: - DishCell 代理
protocol DishesCellProtocol: NSObjectProtocol {

    func dishesCellImageSelected(cell: GECRestaurantDishesCell)
    func resCellDishSubtractQuantity(cell: GECRestaurantDishesCell, model: GECRestaurantDishModel, canDelete: Bool)

    func cellDishAugmentQuantity(cell: GECPreCartDishesCell, model: GECRestaurantDishModel)
    func preCartCellDishSubtractQuantity(cell: GECPreCartDishesCell, model: GECRestaurantDishModel, canDelete: Bool)
}
