
import SwiftUI

@MainActor
public class AppConfig {
    @MainActor  static let shared = AppConfig()

    public var onboardKey: String
    public var paywallKey: String
    public var payType: PaywallType
    
    public init(
        onboardKey: String = "o_1",
        paywallKey: String = "p_1",
        payType: PaywallType = .standard
    ) {
        self.onboardKey = onboardKey
        self.paywallKey = paywallKey
        self.payType    = payType
    }
    
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
