
import SwiftUI

@MainActor
class AppConfig {
    static let shared = AppConfig()

    var onboardKey: String            = AppConstants.onboardKey
    var paywallKey: String            = AppConstants.paywallKey
    var payType: PaywallType          = AppConstants.payType
    var paywallModel                  = PaywallData()
    var swipePaywallModel             = PaywallData()
    var swipePaywallKey: String       = ""
    var closePaywallXmarkKey: String  = ""
    var closePaymentPopUp: String     = ""
    var specialOfferModel             = SpecialOffer()
    var swipeSpecialOffer             = SpecialOffer()
    var closePaywallSpecialOffer      = SpecialOffer()
    var closePaymentPopUpSpecialOffer = SpecialOffer()
    var splashModel                   = Splash()
    var links                         = PaywallLink()
    var silentRSOC                    = SilentRSOC()
    var onPaywallCloseKey             = ""
    var techService                   = TechService()
    var showErrorAlert: Bool          = false
}
