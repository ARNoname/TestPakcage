
import SwiftUI

@MainActor
public struct AppConstants {
    //----------------------------------- ⚠️ REQUIRED ⚠️--------------------------------------//
    
    //MARK: - Need add value from RevenuCat
    
    public static var RCatApiKey: String            = "" //qw9808q0w09809qdadfa90w
    public static var RCatID: String                = "" //Pro, Premium ...

    //MARK: - Need add productID keys from AppStoreConnect
    
    public static var weeklyTrialID: String         = "" //"WeeklyTrial"
    public static var weeklyID: String              = "" //"Weekly"
    public static var monthlyID: String             = "" //"Monthly"
    public static var yearlyID: String              = "" //"Yearly"
    public static var lifetimeID: String            = "" //"Lifetime"
    public static var specialOfferWeekID: String    = "" //"SpecialOfferWeek"
    
    //MARK: - Need set appID from AppStoreConnect
    
    public static var appID: String                 = "https://apps.apple.com/app/id6756785542"
    
    //MARK: - Need add links
    public static var privacyPolicy: String         = "https://"
    public static var termsOfUse: String            = "https://"
    public static var supportEmail: String          = "https://"
    
    //MARK: - Need add link for Paywaller
    
    public static var fullUrl: String               = "" //https://assistifyAppName.app/appName
    
    //----------------------------------- OPTIONS -------------------------------------------//
    
    // These values are set by default, and if you don’t need to change them, then don’t change anything.
    
    public static var weeklyTrial: String           = "WeeklyTrial"
    public static var weekly: String                = "Weekly"
    public static var monthly: String               = "Monthly"
    public static var yearly: String                = "Yearly"
    public static var lifetime: String              = "Lifetime"
    public static var specialOfferWeek: String      = "SpecialOfferWeek"
    
    public static var termsOfUseText: String        = "Terms of Use"
    public static var privacyPolicyText: String     = "Privacy Policy"
    public static var restoreText: String           = "Restore"
    
    // If you want to add Big Boss to your project, then set the key that you will need to enter into the text field.
    
    public static var bigBossValue: String          = "" //sdfkl23kl23l2d23
    
    // This is how many seconds it takes for LaunchView to close.
    
    public static var launchDuration: Double        = 2.5
    
    // For each onboarding, you need to set how many pages your onboarding will have, starting from index 0.
    // For example, if your onboarding has 4 pages, set the value to 3.
    
    public static var bobOnbPage: Int               = 2
    public static var firstOnbPage: Int             = 9
    public static var secondOnbPage: Int?           = nil
    public static var thirdOnbPage: Int?            = nil
    
    //Each project needs to be configured individually, since the button on the onboarding screen will always have a different bottom offset. These changes allow you to adjust the buttons so they are positioned in the correct place.
    // This value must not be changed. Only if you need to adjust the silent buttons can you set the value to 0.2–0.3.
    // ⚠️Important!! Don’t forget to set the value back to 0.005.
    
    public static var silentPage1: [Double]         = [10, 65] // random padding content - page number 1
    public static var silentPage2: Double           = 140      // padding onboard button - page number 2
    public static var silentOpacity: CGFloat        = 0.005
    
    // These values will be initialized and updated every time the app starts in LaunchView.
    // If you need to design the onboarding UI or a Paywall, set your own values that you need.
    // However, to do this, comment out these keys in LaunchView → UpdateConfig so they don’t receive new values.
    // ⚠️ Important! Don’t forget to uncomment them again afterward.
    
    public static var onboardKey: String            = "o_r"
    public static var paywallKey: String            = "p_1"
    public static var payType: PaywallType          = .bob
   
    // If you need to change the color or move the xmark button to a different position, update these values.
    
    public static var xmarkPostion: XmarkPostion = .init(
        x: 16,
        y: 60,
        alignment: .leading, //or .trailing
        color: .gray
    )
    
    // if need only Onboarding, without Paywall, set value false
    public static var showPaywall: Bool            = true
    
    // If you need to work on the UI and want the app to always show the onboarding, set the value to true.
    // ⚠️ Important: don’t forget to set it back to false before release.
    public static var disableFirstLauch: Bool      = false
}




