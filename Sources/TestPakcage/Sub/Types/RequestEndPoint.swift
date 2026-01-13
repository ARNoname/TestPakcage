
import Foundation

@MainActor
enum RequestEndPoint: String {
    case status                       = "/information"
    case view                         = "/subscription/view"
    case conversion                   = "/subscription/conversion"
    case lockedSwipe                  = "/subscription/locked_swipe"
    case rsocScreen1View              = "/subscription/rsoc_screen_1_view"
    case rsocScreen2View              = "/subscription/rsoc_screen_2_view"
    case rsocScreen3View              = "/subscription/rsoc_screen_3_view"
    case rsocCrossClick               = "/subscription/rsoc_cross_click"
    case specialOfferView             = "/subscription/special_offer_view"
    case specialOfferCtaClick         = "/subscription/special_offer_cta_click"
    case specialOfferCrossClick       = "/subscription/special_offer_cross_click"
    case paymentPopupClosed           = "/subscription/payment_popup_closed"
    case silentRSOCScreen1            = "/subscription/silent_rsoc_screen_1_view"
    case silentRSOCScreen2            = "/subscription/silent_rsoc_screen_2_view"
    case silentRSOCSponsorPageLoad    = "/subscription/silent_rsoc_sponsored_page_load"
    case silentRSOCSponsorPageVisible = "/subscription/silent_rsoc_sponsored_page_visible"
    case swipePaywallConfig           = "/config"
    
    var fullURL: String {
        return AppConstants.fullUrl + self.rawValue
    }
}
