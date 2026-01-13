import Combine
import StoreKit
import SwiftUI
#if canImport(RevenueCat)
import RevenueCat
#endif

@MainActor
public class ManagerIAP: ObservableObject {
    
    @Published private(set) var error = ""
    @Published private(set) var isPurchasing = false
    
    @Published var showAlert = false
    @Published var weeklyTrial = ""
    @Published var weeklyPrice = ""
    @Published var monthlyPrice = ""
    @Published var yearlyPrice = ""
    @Published var lifeTimePrice = ""
    @Published var soWeekPrice = ""
    
    @Published var weeklyPriceDecimal: Decimal  = 0.0
    @Published var monthlyPriceDecimal: Decimal  =  0.0
    @Published var yearlyPriceDecimal: Decimal =  0.0
    
    @Published var isTriggerRSOC: Bool = false
    @Published var isTriggerSO: Bool = false
    @Published var isSponsorPopUp: Bool = false

    @AppStorage("subEndDate") private var subEndDateInterval = Date.now.timeIntervalSince1970
    @AppStorage("RateUs") private var firstRateUs: Bool = false
    @AppStorage("bigBoss") public var bigBoss = false
   
    private var offerings: Offerings?
    private let config = AppConfig.shared
    private let subVM = ScreensVM.shared
    
    var pricePerDay: PricePerDay {
        let weekly = (weeklyPriceDecimal / 7.0).rounded(toPlaces: 2)
        let monthly = (monthlyPriceDecimal / 30.0).rounded(toPlaces: 2)
        let yearly = (yearlyPriceDecimal / 365.0).rounded(toPlaces: 2)
        return PricePerDay(weekly: weekly, monthly: monthly, yearly: yearly)
    }
    
    var subEndDate: Date {
        get {
            if ScreensVM().noSub {
                return Date.now.addingTimeInterval(86400)
            } else {
                return Date(timeIntervalSince1970: subEndDateInterval)
            }
        }
        set {
            subEndDateInterval = newValue.timeIntervalSince1970
        }
    }
     
