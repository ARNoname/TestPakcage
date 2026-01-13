import SwiftUI

struct Splash: Codable {
    let firstText: String?
    let secondText: String?
    let dayText: String?
    
    init(
        firstText: String? = nil,
        secondText: String? = nil,
        dayText: String? = nil) {
            
        self.firstText = firstText
        self.secondText = secondText
        self.dayText = dayText
    }
}

