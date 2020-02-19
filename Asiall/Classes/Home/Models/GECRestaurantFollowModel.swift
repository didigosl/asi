//
//  GECRestaurantFollowModel.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/4.
//  Copyright © 2019 GoEat. All rights reserved.

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gECRestaurantFollowListModel = try? newJSONDecoder().decode(GECRestaurantFollowListModel.self, from: jsonData)

import Foundation

// MARK: - GECRestaurantFollowListModel
class GECRestaurantFollowListModel: Codable {
    let isError: Bool?
    let data: [GECRestaurantsStoreModel]?

    enum CodingKeys: String, CodingKey {
        case isError = "isError"
        case data = "data"
    }

    init(isError: Bool?, data: [GECRestaurantsStoreModel]?) {
        self.isError = isError
        self.data = data
    }
}

