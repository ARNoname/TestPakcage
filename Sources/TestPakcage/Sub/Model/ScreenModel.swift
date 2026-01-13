import SwiftUI

struct ScreenModel {
    let title: String
    let subTitle: String
    let image: String
    let buttonTitle: String
    let buttonSubTitle: String
    let descriptionTitle: String
    
    init(
        title: String = "",
        subTitle: String = "",
        image: String = "",
        buttonTitle: String = "",
        buttonSubTitle: String = "",
        descriptionTitle: String = "") {
            
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.buttonTitle = buttonTitle
        self.buttonSubTitle = buttonSubTitle
        self.descriptionTitle = descriptionTitle
    }
}

