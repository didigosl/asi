
//  LoginModel.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/3/12.
//  Copyright © 2019 GoEat. All rights reserved.
//
// Generated with quicktype
//   let gECLoginModel = try? newJSONDecoder().decode(GECLoginModel.self, from: jsonData)

import Foundation

class GECLoginModel: Codable {
    let tokenContent: String?
    let tokenType: String?
    let expiredIn: Int?

    enum CodingKeys: String, CodingKey {
        case tokenContent, tokenType, expiredIn
    }

    init( tokenContent: String?, tokenType: String?, expiredIn: Int?) {
        self.tokenContent = tokenContent
        self.tokenType = tokenType
        self.expiredIn = expiredIn

    }

    static func getLoginModel() -> GECLoginModel? {
        do {
            if let jsonData = UserDefaults.standard.value(forKey: DefaultsKeys.loginKey) as? Data {
                // decoder 模型
                GECProfileViewModel.loginModel = try newJSONDecoder().decode(GECLoginModel.self, from: jsonData)
                return GECProfileViewModel.loginModel
            }else { return nil }
        }catch { return nil }
    }
}
