import SwiftUI
import Combine

@MainActor
public final class ScreensVM: ObservableObject {
    static let shared = ScreensVM()
    
    @AppStorage("noSub") var noSub = false
//    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    @Published var isFirstLaunch = true
    @AppStorage("isSponsorHid") var isSponsorHidden: Bool = false
    @Published var flow: AppFlowType = .launch
    
    @Published var isTrialFree: Bool = false {
        didSet {
            selectProduct = .productWeeklyTrial
        }
    }
    
    @Published var selectProduct = ProductType.productWeeklyTrial
    @Published var selectedPlan: SubPlan = .weeklyTrial
    @Published var isProgressAnimating: Bool = false
    
    @Published private(set) var isLastPage: Bool = false
    @Published var showPaywall: Bool = false
    
    @Published var isSpecialOffer: Bool = false
    @Published var selectedLink: Int = 0
    @Published var isSilentOpacity: Bool = false
    @Published var isSilentSpecialOffer: Bool = false
    @Published var isShowTimer: Bool = false
    @Published var clickedURL:String = ""
    
    @Published public var currentPage: Int
    @Published public var pageItem: Int
    
    public var pageCount: Int {
        pageItem + 1
    }
    
    private let config = AppConfig.shared
    
    public init(
        currentPage: Int = 0,
        pageCount: Int = 0,
    ){
        self.currentPage = currentPage
        self.pageItem = pageCount
    }
    
    var currentNumberPage: Int {
        currentPage + 1
    }
    
//MARK: -Onborad Bob
    func nextPage() {
        if currentPage == pageItem {
            if config.paywallKey == PaywallKey.emptySub.paywallKey {
                noSub = true
                isFirstLaunch = false
            } else {
                noSub = false
                isLastPage = true
                flow = .main
                showPaywall = true
            }
        }
        
        guard !isLastPage else { return }
        currentPage += 1
    }
    
    func pageOnbCount() {
        switch config.onboardKey {
        case PaywallKey.first.onbordKey:   self.pageItem = AppConstants.firstOnbPage
        case PaywallKey.second.onbordKey:  self.pageItem = AppConstants.secondOnbPage ?? 0
        case PaywallKey.third.onbordKey:   self.pageItem = AppConstants.thirdOnbPage ?? 0
        case PaywallKey.bob.onbordKey:     self.pageItem = AppConstants.bobOnbPage
        default:                           self.pageItem = 0
        }
    }
}

