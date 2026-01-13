import SwiftUI

struct SpecialOffer: Codable {
    let title: String?
    let subtitle: String?
    let image: String?
    let promoText1: String?
    let promoText2: String?
    let promoText3: String?
    let amountText1: String?
    let amountText2: String?
    let descriptionText1: String?
    let descriptionText2: String?
    let buttonText: String?
    let subButtonText: String?
    
    init(
        title: String? = nil,
        subtitle: String? = nil,
        image: String? = nil,
        promoText1: String? = nil,
        promoText2: String? = nil,
        promoText3: String? = nil,
        amountText1: String? = nil,
        amountText2: String? = nil,
        descriptionText1: String? = nil,
        descriptionText2: String? = nil,
        buttonText: String? = nil,
        subButtonText: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.promoText1 = promoText1
        self.promoText2 = promoText2
        self.promoText3 = promoText3
        self.amountText1 = amountText1
        self.amountText2 = amountText2
        self.descriptionText1 = descriptionText1
        self.descriptionText2 = descriptionText2
        self.buttonText = buttonText
        self.subButtonText = subButtonText
    }
}

