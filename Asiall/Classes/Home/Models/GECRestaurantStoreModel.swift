import Foundation

// MARK: - GECSearchRestaurantsModels
class GECSearchRestaurantsModels: Codable {
    let collection: [GECRestaurantsStoreModel]?
    let hasNextPage: Bool?
    let hasPreviousPage: Bool?
    let pageIndex: Int?
    let pageSize: String?
    let totalCount: Int?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case collection
        case hasNextPage
        case hasPreviousPage
        case pageIndex
        case pageSize
        case totalCount
        case totalPages
    }

    init(collection: [GECRestaurantsStoreModel]?, hasNextPage: Bool?, hasPreviousPage: Bool?, pageIndex: Int?, pageSize: String?, totalCount: Int?, totalPages: Int?) {
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
class GECRestaurantsStoreModel: Codable {
    let id: Int?
    let name: String?
    let enabled: Int?
    let deleted: Int?
    let email: String?
    let mobile: String?
    let perCapita: String?
    let cif: String?
    let createTime: String?
    let guid: String?
    let mainBusiness: String?
    let no: String?
    let supportedPaymentMethod: String?
    let deliveryDistance: String?
    let takeawaySupportedPaymentMethod: String?
    let takeawayMinimumConsumption: Double?
    let open: Int?
    let disabled: Int?
    let status: Int?
    /// 0 >> 禁止外卖 1 >> 外卖且外送 2 >> 外卖但不外送
    let takeawayStatus: Int?
    var following: Bool?
    let todayBusinessHours: [GECStoreBusinessHour]?
    let logo: GECStoreLogo?
    let address: Address?
    let businessHours: [GECStoreBusinessHour]?
    let images: [GECStoreImage]?
    let appbackground: GECStoreLogo?
    let about: String?
    let aboutCoverPath: String?

    var dishesList: GECRestaurantDishesList?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case enabled
        case deleted
        case email
        case mobile
        case perCapita
        case cif
        case createTime
        case guid
        case mainBusiness
        case no
        case supportedPaymentMethod
        case deliveryDistance
        case takeawaySupportedPaymentMethod
        case takeawayMinimumConsumption
        case open
        case disabled
        case status
        case takeawayStatus
        case following
        case todayBusinessHours
        case logo
        case address
        case businessHours
        case images
        case appbackground
        case about
        case aboutCoverPath
    }

    init(id: Int?, name: String?, enabled: Int?, deleted: Int?, email: String?, mobile: String?, perCapita: String?, cif: String?, createTime: String?, guid: String?, mainBusiness: String?, no: String?, supportedPaymentMethod: String?, deliveryDistance: String?, takeawaySupportedPaymentMethod: String?, takeawayMinimumConsumption: Double?, open: Int?, disabled: Int?, status: Int?, takeawayStatus: Int?,following: Bool?, todayBusinessHours: [GECStoreBusinessHour]?, logo: GECStoreLogo?, address: Address?,businessHours: [GECStoreBusinessHour]?, images: [GECStoreImage]?, appbackground: GECStoreLogo?, about: String?, aboutCoverPath: String?) {
        self.id = id
        self.name = name
        self.enabled = enabled
        self.deleted = deleted
        self.email = email
        self.mobile = mobile
        self.perCapita = perCapita
        self.cif = cif
        self.createTime = createTime
        self.guid = guid
        self.mainBusiness = mainBusiness
        self.no = no
        self.supportedPaymentMethod = supportedPaymentMethod
        self.deliveryDistance = deliveryDistance
        self.takeawaySupportedPaymentMethod = takeawaySupportedPaymentMethod
        self.takeawayMinimumConsumption = takeawayMinimumConsumption
        self.open = open
        self.disabled = disabled
        self.status = status
        self.takeawayStatus = takeawayStatus
        self.following = following
        self.todayBusinessHours = todayBusinessHours
        self.logo = logo
        self.address = address
        self.businessHours = businessHours
        self.images = images
        self.appbackground = appbackground
        self.about = about
        self.aboutCoverPath = aboutCoverPath
    }
}

