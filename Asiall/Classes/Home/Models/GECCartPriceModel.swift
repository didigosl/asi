//
//  GECCartDishesModel.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/9.
//  Copyright © 2019 GoEat. All rights reserved.
// To parse the JSON, add this file to your project and do:
//
//   let gECCartDishesModel = try? newJSONDecoder().decode(GECCartPriceModel.self, from: jsonData)

import Foundation

// MARK: - GECCartDishesModel
class GECCartPriceModel: Codable {
    let actuallyPaidAmount: String?
    let discountAmount: String?
    let total: String?
    let rule: Rule?

    enum CodingKeys: String, CodingKey {
        case actuallyPaidAmount
        case discountAmount
        case total
        case rule
    }

    init(actuallyPaidAmount: String?, discountAmount: String?, total: String?, rule: Rule?) {
        self.actuallyPaidAmount = actuallyPaidAmount
        self.discountAmount = discountAmount
        self.total = total
        self.rule = rule
    }
}

// MARK: - Rule
class Rule: Codable {
    let id: Int?
    let storeGuid: String?
    let type: Int?
    let threshold: Double?
    let discount: Double?
    let enabled: Int?
    let startTime: String?
    let endTime: String?
    let createTime: String?
    let updateTime: String?
    let totalDiscount: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case storeGuid
        case type
        case threshold
        case discount
        case enabled
        case startTime
        case endTime
        case createTime
        case updateTime
        case totalDiscount
    }

    init(id: Int?, storeGuid: String?, type: Int?, threshold: Double?, discount: Double?, enabled: Int?, startTime: String?, endTime: String?, createTime: String?, updateTime: String?, totalDiscount: Double?) {
        self.id = id
        self.storeGuid = storeGuid
        self.type = type
        self.threshold = threshold
        self.discount = discount
        self.enabled = enabled
        self.startTime = startTime
        self.endTime = endTime
        self.createTime = createTime
        self.updateTime = updateTime
        self.totalDiscount = totalDiscount
    }
}
