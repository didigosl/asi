//
//  GECStorePayMethodList.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/12.
//  Copyright © 2019 GoEat. All rights reserved.

//   let gECStorePayMethodsList = try? newJSONDecoder().decode(GECStorePayMethodModel.self, from: jsonData)

import Foundation

// MARK: - GECStorePayMethodsListElement
class GECStorePayMethodModel: Codable {
    let name: String?
    let systemName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case systemName
    }

    init(name: String?, systemName: String?) {
        self.name = name
        self.systemName = systemName
    }
}

typealias GECStorePayMethodsList = [GECStorePayMethodModel]