    public init() {
        Task { await initSetup() }
    }
    
//MARK: Init setup
    private func initSetup() async {
  
        do {
            Purchases.logLevel = .debug
            Purchases.configure(withAPIKey: AppConstants.RCatApiKey)
            
            offerings = try await Purchases.shared.offerings()
            
            if let offering = offerings?.current {
                
                if let product = offering.package(identifier: "WeeklyTrial") {
                    weeklyTrial = product.localizedPriceString
                    weeklyPriceDecimal = product.storeProduct.price
                }
                
                if let product = offering.weekly {
                    weeklyPrice = product.localizedPriceString
                    weeklyPriceDecimal = product.storeProduct.price
                }
                if let product = offering.monthly {
                    monthlyPrice = product.localizedPriceString
                    monthlyPriceDecimal = product.storeProduct.price
                }
                if let product = offering.annual {
                    yearlyPrice = product.localizedPriceString
                    yearlyPriceDecimal = product.storeProduct.price
                }
                if let product = offering.lifetime {
                    lifeTimePrice = product.localizedPriceString
                }
                if let product = offering.package(identifier: "SpecialOfferWeekly") {
                    soWeekPrice = product.localizedPriceString
                }
            }
            
            await self.restore()
            await self.updateProduct()
        } catch {
            print(error.localizedDescription)
        }
    }

//MARK: -Purchase product
    func purchaseProduct(productType: ProductType) async {
    
        isPurchasing = true
       
        do {
            if let offering = offerings?.current {
                
                let package: Package?
                
                switch productType {
                case .productWeeklyTrial:       package = offering.package(identifier: "WeeklyTrial")
                case .productWeekly:            package = offering.weekly
                case .productMonthly:           package = offering.monthly
                case .productYearly:            package = offering.annual
                case .productLifetime:          package = offering.lifetime
                case .productSpecialOfferWeek:  package = offering.package(identifier: "SpecialOfferWeekly")
                }
                
                if let package = package {
                    let result = try await Purchases.shared.purchase(package: package)
                   
                    if result.customerInfo.entitlements[AppConstants.RCatID]?.isActive == true {
                        await MainActor.run {
                            self.subEndDate = result.customerInfo.entitlements[AppConstants.RCatID]?.expirationDate ?? .now
                        }
                   
                        await SendManager.shared.sendConversion()
                        await self.showRating()
                    } else {
                        await SendManager.shared.sendPaymentPopupClosed()
                        await handleClosedPopUp()
                    }
                }
            }
        } catch {
            
            if let error = error as? RevenueCat.ErrorCode {
                if config.showErrorAlert && error == .purchaseCancelledError {
                    await MainActor.run {
                        showAlert = true
                        
                    }
                }
            }
            print(error.localizedDescription)
        }
        await MainActor.run {
            isPurchasing = false
        }
    }
    
//MARK: -Restore
    func restore() async {

        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            if customerInfo.entitlements[AppConstants.RCatID]?.isActive == true {
                await MainActor.run {
                    self.subEndDate = customerInfo.entitlements[AppConstants.RCatID]?.expirationDate ?? .now
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
//MARK: -Update product
    func updateProduct() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            
            if let activeEntitlement = customerInfo.entitlements[AppConstants.RCatID], activeEntitlement.isActive {
                
                let productIdentifier = activeEntitlement.productIdentifier
                
                await MainActor.run {
                    switch productIdentifier {
                    case AppConstants.weeklyTrialID:
                        subVM.selectProduct = .productWeeklyTrial
                        subVM.selectedPlan = .weeklyTrial
                        subVM.isTrialFree = true
                        
                    case AppConstants.weeklyID:
                        subVM.selectProduct = .productWeekly
                        subVM.selectedPlan = .weekly
                        subVM.isTrialFree = false
                        
                    case AppConstants.monthlyID:
                        subVM.selectProduct = .productMonthly
                        subVM.selectedPlan = .monthly
                        subVM.isTrialFree = false
                        
                    case AppConstants.yearlyID:
                        subVM.selectProduct = .productYearly
                        subVM.selectedPlan = .yearly
                        subVM.isTrialFree = false
                        
                    case AppConstants.lifetimeID:
                        subVM.selectProduct = .productLifetime
                        subVM.selectedPlan = .lifetime
                        subVM.isTrialFree = false
                        
                    case AppConstants.specialOfferWeekID:
                        subVM.selectProduct = .productSpecialOfferWeek
                        subVM.selectedPlan = .specialOfferWeek
                        subVM.isTrialFree = false
                        
                    default:
                        self.setDefaultProduct()
                    }
                    print("Active subscription found: \(subVM.selectProduct.rawValue), Plan: \(subVM.selectedPlan.title)")
                }
            } else {
                await MainActor.run {
                    self.setDefaultProduct()
                    print("Active subscription not found, set default product: \(subVM.selectProduct.rawValue)")
                }
            }
        } catch {
            await MainActor.run {
                self.setDefaultProduct()
                print("Error checking subscription: \(error.localizedDescription)")
            }
        }
    }
    
    
// MARK: - Private Methods
    private func setDefaultProduct() {
        
        subVM.selectProduct = .productWeeklyTrial
        subVM.selectedPlan = .weeklyTrial
    }
    
    private func getPriceForProduct(_ productType: ProductType) -> Decimal {
  
            switch productType {
            case .productWeeklyTrial, .productWeekly:
                return weeklyPriceDecimal
            case .productMonthly:
                return monthlyPriceDecimal
            case .productYearly:
                return yearlyPriceDecimal
                default :return 0
            }
        }
    
    func showRating() async {
        if !firstRateUs {
            if  let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene    {
                SKStoreReviewController.requestReview(in: scene)
            }
            firstRateUs = true
        }
    }
    
    func handleClosedPopUp() async {
        if config.silentRSOC.isSponsorPageVisible && (subVM.isSponsorHidden == false) {
            self.isSponsorPopUp = true
        } else {
            switch AppConfig.shared.paywallModel.onPaymentsPooUpClose {
            case SwipeActionType.rsoc.rawValue:
                withAnimation {
                isTriggerRSOC = true
                }
            case SwipeActionType.specialOffer.rawValue:
                isTriggerSO = true
            default: break
            }
        }
    }
}

public struct PricePerDay {
    let weekly: Decimal
    let monthly: Decimal
    let yearly: Decimal
}

extension Decimal {
    func rounded(toPlaces places: Int) -> Decimal {
        var result = self
        var rounded = Decimal()
        NSDecimalRound(&rounded, &result, places, .plain)
        return rounded
    }
}
