import SwiftUI
import Combine
#if canImport(View_Ext)
import View_Ext

public struct StartView<
    LaunchApp: View,
    FirstOnb: View,
    SecondOnb: View,
    ThirdOnb: View,
    BobOnb: View,
    FirstPW: View,
    SecondPW: View,
    ThirdPW: View,
    BobPW: View,
    MainView: View>: View {
    
    @StateObject private var subVM = ScreensVM()
    @StateObject private var managerIAP = ManagerIAP()
    @StateObject private var analyticsManager = SendManager()
    @StateObject private var networkManager = NetworkVM()
    
    @State private var showPayWall: Bool = false
    @State private var showNetworkError: Bool = false
    @State private var config = AppConfig.shared
     
    private let launchApp: () -> LaunchApp
    private let firstOnb: () -> FirstOnb
    private let secondOnb: () -> SecondOnb
    private let thirdOnb: () -> ThirdOnb
    private let bobOnb: () -> BobOnb
    
    private let firstPW: () -> FirstPW
    private let secondPW: () -> SecondPW
    private let thirdPW: () -> ThirdPW
    private let bobPW: () -> BobPW
    
    private let mainView: () -> MainView
    
    public init(
        @ViewBuilder launchApp: @escaping () -> LaunchApp,
        @ViewBuilder firstOnb: @escaping () -> FirstOnb,
        @ViewBuilder secondOnb: @escaping () -> SecondOnb,
        @ViewBuilder thirdOnb: @escaping () -> ThirdOnb,
        @ViewBuilder bobOnb: @escaping () -> BobOnb,
        @ViewBuilder firstPW: @escaping () -> FirstPW,
        @ViewBuilder secondPW: @escaping () -> SecondPW,
        @ViewBuilder thirdPW: @escaping () -> ThirdPW,
        @ViewBuilder bobPW: @escaping () -> BobPW,
        @ViewBuilder mainView: @escaping () -> MainView
    ) {
        self.launchApp = launchApp
        self.firstOnb = firstOnb
        self.secondOnb = secondOnb
        self.thirdOnb = thirdOnb
        self.bobOnb = bobOnb
        
        self.firstPW = firstPW
        self.secondPW = secondPW
        self.thirdPW = thirdPW
        self.bobPW = bobPW
        self.mainView = mainView
    }
       
public var body: some View {
        ZStack {
            if networkManager.isConnected {
                Content(flow: subVM.flow)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .fullScreenCover(isPresented: $showNetworkError) {
            NetworkError()
        }
        .fullScreenCover(isPresented: $showPayWall) {
            PaywallView(
                subVM: subVM,
                first: firstPW,
                second: secondPW,
                third: thirdPW,
                bob: bobPW,
                showPayWall: $showPayWall
            )
        }
        .environmentObject(subVM)
        .environmentObject(managerIAP)
        .environmentObject(analyticsManager)
        .environmentObject(networkManager)
        .onChange(of: networkManager.isConnected) {_, newValue in
            withAnimation(.linear(duration: 0.5)) {
                showNetworkError = !newValue
            }
        }
        .onChange(of: managerIAP.subEndDate) {_, newValue in
            if newValue > .now {
                showPayWall = false
            }
        }
        .onChange(of: subVM.showPaywall) {_, newValue in
            if newValue == true {
                withAnimation{
                    showPayWall = true
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task { await managerIAP.updateProduct() }
            
            if !subVM.isFirstLaunch {
                if config.payType == .standard &&  managerIAP.subEndDate < .now {
                    if !analyticsManager.showUpdateAlert {
                        withAnimation(.easeInOut){
                            showPayWall = true
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func Content(flow: AppFlowType) -> some View {
        switch flow {
        case .launch:
            LaunchView(showPayWall: $showPayWall) { launchApp() }
                .transition(.move(edge: .leading))
            
        case .onboarding:
            OnboardingContent()
            
        case .main:
            mainView()
        }
    }
    
    @ViewBuilder
    private func OnboardingContent() -> some View {
//        if config.payType == .standard {
            ZStack {
                OnbView(
                    subVM: subVM,
                    first: firstOnb,
                    second: secondOnb,
                    third: thirdOnb,
                    bob: bobOnb
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
//                if config.silentRSOC.isEnabled && config.payType == .standard {
                    WebSilentOnboard(
                        clickedURL: $subVM.clickedURL,
                        isOpacity: $subVM.isSilentOpacity,
                        isShowTimer: $subVM.isShowTimer) {
                            subVM.nextPage()
                            feedbackApp()
                        }
//                }
            }
//        } else {
//            OnbView(
//                subVM: subVM,
//                first: firstOnb,
//                second: secondOnb,
//                third: thirdOnb,
//                bob: bobOnb
//            )
//                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
//        }
    }
}

#endif


struct Test: View {
    var body: some View {
        StartView(
            launchApp: {LaunchScreenTests()},
            firstOnb: {OnbScreen1Tests()},
            secondOnb: {OnbScreen2Tests()},
            thirdOnb: {},
            bobOnb: {OnbScreenBobTests()},
            firstPW: {PaywallScreenTests()},
            secondPW: {},
            thirdPW: {},
            bobPW: {},
            mainView: {MainScreenTests()}
        )
    }
}

struct LaunchScreenTests: View {
    var body: some View {
        Text("LauchScreenTests")
    }
}

//struct OnbScreen1Tests: View {
//    @EnvironmentObject var subVM: ScreensVM
//    var body: some View {
//        VStack {
//            Text("OnbScreen1Tests")
//            ActionButton(title: "Continue")
//        }
//    }
//}

struct OnbScreen2Tests: View {
    var body: some View {
        VStack{
            Text("OnbScreen2Tests")
            ActionButton(title: "Continue")
        }
    }
}

struct OnbScreenBobTests: View {
    var body: some View {
        VStack {
            Text("OnbScreenBobTests")
            ActionButton(title: "Continue")
        }
    }
}

struct PaywallScreenTests: View {
    var body: some View {
        Text("PaywallScreenTests")
    }
}

struct MainScreenTests: View {
    var body: some View {
        Text("MainScreenTests")
    }
}

#Preview {
    Test()
        .environmentObject(ScreensVM())
}

struct OnbScreen1Tests: View {
    @EnvironmentObject var subVM: ScreensVM
    
       var body: some View {
           ZStack {
               Page5_6()
                           
               LottiePageView()
                   
               VStack(spacing: 26) {
                   if subVM.currentPage == 0 {
                      Rectangle()
                           .fill(Color.red)
                           .scaledToFit()
                           .frame(height: 71)
                           .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                   }
                   
                   if subVM.currentPage == 5 || subVM.currentPage == 6 {} else {
                       ActionButton(
                           title: subVM.currentPage == 0 ? "Let's Go!" : "Next",
                           fgColor: .white,
                           bgColor: .blue) {
                               subVM.nextPage()
                           }
                   }
                   
                   PageControll(numberOfPages: subVM.pageItem + 1, currentPage: subVM.currentPage)
               }
               .padding(.horizontal, 16)
               .vAlig(.bottom, 10)
               
               if subVM.currentPage == 7 {
                   Page7()
                       .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
               }
           }
    }
    
    
    @ViewBuilder
    func Page5_6() -> some View {
        ZStack {
            switch subVM.currentPage {
            case 5:
                PageOnbView(currentPage: subVM.currentPage)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .vAlig(.top, 70)
            case 6:
                PageOnbView(currentPage: subVM.currentPage)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .vAlig(.top, 70)
            default: EmptyView()
            }
        }
    }
    
    @ViewBuilder
    func LottiePageView() -> some View {
        ZStack {
            switch subVM.currentPage {
            case 0:
                LottieView(animationName: "tt animation 3",loopMode: .playOnce)
                    .offset(y: -60)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case 1:
                LottieView(animationName: "tt animation 4")
                    .offset(y: -20)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case 2:
                LottieView(animationName: "tt animation 5")
                    .offset(y: -20)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case 3:
                LottieView(animationName: "tt animation 6")
                    .offset(y: -20)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case 4:
                LottieView(animationName: "tt animation 7")
                    .offset(y: -20)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case 8:
                LottieView(animationName: "tt animation 8")
                    .offset(y: -20)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case 9:
                LottieView(animationName: "tt animation 9")
                    .offset(y: -20)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            default: EmptyView()
            }
        }
    }
    
    @ViewBuilder
    func Page7() -> some View {
        ZStack {
            LinearGradient(colors: [.purple, .blue], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Rectangle()
                    .fill(Color.blue)
                    .scaledToFit()
                    .frame(height: 27)
                
                Text("procent  %")
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .fontApp(.medium, 64)
            }
            .vAlig(.top, 150)
           
            
            LottieView(animationName: "tt animation 1")
            
            VStack(spacing: 16) {
                Text("Calculating your\n data…")
                    .foregroundStyle(.white)
                    .fontApp(.medium, 32)
                    .multilineTextAlignment(.center)
                
                Text("Most people are surprised\n by this part.")
                    .foregroundStyle(.white.opacity(0.7))
                    .fontApp(.regular, 16)
                    .multilineTextAlignment(.center)
                
                ActionButton(title: "Continue")
            }
            .vAlig(.bottom, 140)
        }
    }
}


struct PageOnbView: View {
    @EnvironmentObject var subVM: ScreensVM
    
    let currentPage: Int
    
    var body: some View {
        VStack(spacing: 36) {
            
            VStack(spacing: 16) {
                Text(currentPageData.0)
                    .foregroundStyle(.white)
                    .fontApp(.medium, 32)
                
                Text(currentPageData.1)
                    .foregroundStyle(.white.opacity(0.6))
                    .fontApp(.regular, 16)
                    .multilineTextAlignment(.center)
            }
            
            LazyVGrid(columns: currentPage == 6 ? grid : [GridItem()], spacing: 12) {
                ForEach(currentPage == 6 ? titleBtnPage7 : titleBtnPage6, id: \.self) {item in
                    ActionButton(
                        title: item,
                        fgColor:  .white.opacity(0.7),
                        bgColor:  .black) {
                            subVM.nextPage()
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
        
    var currentPageData: (String, String) {
        switch currentPage {
        case 5:
            return ("How old are you?", "This helps us understand how long this\n habit has been with you.")
        case 6:
            return ("On an average day,\nhow much time do\n you spend on your\n phone?", "Rough estimate is enough.")
        default:
            return ("", "")
        }
    }
    
    private var titleBtnPage6: [String] {
       [
        "Under 18",
        "18 - 24",
        "25 - 29",
        "30 - 34",
        "35 - 44",
        "45 - 54",
        "55 and over"
       ]
    }
    
    private var titleBtnPage7: [String] {
       [
        "1-2 hours",
        "2-3 hours",
        "3-4 hours",
        "4-5 hours",
        "5-6 hours",
        "6-7 hours",
        "7-8 hours",
        "Over 8 hours"
       ]
    }
    
    let grid = Array(
        [GridItem(.flexible(),spacing: 12),
         GridItem(.flexible())]
    )
}

