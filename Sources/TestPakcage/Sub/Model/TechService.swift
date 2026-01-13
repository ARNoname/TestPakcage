import SwiftUI

struct TechService: Codable {
    var isEnabled: Bool
    var timeService: String
        
    init(isEnabled: Bool = false, timeService: String = ""){
        self.isEnabled = isEnabled
        self.timeService = timeService
    }
}

