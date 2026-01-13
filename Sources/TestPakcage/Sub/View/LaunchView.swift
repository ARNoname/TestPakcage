
import SwiftUI

#if canImport(View_Ext)
import View_Ext

#if canImport(Lottie)
import Lottie
 
public struct LaunchView<LaunchContent: View>: View {
    
    @EnvironmentObject var analyticsManager: SendManager
    @EnvironmentObject var managerIAP: ManagerIAP
    @EnvironmentObject var subVM: ScreensVM
   
    @State private var scaleEffect: Double = 0
    @State private var isAnimating: Bool = true
    @State private var showTechService: Bool = false
   
    @State var config = AppConfig.shared
    
    @Binding var showPayWall: Bool
    public var launchDuration: Double
    @ViewBuilder var launchView: () -> LaunchContent
    
    public init(
        showPayWall: Binding<Bool>,
        launchDuration:Double = 0,
        @ViewBuilder launchView: @escaping () -> LaunchContent
    ) {
        _showPayWall = showPayWall
        self.launchView = launchView
        self.launchDuration = launchDuration
    }
    
    public var body: some View {
        ZStack {
        launchView()
//            Color.white.ignoresSafeArea()
//            
//            HStack(spacing: 8) {
//                Image("logoIcon")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 45, height: 40)
//                Text("AppName")
//                    .fontApp(.bold, 40)
//            }
//            
//            LottieView(animationName: "Trail loading")
//                .frame(width: 120, height: 120)
//                .vAlig(.bottom)
        }
        .overlay {
            if showTechService {
                TechServiceView()
                    .transition(.move(edge: .trailing))
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(launchDuration))
            
            await analyticsManager.sendStatus()
                
            await UpdateConfig()
            
            await analyticsManager.sendViewNumber(pageNumber: subVM.currentNumberPage)
            await managerIAP.updateProduct()
            
            try? await Task.sleep(for: .seconds(launchDuration))
            
            withAnimation {
                if !analyticsManager.showUpdateAlert {
                    if !subVM.isFirstLaunch && managerIAP.subEndDate < .now {
                        self.showPayWall = true
                    }
                    
                    if config.techService.isEnabled == true {
                        withAnimation{
                            showTechService.toggle()
                        }
                    } else {
                        if subVM.isFirstLaunch {
                            subVM.flow = .onboarding
                        } else {
                            subVM.flow = .main
                        }
                    }
                }
            }
        }
        .alert(isPresented: $analyticsManager.showUpdateAlert) {
            Alert(
                title: Text("A new version of the app is available"),
                message: Text("Please update to continue"),
                dismissButton: .default(Text("Update Now"), action: {
                    if let url = URL(string: AppConstants.appID) {
                        UIApplication.shared.open(url)
                    }
                })
            )
        }
        .onDisappear{
            isAnimating = false
        }
    }
    
    private func UpdateConfig() async {
     
        if let analityc = analyticsManager.modelResponse  {
            
//            self.config.payType = analityc.onboarding == PaywallKey.bob.onbordKey ? .bob : .standard
//            self.config.onboardKey = analityc.onboarding ?? ""
//            self.config.paywallKey = analityc.paywall ?? ""
            
            self.subVM.pageOnbCount()
            
            self.config.paywallModel = analityc.localization?.paywallScreen ?? PaywallData()
            self.config.showErrorAlert = true
            
            self.config.splashModel = analityc.localization?.splash ?? Splash()
            self.config.specialOfferModel = analityc.localization?.specialOffer ?? SpecialOffer()
            
            self.config.links = analityc.localization?.appLinks ?? PaywallLink()
            self.config.silentRSOC = analityc.localization?.silentRSOC ?? SilentRSOC()
            self.config.onPaywallCloseKey = analityc.localization?.paywallScreen?.onPaywallClose ?? ""
            
            self.config.techService = analityc.localization?.techService ?? TechService()
            
            await FetchSpecialData(
                onbKey: self.config.onboardKey,
                pwKey: self.config.paywallModel.swipeActionPaywallKey,
                type: .swipe
            )
            
            await FetchSpecialData(
                onbKey: self.config.onboardKey,
                pwKey: self.config.paywallModel.closeActionPaywallKey,
                type: .closePaywall
            )
            
            await FetchSpecialData(
                onbKey: self.config.onboardKey,
                pwKey: self.config.paywallModel.closeActionPaymentPopUpKey,
                type: .closePaymentPopUp
            )
            
            
            if self.config.paywallKey == PaywallKey.emptySub.paywallKey {
                if subVM.isFirstLaunch {
                    subVM.noSub = false
                }else {
                    subVM.noSub = true
                }
            } else {
                subVM.noSub = false
            }
        } else {
            self.subVM.pageOnbCount()
        }
    }
    
    private func FetchSpecialData(onbKey: String, pwKey: String?, type: SpecialOfferType) async {
     
         if let actionPaywallKey = pwKey,
            !actionPaywallKey.isEmpty {
             
             if let specialConfig = await analyticsManager.fetchSwipePaywallConfig(
                 onboardingKey: onbKey,
                 paywallKey: actionPaywallKey
             ) {
                 SelectPaywallType(type: type, key: actionPaywallKey)
     
                 switch type {
                 case .swipe:
                     self.config.swipeSpecialOffer = specialConfig.localization?.specialOffer ?? SpecialOffer()
                
                 case .closePaywall:
                     self.config.closePaywallSpecialOffer = specialConfig.localization?.specialOffer ?? SpecialOffer()
                 
                 case .closePaymentPopUp:
                     self.config.closePaymentPopUpSpecialOffer = specialConfig.localization?.specialOffer ?? SpecialOffer()
                  
                 }
             } else {
                 SelectPaywallType(type: type, key: self.config.paywallKey)
             }
         } else {
             SelectPaywallType(type: type, key: self.config.paywallKey)
         }
     }
     
    private func SelectPaywallType(type: SpecialOfferType, key: String) {
      
         switch type {
         case .swipe:             self.config.swipePaywallKey = key
         case .closePaywall:      self.config.closePaywallXmarkKey = key
         case .closePaymentPopUp: self.config.closePaymentPopUp = key
         }
     }
}
#endif
#endif
