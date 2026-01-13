import Foundation

struct RequestModel: Codable {
    let deviceId: String?
    let page: String?
    let deviceType: String?
    let number: String?
    let lang: String
    
    enum CodingKeys: String, CodingKey {
        case deviceId   = "device_id"
        case page
        case deviceType = "device_type"
        case number
        case lang
    }
    
    init(deviceId: String? = nil, page: String? = nil, deviceType: String? = nil, number: String? = nil, lang: String = "en") {
        self.deviceId = deviceId
        self.page = page
        self.deviceType = deviceType
        self.number = number
        self.lang = lang
    }
}

