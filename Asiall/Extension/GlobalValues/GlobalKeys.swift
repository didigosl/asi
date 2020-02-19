//
//  GlobalKeys.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/10.
//  Copyright © 2019 GoEat. All rights reserved.
//

import Foundation

struct ControllersKeys {
    static let className = "className"
    static let tableTitle = "tabTitle"
    static let tabImage = "tabImage"
}

struct SettingCellKeys {
    static let imageName = "imageName"
    static let settingTitle = "settingTitle"
    static let tag = "tag"
}

struct InfoKeys {
    enum InfoEnums: Int {
        case icon = 0
        case userName = 1
        case email = 2
        case password = 3
        case phoneNUmber = 4
    }
    static let title = "title"
    static let description = "description"
    static let infoType = "infoType"
}

struct DefaultsKeys {
    static let loginKey = "Default.Login.States"
    static let userInfoKey = "Default.User.States"

}

struct SystemKeyPaths {
    static let searchBarBackgroundKey = "_background"
    static let searchBarTextFieldKey = "_searchField"
}

struct NotificationNames {
    static let updateAddress = Notification.Name("updateAddress")
    static let updateRestauranteDishes = Notification.Name("updateRestauranteDishes")
    static let updateFollowRestaurant = Notification.Name("updateFollowRestaurant")
    static let updateCartAddress = Notification.Name("updateCartAddress")
    static let showTakeInRestaurant = Notification.Name("showTakeInRestaurant")
    static let pushToRestaurante = Notification.Name("pushToRestaurante")
    static let updateTakeInRestaurant = Notification.Name("updateTakeInRestaurant")
    static let updateOrderList = Notification.Name("updateOrderList")
    static let checkRestaurantDishsList = Notification.Name("checkRestaurantDishsList")
    static let needToLogin = Notification.Name("needToLogin")

}
