import SwiftUI
#if canImport(View_Ext)
import View_Ext

public struct PaywallView<First: View, Second: View, Third: View, Bob: View>: View {
    
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var networkManager: NetworkVM
    @EnvironmentObject var managerIAP: ManagerIAP
    @ObservedObject var subVM: ScreensVM
    
    @State var showX = false
    @State var isPlayLottie = true
    @State var isTimer = true
    @State var isSpecialOffer = false
    @State var isRSOC = false
    
    @State var selectedURL: WebViewType = .link_1
    @State var swipeCounter = 0
    @State var scaleTryFree = CGSize(width: 0.94, height: 0.94)
    @State var isShowTimer: Bool = true
    @State var isAnimationTrial: Bool = false
    @State var scrollOffset: CGFloat = 0
    
    @State var isTriggerRSOC: Bool = false
    @State var isTriggerSO: Bool = false
    @State var isTriggerRSOCPop: Bool = false
    @State var isTriggerSOPop: Bool = false
    @State var isSponsorPageVisible = false
    
    @State var isActionThirdPaywall: Bool = false
   
    @Binding var showPayWall: Bool
    
    let config = AppConfig.shared
    
    private let first: () -> First
    private let second: () -> Second
    private let third: () -> Third
    private let bob: () -> Bob

    var isTriggerSwipe: Bool {
        if config.silentRSOC.isSponsorPageVisible && (subVM.isSponsorHidden == false) {
            return true
        } else {
            return false
        }
    }
    
    public init(
        subVM: ScreensVM,
        @ViewBuilder first: @escaping () -> First,
        @ViewBuilder second: @escaping () -> Second,
        @ViewBuilder third: @escaping () -> Third,
        @ViewBuilder bob: @escaping () -> Bob,
        showPayWall: Binding<Bool>
    )
    {
        self.subVM = subVM
        self.first = first
        self.second = second
        self.third = third
        self.bob = bob
        _showPayWall = showPayWall
    }
    
