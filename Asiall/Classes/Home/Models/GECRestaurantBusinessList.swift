//
//  GECRestaurantBusinessList.swift
//  G-eatClient
//
//  Created by JS_Coder on 20/12/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let jSRestaurantBusinessList = try? newJSONDecoder().decode(JSRestaurantBusinessList.self, from: jsonData)

import Foundation

// MARK: - GECRestaurantBusinessList
class GECRestaurantBusinessModel: Codable {
    let id: Int?
    let guid: String?
    let name: String?
    let status: Int?
    let priority: Int?
    let createdAt: String?
    let updatedAt: String?
    let statusText: String?
    var isSelect: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case guid = "guid"
        case name = "name"
        case status = "status"
        case priority = "priority"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case statusText = "status_text"
    }

    init(id: Int?, guid: String?, name: String?, status: Int?, priority: Int?, createdAt: String?, updatedAt: String?, statusText: String?) {
        self.id = id
        self.guid = guid
        self.name = name
        self.status = status
        self.priority = priority
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.statusText = statusText
    }
}

typealias GECRestaurantBusinessList = [GECRestaurantBusinessModel]
