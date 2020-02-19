//
//  GECAddressModel.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/12.
//  Copyright © 2019 GoEat. All rights reserved.

// To parse the JSON, add this file to your project and do:
//   let gECAddressModelList = try? newJSONDecoder().decode(GECAddressModelList.self, from: jsonData)

// JSONSchemaSupport.swift
import Foundation
typealias GECAddressModelList = [GECAddressModel]

// MARK: - GECUserAddressListElement
class GECAddressModel: Codable {
    let id: Int?
    let guid: String?
    var country: String?
    var province: String?
    var city: String?
    var address1: String?
    var address2: String? // 街道号码
    var address3: String? // 门牌号码
    var phone: String?
    let createTime: String?
    let customerGuid: String?
    let longitude: String?
    let latitude: String?
    var contact: String?
    var defaultAddress: Int?
    var zipcode: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case guid = "guid"
        case country = "country"
        case province = "province"
        case city = "city"
        case address1 = "address1"
        case address2 = "address2"
        case address3 = "address3"
        case phone = "phone"
        case createTime = "createTime"
        case customerGuid = "customerGuid"
        case longitude = "longitude"
        case latitude = "latitude"
        case contact = "contact"
        case defaultAddress = "defaultAddress"
        case zipcode = "zipcode"
    }

    init(id: Int?, guid: String?, country: String?, province: String?, city: String?, address1: String?, address2: String?, address3: String?, phone: String?, createTime: String?, customerGuid: String?, longitude: String?, latitude: String?, contact: String?, defaultAddress: Int?, zipcode: String?) {
        self.id = id
        self.guid = guid
        self.country = country
        self.province = province
        self.city = city
        self.address1 = address1
        self.address2 = address2
        self.address3 = address3
        self.phone = phone
        self.createTime = createTime
        self.customerGuid = customerGuid
        self.longitude = longitude
        self.latitude = latitude
        self.contact = contact
        self.defaultAddress = defaultAddress
        self.zipcode = zipcode
    }
}