// MARK: - Address
class Address: Codable {
    let guid: String?
    let country: String?
    let province: String?
    let city: String?
    let address1: String?
    let address2: String?
    let address3: String?
    let phone: String?
    let createTime: String?
    let storeGuid: String?
    let longitude: Double?
    let latitude: Double?
    let contact: String?

    enum CodingKeys: String, CodingKey {
        case guid
        case country
        case province
        case city
        case address1
        case address2
        case address3
        case phone
        case createTime
        case storeGuid
        case longitude
        case latitude
        case contact
    }

    init(guid: String?, country: String?, province: String?, city: String?, address1: String?, address2: String?, address3: String?, phone: String?, createTime: String?, storeGuid: String?, longitude: Double?, latitude: Double?, contact: String?) {
        self.guid = guid
        self.country = country
        self.province = province
        self.city = city
        self.address1 = address1
        self.address2 = address2
        self.address3 = address3
        self.phone = phone
        self.createTime = createTime
        self.storeGuid = storeGuid
        self.longitude = longitude
        self.latitude = latitude
        self.contact = contact
    }
}

// MARK: - Logo
class GECStoreLogo: Codable {
    let id: Int?
    let storeGuid: String?
    let imageType: Int?
    let path: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case storeGuid
        case imageType
        case path
        case url
    }

    init(id: Int?, storeGuid: String?, imageType: Int?, path: String?, url: String?) {
        self.id = id
        self.storeGuid = storeGuid
        self.imageType = imageType
        self.path = path
        self.url = url
    }
}

// MARK: - TodayBusinessHour
class GECStoreBusinessHour: Codable {
    let id: Int?
    let storeGuid: String?
    let startTime: String?
    let endTime: String?
    let weekday: String?

    enum CodingKeys: String, CodingKey {
        case id
        case storeGuid
        case startTime
        case endTime
        case weekday
    }

    init(id: Int?, storeGuid: String?, startTime: String?, endTime: String?, weekday: String?) {
        self.id = id
        self.storeGuid = storeGuid
        self.startTime = startTime
        self.endTime = endTime
        self.weekday = weekday
    }
}
class GECStoreImage: Codable {
    let id: Int?
    let storeGuid: String?
    let imageType: Int?
    let path: String?
    let url: String?
    let imageTypeStr: String?

    enum CodingKeys: String, CodingKey {
        case id
        case storeGuid
        case imageType
        case path
        case url
        case imageTypeStr
    }

    init(id: Int?, storeGuid: String?, imageType: Int?, path: String?, url: String?, imageTypeStr: String?) {
        self.id = id
        self.storeGuid = storeGuid
        self.imageType = imageType
        self.path = path
        self.url = url
        self.imageTypeStr = imageTypeStr
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gECStoreDiscountListModel = try? newJSONDecoder().decode(GECStoreDiscountListModel.self, from: jsonData)

// MARK: - GECStoreDiscount
class GECStoreDiscountModel: Codable {
    let id: Int?
    let storeGuid: String?
    let type: Int?
    let threshold: Double?
    let discount: Double?
    let enabled: Int?
    let startTime: String?
    let endTime: String?
    let createTime: String?
    let updateTime: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case storeGuid = "storeGuid"
        case type = "type"
        case threshold = "threshold"
        case discount = "discount"
        case enabled = "enabled"
        case startTime = "startTime"
        case endTime = "endTime"
        case createTime = "createTime"
        case updateTime = "updateTime"
    }

    init(id: Int?, storeGuid: String?, type: Int?, threshold: Double?, discount: Double?, enabled: Int?, startTime: String?, endTime: String?, createTime: String?, updateTime: String?) {
        self.id = id
        self.storeGuid = storeGuid
        self.type = type
        self.threshold = threshold
        self.discount = discount
        self.enabled = enabled
        self.startTime = startTime
        self.endTime = endTime
        self.createTime = createTime
        self.updateTime = updateTime
    }
}

typealias GECStoreDiscountListModel = [GECStoreDiscountModel]
