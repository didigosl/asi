//
//  GECUserInfoModel.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/3/13.
//  Copyright © 2019 GoEat. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let gECUserInfoModel = try? newJSONDecoder().decode(GECUserInfoModel.self, from: jsonData)

import Foundation

class GECUserInfoModel: Codable {
    var guid, name, email, headImage, phone, createTime: String?

    init(guid: String?, name: String?, email: String?, headImage: String?, phone: String?, createTime: String?) {
        self.guid = guid
        self.name = name
        self.email = email
        self.headImage = headImage
        self.phone = phone
        self.createTime = createTime
    }

    static func getUserInfoModel() -> GECUserInfoModel? {
        do {
            if let jsonData = UserDefaults.standard.value(forKey: DefaultsKeys.userInfoKey) as? Data {
                // decoder 模型
                GECProfileViewModel.userInfoModel = try newJSONDecoder().decode(GECUserInfoModel.self, from: jsonData)
                return GECProfileViewModel.userInfoModel
            }else { return nil }
        }catch { return nil }
    }
}
