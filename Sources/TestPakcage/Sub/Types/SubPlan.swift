import SwiftUI

@MainActor
enum SubPlan: CaseIterable {
    case weeklyTrial
    case weekly
    case monthly
    case yearly
    case lifetime
    case specialOfferWeek
    
    var title: String {
        switch self {
        case .weeklyTrial:        return AppConstants.weeklyTrial
        case .weekly:             return AppConstants.weekly
        case .monthly:            return AppConstants.monthly
        case .yearly:             return AppConstants.yearly
        case .lifetime:           return AppConstants.lifetime
        case .specialOfferWeek:   return AppConstants.specialOfferWeek
        }
    }
}
