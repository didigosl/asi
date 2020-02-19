//
//  GECApis.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/3/11.
//  Copyright © 2019 GoEat. All rights reserved.
//

import Foundation
/// BaseUrl Path
#if DEBUG
let baseUrl = "http://waimaiapi.yxsht.club"
#else
let baseUrl = "http://waimaiapi.yxsht.club"
#endif

struct GECApis {
    /**
     * 获取当前登陆用户信息 Get
     */
    static let customerInfo = "/customer/v1/customer?storeGuid=storeGuid"

    /**
     * 更新当前登陆用户信息 Post
     */
    static let updateCustomerInfo = "/customer/v1/customer/update"

    static let socketUrl = ":13000/"

    /**
     * 堂食 添加到购物车
     */
    static let takeInAddToCart = "/qrcode/v1/cart/"

    /**
     * 堂食 下单
     */
    static let takeInOrder = "/qrcode/v1/order/"
    /**
     * 修改密码
     * oldPassword: String
     * newPassword1: String
     * newPassword2: String
     */
    static let changePassword = "/customer/v1/customer/password"

    /**
     * 上传用户头像 Post
     */
    static let uploadUserImage = "/store/v1/upload"

    /**
     * 注册用户 Post
     */
    static let register = "/customer/v1/customer/register?storeGuid=storeGuid"

    /**
     * 修改用户资料
     */
    static let updateInfo = "/customer/v1/customer/update"

    /**
     * 用户登陆 Post
     */
    static let login = "/customer/v1/login?storeGuid=storeGuid"

    /**
     * 获取餐馆信息 GET
     * 关注餐馆 POST
     */
    static let followRestaurant = "/customer/v1/customer/follow"

    /**
     * 获取餐馆菜品 GET  storeGuid
     *
     */
    static let getAllCommodity = "/customer/v1/commodity/all"

    /**
     * 取消关注餐馆 POST
     * param : {"guid": String}
     */
    static let deleteRestaurantFollow = "/customer/v1/customer/deletefollow"

    /**
     * 搜索餐馆 带Key
     */
    static let searchRestaurant = "/customer/v1/store/search"

    /**
     *业务分类 - 餐饮类型
     */
    static let getMainBusiness = "/customer/v1/store/mainBusiness"

    /**
     * 查看之前订单
     */
    static let oldOrder = "/qrcode/v1/myorder/"

    /**
     * 查看现有订单
     */
    static let currentOrder = "/qrcode/v1/cart/"
    /**
     * 餐馆详情
     * GET - guid
     */
    static let storeDetailInfo = "/customer/v1/store"

    /**
     * 计算价格
     */
    static let orderCalculate = "/customer/v1/order/calculate"

    /**
     * 返回所有地址
     * Method: GET
     * params {"storeGuid": String}
     */
    static let getAllAddress = "/customer/v1/customeraddress/all"

    /**
     * 返回 当前商家支持的支付方式
     * Method: GET
     * params {"storeGuid": String}
     */
    static let getPayMethods = "/customer/v1/store/paymethod"

    /**
     * 确认下单
     * Method: POST
     */
    static let confirmOrder = "/customer/v1/order/takeaway"

    /**
     * 创建新地址
     * Method: POST
     */
    static let createAddress = "/customer/v1/customeraddress"

    /**
     * 更新地址
     * Method: POST
     */
    static let updateAddress = "/customer/v1/customeraddress/update"

    /**
     * 删除地址
     * Method: POST
     */
    static let deleteAddress = "/customer/v1/customeraddress/delete"

    /**
     * 搜索订单
     * Params
     * paymentStatus: Int
     * status: Int
     *
     */
    static let searchOrder = "/customer/v1/order/search"

    /**
     * 查看订单详情
     * guid: String
     * storeGuid: String
     */
    static let orderDetail = "/customer/v1/order/details"
    /**
     * 修改订单状态
     * guid: String
     * status: Integer (0.已下单等待接单（堂食等待支付） 1.已打包 2.配送中（外卖） 3.已经送达(外卖) 4.已完成（堂食支付完成） 5.已结算 6.已退订)
     */
    static let changeOrderStatus = "/customer/v1/order/status"

    static let getDiscountInfos = "/customer/v1/store/coupon/all"

}



