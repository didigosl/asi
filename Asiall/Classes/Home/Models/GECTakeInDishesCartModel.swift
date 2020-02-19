//
//  GECTakeInDishesCartModel.swift
//  G-eatClient
//
//  Created by JS_Coder on 25/07/2019.
//  Copyright © 2019 GoEat. All rights reserved.

//   let gECTakeInDishesCartModel = try? newJSONDecoder().decode(GECTakeInDishesCartModel.self, from: jsonData)

import Foundation

// MARK: - GECTakeInDishesCartModel
class GECTakeInDishesCartModel: Codable {
    let actuallyPaidAmount: String?
    let discountAmount: String?
    let total: String?
    let rule: Rule?
    let items: [GECOrderItemModel]?

    enum CodingKeys: String, CodingKey {
        case actuallyPaidAmount = "actuallyPaidAmount"
        case discountAmount = "discountAmount"
        case total = "total"
        case rule = "rule"
        case items = "items"
    }

    init(actuallyPaidAmount: String?, discountAmount: String?, total: String?, rule: Rule?, items: [GECOrderItemModel]?) {
        self.actuallyPaidAmount = actuallyPaidAmount
        self.discountAmount = discountAmount
        self.total = total
        self.rule = rule
        self.items = items
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
