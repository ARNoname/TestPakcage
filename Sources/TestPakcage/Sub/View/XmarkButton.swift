import SwiftUI
#if canImport(View_Ext)
import View_Ext

struct XmarkButton: View {
    @EnvironmentObject var subVM: ScreensVM
    @EnvironmentObject var analyticsVM: SendManager
    
    @State private var delayTask: Task<Void, Never>?
    @State private var currentDelay: Int = 0
    @State private var isDelay: Bool = false
    
    @Binding var showX: Bool
    @Binding var showPayWall: Bool
    @Binding var isHomeIndicator: Bool
    @Binding var isSpecialOffer: Bool
    @Binding var isSwipeCounter: Int
    @Binding var isAnimationTrial: Bool
    @Binding var isTriggerRSOC: Bool
    @Binding var isTriggerSO: Bool
    @Binding var isTriggerRSOCPop: Bool
    @Binding var isTriggerSOPop: Bool
    @Binding var isSponsorPageVisible: Bool
    

    var body: some View {
        HStack {
            if showX {
                ButtonApp(action: {

                    self.isDelay.toggle()
                    
                    if isSpecialOffer {
                        showPayWall = false
                        Task {
                            await analyticsVM.sendSpecialOfferCrossClick()
                        }
                    }
                    
                    if  AppConfig.shared.paywallKey == PaywallKey.bob.paywallKey {
                        showPayWall = false
                    } else {
                        
                        if AppConfig.shared.silentRSOC.isSponsorPageVisible && !subVM.isSponsorHidden {
                                if  subVM.isFirstLaunch {
                                    subVM.isSilentOpacity = true
                                    subVM.isShowTimer = true
                                    subVM.isSponsorHidden = true
                                    isSponsorPageVisible = true
                                }
                                else {
                                    subVM.isFirstLaunch = false
                                    showPayWall = false
                                }
                            } else {
                            if (AppConfig.shared.paywallModel.onPaymentsPooUpClose == "RSOC" ||
                                AppConfig.shared.paywallModel.onPaymentsPooUpClose == "SPECIAL_OFFER") && (isTriggerSOPop || isTriggerRSOCPop) {
                                
                                if isTriggerRSOCPop {
                                    isTriggerRSOCPop = false
                                    isTriggerSOPop = true
                                    isSpecialOffer = true
                                    subVM.isSpecialOffer = true
                                } else {
                                    handleCloseXmark()
                                }
                                
                            } else if (AppConfig.shared.paywallModel.onSwipeAction == "RSOC" ||
                                       AppConfig.shared.paywallModel.onSwipeAction == "SPECIAL_OFFER") && isSwipeCounter > 0 {
                                     isSpecialOffer = true
                                     subVM.isSpecialOffer = true
                                 
                             } else if AppConfig.shared.paywallModel.onPaywallClose == "RSOC" ||
                                       AppConfig.shared.paywallModel.onPaywallClose == "SPECIAL_OFFER" {
                                
                                if isTriggerRSOC {
                                    isTriggerRSOC = false
                                    isTriggerSO = true
                                    isSpecialOffer = true
                                    subVM.isSpecialOffer = true
                                } else {
                                    handleCloseXmark()
                                }
                                
                            } else {
                                if isSwipeCounter == 0 {
                                    showPayWall = false
                                    
                                } else {
                                    isSwipeCounter = 0
                                    isAnimationTrial = true
                                    
                                }
                            }
                        }
                    }
                    
                    if isSwipeCounter > 2 || subVM.selectedLink > 0 {
                        Task {
                            await analyticsVM.sendRsocCrossClick()
                        }
                    }
                    
                    self.showX = false
                    
                    
                    guard AppConstants.disableFirstLauch == false else { return }
                    
                    if subVM.isFirstLaunch == true {
                        subVM.isFirstLaunch = false
                    }
                    
                }, label: {
                    if AppConfig.shared.paywallKey == PaywallKey.bob.paywallKey {
                        Image(.xmarkIcon)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.black.opacity(0.8))
                    } else {
                        Image(.xmarkIcon)
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(AppConstants.xmarkPostion.color)
                    }
                    
                })
            }
        }
        .onAppear {
             currentDelay = AppConfig.shared.paywallModel.delay
             startDelayTimer()
         }
        .onChange(of: isDelay) {_, newValue in
             currentDelay = AppConfig.shared.paywallModel.delay
             startDelayTimer()
         }
     }
    
    func handleCloseXmark() {
  
        switch AppConfig.shared.paywallModel.onPaywallClose {
        case SwipeActionType.rsoc.rawValue:
            withAnimation {
                isTriggerRSOC = true
            }
        case SwipeActionType.specialOffer.rawValue:
            isTriggerSO = true
            isSpecialOffer = true
            subVM.isSpecialOffer = true
        default: break
        }
    }
     
     private func startDelayTimer() {
 
         delayTask?.cancel()
         
         delayTask = Task {
             try? await Task.sleep(for: .seconds(currentDelay))
             
             if !Task.isCancelled {
                 await MainActor.run {
                     withAnimation {
                         showX = true
                     }
                 }
             }
         }
     }
 }
#endif


