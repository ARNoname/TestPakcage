
import SwiftUI

@MainActor
public struct AppConstants {
    
    public static var RCatApiKey: String            = ""
    public static var RCatID: String                = ""
    
    public static var weeklyTrialID: String         = "" //"WeeklyTrial"
    public static var weeklyID: String              = "" //"Weekly"
    public static var monthlyID: String             = "" //"Monthly"
    public static var yearlyID: String              = "" //"Yearly"
    public static var lifetimeID: String            = "" //"Lifetime"
    public static var specialOfferWeekID: String    = "" //"SpecialOfferWeek"
    
    public static var weeklyTrial: String           = "WeeklyTrial"
    public static var weekly: String                = "Weekly"
    public static var monthly: String               = "Monthly"
    public static var yearly: String                = "Yearly"
    public static var lifetime: String              = "Lifetime"
    public static var specialOfferWeek: String      = "SpecialOfferWeek"
    
    public static var appID: String                 = "https://apps.apple.com/app/id"
    
    public static var privacyPolicy: String         = "https://"
    public static var termsOfUse: String            = "https://"
    public static var supportEmail: String          = "https://"
    
    public static var termsOfUseText: String        = "Terms of Use"
    public static var privacyPolicyText: String     = "Privacy Policy"
    public static var restoreText: String           = "Restore"
    
    public static var bigBossValue: String          = "key"
    
    public static var fullUrl: String               = ""
    
    public static var firstOnbPage: Int             = 9
    public static var secondOnbPage: Int?           = nil
    public static var thirdOnbPage: Int?            = nil
    public static var bobOnbPage: Int               = 2
    
    public static var silentOpacity: CGFloat        = 0.2//0.005
    public static var silentPage1: [Double]         = [10, 65]
    public static var silentPage2: Double           = 140
   
    public static var xmarkPostion: XmarkPostion = .init(
        x: 16,
        y: 60,
        alignment: .leading,
        color: .gray
    )
    
}




