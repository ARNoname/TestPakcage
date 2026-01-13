import Foundation

struct ResponseModel: Codable {
    let status: String?
    let onboarding: String?
    let paywall: String?
    let view: String?
    let conversion: String?
    let viewNumber: String?
    let localization: LocalizContainer?
    let lockedSwipe: String?
    let rsocScreen1View: String?
    let rsocScreen2View: String?
    let rsocScreen3View: String?
    let rsocCrossClick: String?
    let specialOfferView: String?
    let specialOfferCtaClick: String?
    let specialOfferCrossClick: String?
    let paymentPopupClosed: String?
    let silentRSOCScreen1: String?
    let silentRSOCScreen2: String?
    let silentRSOCSponsorPageLoad: String?
    let silentRSOCSponsorPageVisible: String?
   
     enum CodingKeys: String, CodingKey {
         case status
         case onboarding
         case paywall
         case view
         case conversion
         case viewNumber                   = "view_number"
         case localization
         case lockedSwipe                  = "locked_swipe"
         case rsocScreen1View              = "rsoc_screen_1_view"
         case rsocScreen2View              = "rsoc_screen_2_view"
         case rsocScreen3View              = "rsoc_screen_3_view"
         case rsocCrossClick               = "rsoc_cross_click"
         case specialOfferView             = "special_offer_view"
         case specialOfferCtaClick         = "special_offer_cta_click"
         case specialOfferCrossClick       = "special_offer_cross_click"
         case paymentPopupClosed           = "payment_popup_closed"
         case silentRSOCScreen1            = "silent_rsoc_screen_1_view"
         case silentRSOCScreen2            = "silent_rsoc_screen_2_view"
         case silentRSOCSponsorPageLoad    = "silent_rsoc_sponsored_page_load"
         case silentRSOCSponsorPageVisible = "silent_rsoc_sponsored_page_visible"
     }
    
     init(
         status: String? = nil,
         onboarding: String? = nil,
         paywall: String? = nil,
         view: String? = nil,
         conversion: String? = nil,
         viewNumber: String? = nil,
         localization: LocalizContainer? = nil,
         lockedSwipe: String? = nil,
         rsocScreen1View: String? = nil,
         rsocScreen2View: String? = nil,
         rsocScreen3View: String? = nil,
         rsocCrossClick: String? = nil,
         specialOfferView: String? = nil,
         specialOfferCtaClick: String? = nil,
         specialOfferCrossClick: String? = nil,
         paymentPopupClosed: String? = nil,
         silentRSOCScreen1: String? = nil,
         silentRSOCScreen2: String? = nil,
         silentRSOCSponsorPageLoad: String? = nil,
         silentRSOCSponsorPageVisible: String? = nil
     ) {
         self.status = status
         self.onboarding = onboarding
         self.paywall = paywall
         self.view = view
         self.conversion = conversion
         self.viewNumber = viewNumber
         self.localization = localization
         self.lockedSwipe = lockedSwipe
         self.rsocScreen1View = rsocScreen1View
         self.rsocScreen2View = rsocScreen2View
         self.rsocScreen3View = rsocScreen3View
         self.rsocCrossClick = rsocCrossClick
         self.specialOfferView = specialOfferView
         self.specialOfferCtaClick = specialOfferCtaClick
         self.specialOfferCrossClick = specialOfferCrossClick
         self.paymentPopupClosed = paymentPopupClosed
         self.silentRSOCScreen1 = silentRSOCScreen1
         self.silentRSOCScreen2 = silentRSOCScreen2
         self.silentRSOCSponsorPageLoad = silentRSOCSponsorPageLoad
         self.silentRSOCSponsorPageVisible = silentRSOCSponsorPageVisible
     }
}
