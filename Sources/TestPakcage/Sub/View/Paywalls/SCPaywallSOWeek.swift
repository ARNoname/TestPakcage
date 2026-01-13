
import SwiftUI
#if canImport(View_Ext)
import View_Ext

extension PaywallView {
    func PaywallSOWeek(specialOfferType: SpecialOfferType = .swipe) -> some View {
        ZStack {
            LottieView(animationName: "ait animation 19", play: isPlayLottie)
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
                    Text("\(String(describing: getSpecialOffer(for: specialOfferType).amountText1 ?? ""))/week")
                        .font(.custom("Roboto-Medium", size: 22))
                        .foregroundStyle(Color.white.opacity(0.6))
                        .strikethrough(true, color: Color.white.opacity(0.6))
                    
                    Text("--->")
                        .lineSpacing(0)
                        .fontApp(.bold, 10)
                        .foregroundStyle(Color.white.opacity(0.6))
                    
                    Text("\(managerIAP.soWeekPrice)/week")
                        .font(.custom("Roboto-Black", size: 22))
                        .foregroundStyle(Color.yellow)
                }
                
                Text(TextColorApp.colorString(text: "Lowest weekly price ever \n limited time only",
                                              rangeOne: "limited time only",
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
                        title: "Take for $0.29 Now",
                        fgColor: .black,
                        bgColor: .yellow,
                        isScale: true,
                        isShine: true,
                        cornerRadius: 16){
                            Task {
                                await managerIAP.purchaseProduct(productType: .productSpecialOfferWeek)
                             }
                        }
                    
                    Text("Was \(managerIAP.soWeekPrice), now only $0.29 - forget the standard price for your first week and enjoy full access for just $0.29, with your subscription continuing at the regular \(managerIAP.soWeekPrice)/week there after.")
                        .font(.custom("Roboto-Regular", size: 10))
                        .foregroundStyle(Color.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 10)
            .vAlig(.bottom, 40)
        }
    }
}

struct Ones: View {
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            LottieView(animationName: "Trail loading")
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
                    Text( "")
                        .font(.custom("Roboto-Medium", size: 22))
                        .foregroundStyle(Color.white.opacity(0.6))
                        .strikethrough(true, color: Color.white.opacity(0.6))
                    
                    Text("--->")
                        .lineSpacing(0)
                        .fontApp(.bold, 10)
                        .foregroundStyle(Color.white.opacity(0.6))
                    
                    Text("/week")
                        .font(.custom("Roboto-Black", size: 22))
                        .foregroundStyle(Color.yellow)
                }
                
                Text(TextColorApp.colorString(text: "Lowest weekly price ever \n limited time only",
                                              rangeOne: "limited time only",
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
                        title: "Take for $0.29 Now",
                        fgColor: .black,
                        bgColor: .yellow,
                        isScale: true,
                        isShine: true,
                        cornerRadius: 16){
                         
                        }
                    
                    Text("Was , now only $0.29 - forget the standard price for your first week and enjoy full access for just $0.29, with your subscription continuing at the regular /week there after.")
                        .font(.custom("Roboto-Regular", size: 10))
                        .foregroundStyle(Color.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 10)
            .vAlig(.bottom, 40)
        }
    }
}

#Preview {
    Ones()
        .environmentObject(ManagerIAP())
        .environmentObject(NetworkVM())
        .environmentObject(ScreensVM())
}
#endif

