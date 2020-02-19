//
//  GECRestaurantFollowModel.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/4.
//  Copyright © 2019 GoEat. All rights reserved.

//   let gECRestaurantDishesList = try? newJSONDecoder().decode(GECRestaurantDishesList.self, from: jsonData)

import Foundation
protocol Copyable {
    func copy() -> Copyable
}
// MARK: - GECRestaurantDishesListElement
class GECRestaurantDishesListElement: Codable {
    var name: String?
    let guid: String?
    let storeGuid: String?
    let sorting: Int?
    var commodites: [GECRestaurantDishModel]?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case guid = "guid"
        case storeGuid = "storeGuid"
        case sorting = "sorting"
        case commodites = "commodites"
    }

    init(name: String?, guid: String?, storeGuid: String?, sorting: Int?, commodites: [GECRestaurantDishModel]?) {
        self.name = name
        self.guid = guid
        self.storeGuid = storeGuid
        self.sorting = sorting
        self.commodites = commodites
    }
}

// MARK: - Commodite
extension GECRestaurantDishModel {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(guid)
        hasher.combine(name)
        hasher.combine(price)
    }
}
public class GECRestaurantDishModel: Codable, Hashable, Copyable {
    public static func == (lhs: GECRestaurantDishModel, rhs: GECRestaurantDishModel) -> Bool {
      return (lhs.guid ?? "").elementsEqual(rhs.guid ?? "")
    }

    let category: Category?
    let categoryGuid: String?
    let commoditeDescription: String?

    /*
     Garnish Commodity
     */
    let commodity_guid: String?
    let status: Int?
    let commodity_name: String?
    let commodity_price: String?
    var garnishCommoditySelected: Bool = false
    let garnishes: [GECCommodityGarnishModel]?
    var menuSelectedGarnishedList: [[GECCommodityGarnishModel]] = []
    var addedGarnishCount: Int = 0
    /*
     Garnish Commodity
     */
    let enabled: Bool?
    let guid: String?
    let name: String?
    let no: String?
    let price: String?
    let recommended: Bool?
    let sorting: Int?
    let storeGuid: String?
    let takeawayPrice: String?
    let type: Int?
    let unit: Category?
    let unitGuid: String?
    var quantity: Int = 0
    let images: [Image]?
    let attributes: [GECCommodityAttributeModel]?
    var selectedAttributes: [GECCommodityAttributeModel] {
        get {
            if let items = attributes {
                var temps: [GECCommodityAttributeModel] = []
                for item in items {
                    if item.isSelect { temps.append(item) } }
                return temps }; return [] }
    }
    var customRemarkAttribute: String = ""
    
    enum CodingKeys: String, CodingKey {
        case category = "category"
        case categoryGuid = "categoryGuid"
        case commoditeDescription = "description"
        case enabled = "enabled"
        case guid = "guid"
        case name = "name"
        case no = "no"
        case price = "price"
        case recommended = "recommended"
        case sorting = "sorting"
        case storeGuid = "storeGuid"
        case takeawayPrice = "takeawayPrice"
        case type = "type"
        case unit = "unit"
        case unitGuid = "unitGuid"
        case images = "images"
        case attributes = "attributes"
        case garnishes = "garnish"
        case commodity_guid = "commodity_guid"
        case status = "status"
        case commodity_name = "commodity_name"
        case commodity_price = "commodity_price"
//        case quantity = "quantity"
    }

    init(category: Category?, categoryGuid: String?, commoditeDescription: String?, enabled: Bool?, guid: String?, name: String?, no: String?, price: String?, recommended: Bool?, sorting: Int?, storeGuid: String?, takeawayPrice: String?, type: Int?, unit: Category?, unitGuid: String?, images: [Image]?, attributes: [GECCommodityAttributeModel]?, garnishes: [GECCommodityGarnishModel]?, commodity_guid: String?, status: Int?, commodity_name: String?, commodity_price: String?) {
        self.category = category
        self.categoryGuid = categoryGuid
        self.commoditeDescription = commoditeDescription
        self.enabled = enabled
        self.guid = guid
        self.name = name
        self.no = no
        self.price = price
        self.recommended = recommended
        self.sorting = sorting
        self.storeGuid = storeGuid
        self.takeawayPrice = takeawayPrice
        self.type = type
        self.unit = unit
        self.unitGuid = unitGuid
        self.images = images
        self.attributes = attributes
        self.garnishes = garnishes
        self.commodity_guid = commodity_guid
        self.status = status
        self.commodity_name = commodity_name
        self.commodity_price = commodity_price
    }

    func copy()-> Copyable{
        return GECRestaurantDishModel(category: category, categoryGuid: categoryGuid, commoditeDescription: commoditeDescription, enabled: enabled, guid: guid, name: name, no: no, price: price, recommended: recommended, sorting: sorting, storeGuid: storeGuid, takeawayPrice: takeawayPrice, type: type, unit: unit, unitGuid: unitGuid, images: images, attributes: attributes, garnishes: garnishes, commodity_guid: commodity_guid, status: status, commodity_name: commodity_name, commodity_price: commodity_price)
    }
}

//MARK: Garnishes
class GECCommodityGarnishModel: Codable, Copyable {
    let guid: String?
    let name: String?
    let min_select_num: Int?
    let commodityList: [GECRestaurantDishModel]?
    var selectCommodity: [GECRestaurantDishModel] = []
    var isShowCommodity: Bool = false
    enum CodingKeys: String, CodingKey {
        case guid = "guid"
        case name = "name"
        case min_select_num = "min_select_num"
        case commodityList = "commodity"
    }
    
    init(guid: String?, name: String?, min_select_num: Int?, commodityList: [GECRestaurantDishModel]?) {
        self.guid = guid
        self.name = name
        self.min_select_num = min_select_num
        self.commodityList = commodityList
    }

    func copy() -> Copyable {
        return GECCommodityGarnishModel(guid: guid, name: name, min_select_num: min_select_num, commodityList: commodityList)
    }
}

//MARK: - Attributes
class GECCommodityAttributeModel: Codable {
    let guid: String?
    let name: String?
    let pivot: GECCommodityPivotModel?
    var isSelect: Bool = false
    enum CodingKeys: String, CodingKey {
        case guid = "guid"
        case name = "name"
        case pivot = "pivot"
    }

    init(guid: String?, name: String?, pivot: GECCommodityPivotModel?) {
        self.guid = guid
        self.name = name
        self.pivot = pivot
    }


}

// MARK: - Pivot
class GECCommodityPivotModel: Codable {
    let commodityGuid: String?
    let commodityAttributesGuid: String?

    enum CodingKeys: String, CodingKey {
        case commodityGuid = "CommodityGuid"
        case commodityAttributesGuid = "CommodityAttributesGuid"
    }

    init(commodityGuid: String?, commodityAttributesGuid: String?) {
        self.commodityGuid = commodityGuid
        self.commodityAttributesGuid = commodityAttributesGuid
    }
}


// MARK: - Category
class Category: Codable {
    let name: String?
    let guid: String?

    enum CodingKeys: String, CodingKey {
        case name
        case guid
    }

    init(name: String?, guid: String?) {
        self.name = name
        self.guid = guid
    }
}

// MARK: - Image
class Image: Codable {
    let commodityGuid: String?
    let path: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case commodityGuid
        case path
        case url
    }

    init(commodityGuid: String?, path: String?, url: String?) {
        self.commodityGuid = commodityGuid
        self.path = path
        self.url = url
    }
}

typealias GECRestaurantDishesList = [GECRestaurantDishesListElement]
