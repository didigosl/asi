//
//  ErrorCode.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/9.
//  Copyright © 2019 GoEat. All rights reserved.
//

import Foundation

struct ErrorCode {
    static let NON_PRODUCT = 10001
    static let NON_CACULATE_PRICE = 10002
    static let SERVER_ERROR = 10003
    static let NON_ADDRESS = 10004
    static let NON_PAY_METHOD = 10005
    static let ERROR_FORMATTER = 10006
    static let ORDER_ERROR = 10007
    static let OUT_SERVICE = 10008
    static let CREATE_ADDRESS_ERROR = 10009
    static let ERROR_ADDRESS_INFO = 10010
    static let CANT_DELETE_ADDRESS = 10011
    static let SEARCH_ERROR = 10012
    static let DETAIL_ORDER_ERROR = 10013
    static let LOGIN_ERROR = 10014
    static let DOC_INFO_ERROR = 10015
    static let NULL_STORE_ERROR = 10016
    static let ERROR_QR_CODE = 10017
    static let ERROR_NULL_OLD_ORDER = 10018
    static func getErrorMsg(errorCode: Int) -> String {
        var str = ""
        switch errorCode {
        case NON_PRODUCT:
            str = "无产品".getLocaLized
        case NON_CACULATE_PRICE:
            str = "无法计算价格".getLocaLized
        case SERVER_ERROR:
            str = "服务器错误".getLocaLized
        case NON_ADDRESS:
            str = "无法获取地址".getLocaLized
        case NON_PAY_METHOD:
            str = "改商家暂不支持任何支付方式".getLocaLized
        case ERROR_FORMATTER:
            str = "数据格式错误".getLocaLized
        case ORDER_ERROR:
            str = "下单失败".getLocaLized
        case OUT_SERVICE:
            str = "服务范围外".getLocaLized
        case CREATE_ADDRESS_ERROR:
            str = "地址信息错误, 无法保存".getLocaLized
        case ERROR_ADDRESS_INFO:
            str = "地址信息错误".getLocaLized
        case CANT_DELETE_ADDRESS:
            str = "无法删除地址".getLocaLized
        case SEARCH_ERROR:
            str = "无法获取订单列表".getLocaLized
        case DETAIL_ORDER_ERROR:
            str = "获取订单详情失败".getLocaLized
        case LOGIN_ERROR:
            str = "暂未登陆".getLocaLized
        case DOC_INFO_ERROR:
            str = "文档无法获取".getLocaLized
        case NULL_STORE_ERROR:
            str = "无此商家信息".getLocaLized
        case ERROR_QR_CODE:
            str = "二维码信息错误".getLocaLized
        case ERROR_NULL_OLD_ORDER:
            str = "无旧订单,欢迎下单".getLocaLized
        default:
            str = ""
        }
        return str
    }
}
