//
//  GECDocumentModel.swift
//  G-eatClient
//
//  Created by JS_Coder on 05/07/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//
//   let gECDocumentInfoModel = try? newJSONDecoder().decode(GECDocumentInfoModel.self, from: jsonData)

import Foundation

// MARK: - GECDocumentInfoModel
class GECDoccumentInfoModel: Codable {
    let collection: [GECSubInfosModel]?
    let hasNextPage: Bool?
    let hasPreviousPage: Bool?
    let pageIndex: Int?
    let pageSize: Int?
    let totalCount: Int?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case collection = "collection"
        case hasNextPage = "hasNextPage"
        case hasPreviousPage = "hasPreviousPage"
        case pageIndex = "pageIndex"
        case pageSize = "pageSize"
        case totalCount = "totalCount"
        case totalPages = "totalPages"
    }

    init(collection: [GECSubInfosModel]?, hasNextPage: Bool?, hasPreviousPage: Bool?, pageIndex: Int?, pageSize: Int?, totalCount: Int?, totalPages: Int?) {
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
class GECSubInfosModel: Codable {
    let id: Int?
    let categoryId: Int?
    let title: String?
    let published: Int?
    let content: String?
    let creatorId: Int?
    let publishedAt: String?
    let createdAt: String?
    let updatedAt: String?
    let category: GECDocumentCategory?
    let creator: GECDocumentCreator?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case categoryId = "categoryId"
        case title = "title"
        case published = "published"
        case content = "content"
        case creatorId = "creatorId"
        case publishedAt = "publishedAt"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case category = "category"
        case creator = "creator"
    }

    init(id: Int?, categoryId: Int?, title: String?, published: Int?, content: String?, creatorId: Int?, publishedAt: String?, createdAt: String?, updatedAt: String?, category: GECDocumentCategory?, creator: GECDocumentCreator?) {
        self.id = id
        self.categoryId = categoryId
        self.title = title
        self.published = published
        self.content = content
        self.creatorId = creatorId
        self.publishedAt = publishedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.category = category
        self.creator = creator
    }
}

// MARK: - Category
class GECDocumentCategory: Codable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

// MARK: - Creator
class GECDocumentCreator: Codable {
    let id: Int?
    let guid: String?
    let name: String?
    let email: String?
    let password: String?
    let headImage: String?
    let phone: String?
    let salt: String?
    let createTime: String?
    let deleted: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case guid = "guid"
        case name = "name"
        case email = "email"
        case password = "password"
        case headImage = "headImage"
        case phone = "phone"
        case salt = "salt"
        case createTime = "createTime"
        case deleted = "deleted"
    }

    init(id: Int?, guid: String?, name: String?, email: String?, password: String?, headImage: String?, phone: String?, salt: String?, createTime: String?, deleted: Int?) {
        self.id = id
        self.guid = guid
        self.name = name
        self.email = email
        self.password = password
        self.headImage = headImage
        self.phone = phone
        self.salt = salt
        self.createTime = createTime
        self.deleted = deleted
    }
}
