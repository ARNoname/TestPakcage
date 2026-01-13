import SwiftUI

struct SilentRSOC: Codable {
    var isEnabled: Bool
    var isSponsorPageVisible: Bool
    var links: PaywallLink?
    
    init(isEnabled: Bool = false, isSponsorPageVisible: Bool = false, links: PaywallLink? = nil) {
        self.isEnabled = isEnabled
        self.isSponsorPageVisible = isSponsorPageVisible
        self.links = links
    }
}