   public var body: some View {
        ZStack {
            if config.paywallKey == PaywallKey.bob.paywallKey  {
                    bob() 
            } else {
                if isSpecialOffer {

                    if isTriggerSO || isTriggerRSOC {
                        paywallView(key: config.closePaywallXmarkKey)

                    } else if isTriggerSOPop || isTriggerRSOCPop {
                        paywallView(key: config.closePaymentPopUp)

                    } else {
                        paywallView(key: config.swipePaywallKey)
                    }

                    LaunchSpecialOfferView()
                } else {
                    switch config.paywallModel.onSwipeAction {

                    case SwipeActionType.none.rawValue:
                        paywallView(key: config.paywallKey)

                    case SwipeActionType.rsoc.rawValue:
                        if isTriggerSwipe {
                            PaywallHostingController(
                                content: paywallView(key: config.paywallKey),
                                isActionTriggered: $isSponsorPageVisible )
                        } else {
                            PaywallHostingController(
                                content: paywallView(key: config.paywallKey),
                                isActionTriggered: $isRSOC
                            )
                        }

                    case SwipeActionType.specialOffer.rawValue:
                        if isTriggerSwipe {
                            PaywallHostingController(
                                content: paywallView(key: config.paywallKey),
                                isActionTriggered: $isSponsorPageVisible )
                        } else {
                            PaywallHostingController(
                                content: paywallView(key: config.paywallKey),
                                isActionTriggered: $isSpecialOffer
                            )
                        }

                    default:
                        paywallView(key: config.paywallKey)
                    }

                    if isSponsorPageVisible {
                        WebSilentSponsor()
                    }

                    if isTriggerRSOC || isTriggerRSOCPop {
                        WebViewComponents(
                            selectedURL: $selectedURL,
                            swipeIndex: $swipeCounter,
                            showX: $showX,
                            isShowTimer: $isShowTimer)
                        .padding(.top, 80)
                        .padding(.bottom)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                    }
                }
            }
          
           XmarkButton(
                showX: $showX,
                showPayWall: $showPayWall,
                isHomeIndicator: $isSpecialOffer,
                isSpecialOffer: $isSpecialOffer,
                isSwipeCounter: $swipeCounter,
                isAnimationTrial: $isAnimationTrial,
                isTriggerRSOC: $isRSOC,
                isTriggerSO: $isTriggerSO,
                isTriggerRSOCPop: $isTriggerRSOCPop,
                isTriggerSOPop: $isTriggerSOPop,
                isSponsorPageVisible: $isSponsorPageVisible
            )
            .vAlig(.top, AppConstants.xmarkPostion.y)
            .hAlig(AppConstants.xmarkPostion.alignment, AppConstants.xmarkPostion.x)
            .zIndex(isShowTimer || swipeCounter > 2 ? (swipeCounter > 2 ? 1 : 0) : 1)
                            
            if  isSpecialInfo {
            } else {
                InfoButtonView()
                    .padding(.horizontal, 50)
                    .vAlig(.bottom, 8)

            }
            
            if swipeCounter != 0 {
                PaywallHostingController(
                    content:
                        WebViewComponents(
                        selectedURL: $selectedURL,
                        swipeIndex: $swipeCounter,
                        showX: $showX,
                        isShowTimer: $isShowTimer),
                    isHomeIndicatorHidden: $isSpecialOffer,
                    isActionTriggered: $isRSOC
                )
            }
            
            if isAnimationTrial {
                LaunchSpecialOfferView()
            }
            
            if managerIAP.isPurchasing {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.3)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isSponsorPageVisible ? Color.black : Color.clear )
        .ignoresSafeArea()
        .task {
            await SendManager.shared.sendPaywallView()
            showX = false
            try? await Task.sleep(for: .seconds(config.paywallModel.delay))
            showX = true
        }
        .onChange(of: isRSOC || isSpecialOffer) {_, newValue in
            isSponsorPageVisible = false
        }
        .onChange(of: managerIAP.isSponsorPopUp){_, newValue in
            if newValue == true {
                isSponsorPageVisible = true
            }
        }
        .onChange(of: isSponsorPageVisible) {_, _ in
            if config.silentRSOC.isSponsorPageVisible && (subVM.isSponsorHidden == false) {
                if  subVM.isFirstLaunch {
                    subVM.isSilentOpacity = true
                    subVM.isShowTimer = true
                }
                else {
                    subVM.isFirstLaunch = false
                    showPayWall = false
                }
            }
        }
        .onDisappear{
            managerIAP.isTriggerSO = false
            managerIAP.isTriggerRSOC = false
            isSpecialOffer = false
            isTriggerRSOC = false
            isTriggerSO = false
            isTriggerRSOCPop = false
            isTriggerSOPop = false
            isPlayLottie = false
            showPayWall = false
            isSpecialOffer = false
        }
        .alert("Network disconnected", isPresented: $networkManager.isError) {
            Button("Cancel"){
                networkManager.isError = false
            }
            Button("Open Settings"){
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
                       UIApplication.shared.open(settingsURL)
            }
        }
        .onChange(of: managerIAP.isTriggerSO || managerIAP.isTriggerRSOC) { _, newValue in
            if newValue == managerIAP.isTriggerSO {
                isSpecialOffer = true
                isTriggerSOPop = true

            }
            if newValue == managerIAP.isTriggerRSOC {
                withAnimation{
                    isTriggerRSOCPop = true
                }
            }
        }
        .onChange(of: subVM.isSilentSpecialOffer) { _, newValue in
            isSpecialOffer = true
        }
        .onChange(of: isSpecialOffer) { _, newValue in
            if newValue {
                swipeCounter = 0
                showX = false
                
                Task {
                    await SendManager.shared.sendLockedSwipe()
                    await SendManager.shared.sendSpecialOfferView()
                }
                
                Task {
                    try? await Task.sleep(for: .seconds(config.paywallModel.delay))
                    showX = true
                }
            }
        }
        .onChange(of: swipeCounter) { _, newValue in
            if newValue > 2 {
                showX = true
            }
            Task {
               if !isSpecialOffer {
                   await SendManager.shared.sendLockedSwipe()
                    print("🚨_Locked swipe")
                }
            }
        }
        .onChange(of: isRSOC) { _, newValue in
          
            if swipeCounter < WebViewType.allCases.count {
                swipeCounter += 1
                
                print("Swipe detected, counter: \(swipeCounter)")
                switch swipeCounter {
                case 1:
                    selectedURL = .link_1
                    Task {
                        await SendManager.shared.sendRsocScreen1View()
                        print("🔥_1")
                    }
                case 2:
                    selectedURL = .link_2
                    Task {
                        await SendManager.shared.sendRsocScreen1View()
                        print("🔥_1")
                    }
                case 3:
                    selectedURL = .link_3
                    Task {
                        await SendManager.shared.sendRsocScreen1View()
                        print("🔥_1")
                    }
                default: break
                }
            }
        }
        .onChange(of: scenePhase) {_, newValue in
            switch newValue {
            case .background:
                managerIAP.isTriggerSO = false
                managerIAP.isTriggerRSOC = false
                isSpecialOffer = false
                isTriggerRSOC = false
                isTriggerSO = false
                isTriggerRSOCPop = false
                isTriggerSOPop = false
                isPlayLottie = false
                showPayWall = false
                isSpecialOffer = false
                subVM.isFirstLaunch = false
            default: break
            }
        }
    }
    
