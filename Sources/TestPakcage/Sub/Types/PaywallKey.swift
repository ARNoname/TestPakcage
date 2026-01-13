import SwiftUI

enum PaywallKey: String, Identifiable {
    case first
    case second
    case third
    case specialOfferLT
    case specialOfferW
    case bob
    case emptySub
    
    var onbordKey: String {
        switch self {
        case .first:  return "o_1"
        case .second: return "o_2"
        case .third:  return "o_3"
        case .bob:    return "o_r"
        default:      return ""
        }
    }
    
    var paywallKey: String {
        switch self {
        case .first:            return "p_1"
        case .second:           return "p_2"
        case .third:            return "p_3"
        case .specialOfferLT:   return "p_lt_so"
        case .specialOfferW:    return "p_w_so"
        case .emptySub:         return "p_nosub"
        case .bob:              return "p_r"
        }
    }
    
    var id: String { self.rawValue }
}

