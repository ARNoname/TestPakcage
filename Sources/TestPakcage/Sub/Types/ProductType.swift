import SwiftUI

@MainActor
public enum ProductType: String, Codable, CaseIterable {
    
    case productWeekly
    case productWeeklyTrial
    case productMonthly
    case productYearly
    case productLifetime
    case productSpecialOfferWeek
    
    var productID: String {
        switch self {
        case .productWeekly:            return AppConstants.weeklyID
        case .productWeeklyTrial:       return AppConstants.weeklyTrialID
        case .productMonthly:           return AppConstants.monthlyID
        case .productYearly:            return AppConstants.yearlyID
        case .productLifetime:          return AppConstants.lifetimeID
        case .productSpecialOfferWeek:  return AppConstants.specialOfferWeekID
        }
    }
        
    var hasTrial: Bool {
        switch self {
        case .productWeeklyTrial:
            return true
        default:
            return false
        }
    }
}