    @ViewBuilder
    private func paywallView(key: String) -> some View {
  
        switch key {
        case PaywallKey.first.paywallKey:           first()
        case PaywallKey.second.paywallKey:          second()
        case PaywallKey.third.paywallKey:           third()
        case PaywallKey.specialOfferLT.paywallKey:  PaywallSOLifeTime(specialOfferType: getSpecialOfferType(for: key))
        case PaywallKey.specialOfferW.paywallKey:   PaywallSOWeek(specialOfferType: getSpecialOfferType(for: key))
        default: EmptyView()
        }
    }
    
    private func getSpecialOfferType(for key: String) -> SpecialOfferType {
        switch key {
        case config.swipePaywallKey: .swipe
        case config.closePaywallXmarkKey: .closePaywall
        case config.closePaymentPopUp: .closePaymentPopUp
        default: .swipe
        }
    }
    
    func getSpecialOffer(for type: SpecialOfferType) -> SpecialOffer {
    
        switch type {
        case .swipe:             return config.swipeSpecialOffer
        case .closePaywall:      return config.closePaywallSpecialOffer
        case .closePaymentPopUp: return config.closePaymentPopUpSpecialOffer
        }
    }
    
    private var isSpecialInfo: Bool {
        isSpecialOffer && (config.swipePaywallKey == PaywallKey.specialOfferLT.paywallKey) ||
        isSpecialOffer && (config.swipePaywallKey == PaywallKey.specialOfferW.paywallKey) ||
        isSpecialOffer && (config.closePaywallXmarkKey == PaywallKey.specialOfferLT.paywallKey) ||
        isSpecialOffer && (config.closePaywallXmarkKey == PaywallKey.specialOfferW.paywallKey) ||
        isSpecialOffer && (config.closePaymentPopUp == PaywallKey.specialOfferLT.paywallKey) ||
        isSpecialOffer && (config.closePaymentPopUp == PaywallKey.specialOfferW.paywallKey) ||
        isTriggerSO || isTriggerRSOC || isTriggerSOPop || isTriggerRSOCPop || isSponsorPageVisible
    }
    
    @ViewBuilder
    func WebSilentSponsor() -> some View {
 
        WebSilentPaywall(
            clickedURL:  $subVM.clickedURL,
            isOpacity: .constant(true),
            isShowTimer: $subVM.isShowTimer,
            actionUnlockOffer: {
                if config.silentRSOC.isSponsorPageVisible {
                    subVM.isSilentSpecialOffer = true
                } else {
                    withAnimation(.linear(duration: 0.25)){
                        subVM.isFirstLaunch = false
                    }
                }
            })
        .padding(.vertical, 50)
        .onAppear{
            if  subVM.isSponsorHidden == false {
                subVM.isSponsorHidden = true
            }
        }
    }
}
#endif
