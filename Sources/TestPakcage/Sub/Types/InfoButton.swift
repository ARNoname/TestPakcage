import SwiftUI

@MainActor
enum InfoButton: String {
    case privacyPolicy
    case termsOfService
    case restore
    
    var title: String {
        switch self {
        case .privacyPolicy:   return AppConstants.privacyPolicyText
        case .termsOfService:  return AppConstants.termsOfUseText
        case .restore:         return AppConstants.restoreText
        }
    }
}

