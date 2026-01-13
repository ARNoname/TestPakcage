import SwiftUI
#if canImport(View_Ext)
import View_Ext

extension PaywallView  {
    func PaywallSOLifeTime(specialOfferType: SpecialOfferType = .swipe) -> some View {
        ZStack {
           LottieView(animationName: "ait animation 18", play: isPlayLottie)
                .scaledToFill()
                .frame(width: screenSizeApp().width, height: screenSizeApp().height)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(.oneTimes)
                    .resizable()
                    .scaledToFit()
                
                Text("You will never see this again!")
                    .font(.custom("Roboto-Medium", size: 18))
                    .foregroundStyle(Color.white)
            }
            .vAlig(.top, 100)
            
            VStack(spacing: 24) {
                HStack(spacing: 8) {
                    Text(getSpecialOffer(for: specialOfferType).amountText1 ?? "amountText1")
                        .font(.custom("Roboto-Medium", size: 22))
                        .foregroundStyle(Color.white.opacity(0.6))
                        .strikethrough(true, color: Color.white.opacity(0.6))
                    
                    Text("--->")
                        .lineSpacing(0)
                        .fontApp(.medium, 14)
                        .foregroundStyle(Color.white.opacity(0.6))
                    
                    Text("\(managerIAP.lifeTimePrice) Lifetime")
                        .font(.custom("Roboto-Black", size: 22))
                        .foregroundStyle(Color.yellow)
                }
                
                Text(TextColorApp.colorString(text: "Lowest price ever!\n pay once, use forever",
                                               rangeOne: "pay once, use forever",
                                               rangeOneColor: UIColor(Color.white.opacity(0.6)),
                                               size: 12))
                .multilineTextAlignment(.center)
                .font(.custom("Roboto-Medium", size: 18))
                .foregroundStyle(Color.white)
                
                VStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Text("Our app is approved by")
                        HStack(spacing: 2) {
                            Image(systemName: "applelogo")
                            Text("Apple")
                        }
                    }
                    .font(.custom("Roboto-Medium", size: 14))
                    .foregroundStyle(Color.white)
                    
                    ActionButton(
                        title: "Claim Lifetime Access",
                        fgColor: .black,
                        bgColor: .yellow,
                        isScale: true,
                        isShine: true,
                        cornerRadius: 16){
                            Task {
                                 await managerIAP.purchaseProduct(productType: .productLifetime)
                             }
                        }
                  
                    Text("No hidden fees - pay exactly what you see")
                        .font(.custom("Roboto-Regular", size: 12))
                        .foregroundStyle(Color.white.opacity(0.6))
                }
            }
            .padding(.horizontal, 10)
            .vAlig(.bottom, 40)
        }
    }
}
#endif
