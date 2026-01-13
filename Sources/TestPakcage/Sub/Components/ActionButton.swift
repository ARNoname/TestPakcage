import SwiftUI
#if canImport(View_Ext)
import View_Ext

public struct ActionButton: View {
    
    @EnvironmentObject var networkManager: NetworkVM
    @EnvironmentObject var managerIAP: ManagerIAP
    @EnvironmentObject var subVM: ScreensVM
    
    @State private var isScaled: Bool = false
    @State private var shine: Bool = false
    
    public var title: String
    public var isPurchasing: Bool
    public var fgColor: Color
    public var bgColor: Color
    
    public var font: (FontTypeApp, CGFloat)
    public var heightBT: CGFloat
    
    public var isScale: Bool
    public var scaleDuration: CGFloat
    
    public var isShine: Bool
    public var shineDuration: CGFloat
    public var shineColor: Color
    
    public var cornerRadius: CGFloat
    
    public var isStroke: Bool
    public var strokeColor: Color
    public var strokeWidth: CGFloat
    
    public var action: (() -> Void)?
    
    public init(
        title: String = "Continue",
        fgColor: Color = .white,
        bgColor: Color = .blue,
        font: (FontTypeApp, CGFloat) = (.medium, 18),
        heightBT: CGFloat = 60 ,
        isScale: Bool = false,
        scaleDuration: CGFloat = 0.8,
        isShine: Bool = false,
        shineDuration: CGFloat = 0.8,
        shineColor: Color = .white,
        cornerRadius: CGFloat = 28,
        isStroke: Bool = false,
        strokeColor: Color = .black,
        strokeWidth: CGFloat = 1,
        isPurchasing: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.fgColor = fgColor
        self.bgColor = bgColor
        self.font = font
        self.isScale = isScale
        self.scaleDuration = scaleDuration
        self.isShine = isShine
        self.shineDuration = shineDuration
        self.shineColor = shineColor
        self.heightBT = heightBT
        self.cornerRadius = cornerRadius
        self.isStroke = isStroke
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.isPurchasing = isPurchasing
        self.action = action
    }
     
    public var body: some View {
        ButtonApp(action: {
            if let action {
                action()
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if isPurchasing {
                        if networkManager.isConnected {
                            Task { await handlePurchase() }
                        } else {
                            networkManager.isError = true
                        }
                        
                        if subVM.isSpecialOffer {
                            Task {
                                await SendManager.shared.sendSpecialOfferCtaClick()
                            }
                        }
                    } else {
                        subVM.nextPage()
                    }
                }
            }
               }, label: {
                   ZStack {
                       Text(getTitleForButton())
                           .frame(maxWidth: .infinity)
                           .frame(height: heightBT)
                           .background(managerIAP.isPurchasing ? bgColor.opacity(0.7) : bgColor)
                           .background(AppConfig.shared.payType == .standard ? bgColor : Color.clear)
                           .if(isShine) {view in
                               view.shine(shine, duration: shineDuration, color: shineColor)
                           }
                           .clipShape(.rect(cornerRadius: cornerRadius))
                           .if(isStroke) { view in
                               view.overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(strokeColor, lineWidth: strokeWidth))
                           }
                           .animation(.easeInOut, value: subVM.isTrialFree)
                   }
               })
               .frame(height: heightBT)
               .if(isScale){ view in
                   view.scaleEffect(isScaled ? 1.0 : 0.93)
               }
               .disabled(subVM.isProgressAnimating ? true : false)
               .disabled(managerIAP.isPurchasing)
               .fontApp(font.0, font.1)
               .foregroundStyle(fgColor)
               .opacity(subVM.isProgressAnimating ? 0.3 : 1)
               .task {
                   if isShine {
                       startShimmerTimer()
                       try? await Task.sleep(for: .seconds(0.4))
                   }
                   
                   if isScale {
                       isScaled = true
                   }
               }
               .animation(.easeInOut(duration: scaleDuration).repeatForever(autoreverses: true), value: isScaled)
               .alert("Oops...", isPresented: $managerIAP.showAlert, actions: {
                   Button(action: {
                       managerIAP.showAlert = false
                   }, label: {
                       Text("Cancel")
                   })
                   Button(action: {
                       Task {await handlePurchase()}
                   }, label: {
                       Text("Try again")
                   })
               }, message: {
                   Text("Something went wrong. \n Please try again")
               })
           }
    
    // MARK: - Get text for button
    private func getTitleForButton() -> String {
   
        if AppConfig.shared.payType == .standard {
           return title
        } else {
            if isPurchasing {
                switch subVM.selectedPlan {
                case .weeklyTrial: return "Start Free Trial for - \(managerIAP.weeklyPrice)/week"
                case .weekly:      return "Subscribe for \(managerIAP.weeklyPrice)/week"
                case .monthly:     return "Subscribe for \(managerIAP.monthlyPrice)/month"
                case .yearly:      return "Subscribe for \(managerIAP.yearlyPrice)/year"
                case .lifetime:    return "Buy Lifetime Access - \(managerIAP.lifeTimePrice)"
                case .specialOfferWeek: return "Special Offer - \(managerIAP.soWeekPrice)"
                }
            } else {
                return title
            }
        }
    }
    
// MARK: - Handle purchase
    private func handlePurchase() async {
   
        let productType: ProductType
        
        switch subVM.selectedPlan {
        case .weeklyTrial:       productType = .productWeeklyTrial
        case .weekly:            productType = .productWeekly
        case .monthly:           productType = .productMonthly
        case .yearly:            productType = .productYearly
        case .lifetime:          productType = .productLifetime
        case .specialOfferWeek:  productType = .productSpecialOfferWeek
        }
        
       await managerIAP.purchaseProduct(productType: productType)
    }
    
    // MARK: - Start Shimmer
     func startShimmerTimer() {
         Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
             DispatchQueue.main.async {
                 shine = true
             }
            
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                 shine = false
             }
         }
     }
}

#Preview {
    ActionButton(title: "Continue")
        .environmentObject(ManagerIAP())
        .environmentObject(NetworkVM())
        .environmentObject(ScreensVM())
}
#endif

