//
//  GECOrderListModel.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/18.
//  Copyright © 2019 GoEat. All rights reserved.

//   let GECSearchOrderList = try? newJSONDecoder().decode(GECSearchOrderList.self, from: jsonData)

import Foundation

// MARK: - GECOrderListModel
class GECSearchOrderList: Codable {
    let collection: [GECOrderModel]?
    let hasNextPage: Bool?
    let hasPreviousPage: Bool?
    let pageIndex: Int?
    let pageSize: Int?
    let totalCount: Int?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case collection
        case hasNextPage
        case hasPreviousPage
        case pageIndex
        case pageSize
        case totalCount
        case totalPages
    }

    init(collection: [GECOrderModel]?, hasNextPage: Bool?, hasPreviousPage: Bool?, pageIndex: Int?, pageSize: Int?, totalCount: Int?, totalPages: Int?) {
        self.collection = collection
        self.hasNextPage = hasNextPage
        self.hasPreviousPage = hasPreviousPage
        self.pageIndex = pageIndex
        self.pageSize = pageSize
        self.totalCount = totalCount
        self.totalPages = totalPages
    }
}

// MARK: - Collection
class GECOrderModel: Codable {
    let id: Int?
    let guid: String?
    let no: String?
    let serialNumber: String?
    let total: String?
    let discountAmount: String?
    let createTime: String?
    let type: Int?
    let status: Int?
    let printed: Int?
    let customerGuid: String?
    let storeGuid: String?
    let employeeGuid: String?
    let paymentStatus: Int?
    let itemCount: Int?
    let actuallyPaidAmount: String?
    let numberOfPeople: Int?
    let workNo: String?
    let deliveryTime: String?
    let paidTime: String?
    let paymentMethod: String?
    let remarks: String?
    let customerServiceRemarks: String?
    let typeText: String?
    let statusText: String?
    let paymentStatusText: String?
    let neto: String?
    let currentTotal: String?
    let iva: String?
    let deliveryInfo: DeliveryInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case guid
        case no
        case serialNumber
        case total
        case discountAmount
        case createTime
        case type
        case status
        case printed
        case customerGuid
        case storeGuid
        case employeeGuid
        case paymentStatus
        case itemCount
        case actuallyPaidAmount
        case numberOfPeople
        case workNo
        case deliveryTime
        case paidTime
        case paymentMethod
        case remarks
        case customerServiceRemarks
        case typeText
        case statusText
        case paymentStatusText
        case neto
        case currentTotal
        case iva
        case deliveryInfo
    }

    init(id: Int?, guid: String?, no: String?, serialNumber: String?, total: String?, discountAmount: String?, createTime: String?, type: Int?, status: Int?, printed: Int?, customerGuid: String?, storeGuid: String?, employeeGuid: String?, paymentStatus: Int?, itemCount: Int?, actuallyPaidAmount: String?, numberOfPeople: Int?, workNo: String?, deliveryTime: String?, paidTime: String?, paymentMethod: String?, remarks: String?, customerServiceRemarks: String?, typeText: String?, statusText: String?, paymentStatusText: String?, neto: String?, currentTotal: String?, iva: String?, deliveryInfo: DeliveryInfo?) {
        self.id = id
        self.guid = guid
        self.no = no
        self.serialNumber = serialNumber
        self.total = total
        self.discountAmount = discountAmount
        self.createTime = createTime
        self.type = type
        self.status = status
        self.printed = printed
        self.customerGuid = customerGuid
        self.storeGuid = storeGuid
        self.employeeGuid = employeeGuid
        self.paymentStatus = paymentStatus
        self.itemCount = itemCount
        self.actuallyPaidAmount = actuallyPaidAmount
        self.numberOfPeople = numberOfPeople
        self.workNo = workNo
        self.deliveryTime = deliveryTime
        self.paidTime = paidTime
        self.paymentMethod = paymentMethod
        self.remarks = remarks
        self.customerServiceRemarks = customerServiceRemarks
        self.typeText = typeText
        self.statusText = statusText
        self.paymentStatusText = paymentStatusText
        self.neto = neto
        self.currentTotal = currentTotal
        self.iva = iva
        self.deliveryInfo = deliveryInfo
    }
}

// MARK: - DeliveryInfo
class DeliveryInfo: Codable {
    let contact: String?
    let country: String?
    let province: String?
    let city: String?
    let address1: String?
    let address2: String?
    let address3: String?
    let phone: String?
    let orderGuid: String?
    let longitude: Double?
    let latitude: Double?
    let deliveryman: String?

    enum CodingKeys: String, CodingKey {
        case contact
        case country
        case province
        case city
        case address1
        case address2
        case address3
        case phone
        case orderGuid
        case longitude
        case latitude
        case deliveryman
    }

    init(contact: String?, country: String?, province: String?, city: String?, address1: String?, address2: String?, address3: String?, phone: String?, orderGuid: String?, longitude: Double?, latitude: Double?, deliveryman: String?) {
        self.contact = contact
        self.country = country
        self.province = province
        self.city = city
        self.address1 = address1
        self.address2 = address2
        self.address3 = address3
        self.phone = phone
        self.orderGuid = orderGuid
        self.longitude = longitude
        self.latitude = latitude
        self.deliveryman = deliveryman
    }
}
