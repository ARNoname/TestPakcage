import SwiftUI

struct PaywallLink: Codable {
    let link_1: String?
    let link_2: String?
    let link_3: String?
    let linkText_1: LinkText?
    let linkText_2: LinkText?
    let linkText_3: LinkText?
    let linkText_4: LinkText?
        
    init(
        link_1: String? = nil,
        link_2: String? = nil,
        link_3: String? = nil,
        linkText_1: LinkText? = nil,
        linkText_2: LinkText? = nil,
        linkText_3: LinkText? = nil,
        linkText_4: LinkText? = nil
    ) {
        self.link_1 = link_1
        self.link_2 = link_2
        self.link_3 = link_3
        self.linkText_1 = linkText_1
        self.linkText_2 = linkText_2
        self.linkText_3 = linkText_3
        self.linkText_4 = linkText_4
    }
}

struct LinkText: Codable {
    let title: String?
    let subTitle: String?
}
