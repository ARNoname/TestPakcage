import SwiftUI

struct PaywallData: Codable {
    let delay: Int
    let onSwipeAction: String?
    let swipeActionPaywallKey: String?
    let onPaywallClose: String?
    let closeActionPaywallKey: String?
    let onPaymentsPooUpClose: String?
    let closeActionPaymentPopUpKey: String?
    
    init(
  
        delay: Int = 0,
        links: PaywallLink? = nil,
        version: String? = nil,
        onSwipeAction: String? = nil,
        swipeActionPaywallKey: String? = nil,
        onPaywallClose: String? = nil,
        closeActionPaywallKey: String? = nil,
        onPaymentsPooUpClose: String? = nil,
        closeActionPaymentPopUpKey: String? = nil
    ) {
            
        self.delay = delay
        self.onSwipeAction = onSwipeAction
        self.swipeActionPaywallKey = swipeActionPaywallKey
        self.onPaywallClose = onPaywallClose
        self.closeActionPaywallKey = closeActionPaywallKey
        self.onPaymentsPooUpClose = onPaymentsPooUpClose
        self.closeActionPaymentPopUpKey = closeActionPaymentPopUpKey
    }
    
}

