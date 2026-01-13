import SwiftUI

@MainActor
enum WebViewType: String, CaseIterable, @MainActor Identifiable  {

    case link_1
    case link_2
    case link_3
    
    var url: String {
        switch self {
        case .link_1: return AppConfig.shared.links.link_1 ?? ""
        case .link_2: return AppConfig.shared.links.link_2 ?? ""
        case .link_3: return AppConfig.shared.links.link_3 ?? ""
        }
    }
    
    var id: String { self.rawValue }
    
    static let linkText_1 = AppConfig.shared.links.linkText_1
    static let linkText_2 = AppConfig.shared.links.linkText_2
    static let linkText_3 = AppConfig.shared.links.linkText_3
    static let linkText_4 = AppConfig.shared.links.linkText_4
}

