MARK: - Example: How Add Sub SDK in Your Code

(Github):
1. File -> Add Package Dependencies...
2. Enter URL repository that you copied from Github

MARK: - Example: How Initialize Sub SDK in Your Code.

Check the entire AppConstants file and you’ll see what you can edit or use for convenience when creating views for Onboarding or the Paywall.

-------------------------------------------------------------------
@main
struct NameApp: App {
 
    init() {
    // Here you need to enter the required data, which must be overridden from AppConstants.     
    // For more details, you can open AppConstants and see what can be customized for your convenience and for editing the project.
    
    // Example:
        AppConstants.RCatApiKey   = "asd_w23m23fwdf232"
        AppConstants.RCatID       = "PREMIUM"
        AppConstants.weeklyID     = "Weekly"
        AppConstants.bobOnbPage   = 2
        AppConstants.firstOnbPage = 4
    }
    
    var body: some Scene {
        WindowGroup {
            StartView(
                launchApp: { LaunchScreenName() },  // Here you need to insert the name of your struct.
                firstOnb: { OnbScreen1Name() },     
                secondOnb: { OnbScreen2Name() },      
                thirdOnb: {},                       // if the view has not been created yet and does not need to be created, just leave it empty.
                bobOnb: { OnbScreenBobName() },
                firstPW: { PaywallScreenName() },
                secondPW: {},
                thirdPW: {},
                bobPW: {},
                mainView: { MainScreenName() }
            )
        }
    }
}
-------------------------------------------------------------------

MARK: - Example: Code For LaunchView

struct  LaunchViewTest: View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            HStack(spacing: 8) {
                Image("logoIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 40)
                    
                Text("AppName")
                    .fontApp(.bold, 40)
            }
            
            LottieView(animationName: "Trail loading")
                .frame(width: 120, height: 120)
                .vAlig(.bottom)
           }
        }
 }    
 -------------------------------------------------------------------
MARK: - EXample: Code For Onboarding

struct OnbScreen1Tests: View {

    @EnvironmentObject var subVM: ScreensVM
    
    var body: some View {
        ZStack {
            switch subVM.currentPage {
            case 0:
                OnboardPage_1()
                    .transitionOnboard()
            case 1:
                OnboardPage_2()
                    .transitionOnboard()
            default: EmptyView()
            }
        }
    }
    
    @ViewBuilder
    func OnboardPage_1() -> some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            LottieView(animationName: "tt animation 3",loopMode: .playOnce)
                .vAlig(.top, 100)
                .transitionOnboard()
            
            Text("Title Onboard Screen 1")
                .fontApp(.bold, 32)
                .foregroundStyle(Color(.white))
            
            VStack(spacing: 24) {
                if subVM.currentPage == 0  {
                    
                    // ActionButton -> to next page
                    ActionButton(
                        title: subVM.currentPage == 0 ? "Let's Go!" : "Next",
                        fgColor: .white,
                        bgColor: .blue)
                }
                
                // You can set any PageControl you need. Check its initializer to see what options you can configure.
                PageControll(numberOfPages: subVM.pageItem + 1, currentPage: subVM.currentPage)
            }
            .padding(.horizontal, 16)
            .vAlig(.bottom, 10)
        }
    }
    
    @ViewBuilder
    func OnboardPage_2() -> some View {
        ZStack {
        }
    }
}
-------------------------------------------------------------------
MARK: Example: Code For Paywall

 struct PaywallScreenTests: View {

    @EnvironmentObject var subVM: ScreensVM
    @EnvironmentObject var managerIAP: ManagerIAP
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 26) {
                Text("Title here")
                    .fontApp(.semibold, 24)
                
                Text("Subtitles here")
                    .fontApp(.medium, 18)
            }
            .foregroundStyle(Color.white)
            .multilineTextAlignment(.center)
            
            Image("imageName")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 138)
            
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Toggle("Free access activated", isOn: $subVM.isTrialFree)
                        .fontApp(.regular, 16)
                        .frame(height: 48)
                        .padding(.horizontal,16)
                        .tint(Color.blue)
                        .foregroundStyle(Color.white)
                        .background(subVM.isTrialFree  ? Color.blue.opacity(0.5) : Color.black)
                        .background(.ultraThinMaterial.opacity(0.05))
                        .clipShape(.rect(cornerRadius: 24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(subVM.isTrialFree  ? Color.blue :  Color.white.opacity(0.2), lineWidth: 0.5)
                        )
                    // If this cell doesn’t suit your needs, take its logic and adapt it as required.
                    SelectPlan_Bob(
                        plan: .weeklyTrial ,
                        isSelected: subVM.selectedPlan == .weeklyTrial,
                        title: AppConstants.weekly,
                        onTap: {
                            subVM.selectedPlan = .weeklyTrial
                        })
                    
                    SelectPlan_Bob(
                        plan: .monthly,
                        isSelected: subVM.selectedPlan == .monthly,
                        title: AppConstants.monthly,
                        price: managerIAP.monthlyPrice,
                        onTap: {
                            subVM.selectedPlan = .monthly
                        })
                    
                    HStack {
                        SelectPlan_Bob(
                            plan: .yearly,
                            isSelected: subVM.selectedPlan == .yearly,
                            title: AppConstants.yearly,
                            price: managerIAP.yearlyPrice,
                            onTap: {
                                subVM.selectedPlan = .yearly
                            })
                        
                        SelectPlan_Bob(
                            plan: .lifetime,
                            isSelected: subVM.selectedPlan == .lifetime,
                            title: AppConstants.lifetime,
                            price: managerIAP.lifeTimePrice,
                            hasLimitedOffer: true,
                            onTap: {
                                subVM.selectedPlan = .lifetime
                            })
                    }
                }
                .padding(.bottom, 4)
                
                VStack(spacing: 20) {
                    HStack(spacing: 4) {
                        Image(subVM.isTrialFree ? "shieldPWBob" : "checkCirclePWBob")
                        Text(subVM.isTrialFree ? "No payment now" : "Auto-renewable, cancel anytime")
                            .fontApp(.regular,12)
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.center)
                    }
                    // For Paywall button, you need add parametr: isPurchasing: true
                    // If this is the Bob paywall, there’s no need to set the title — it’s already defined.
                    // Implement your own logic for the title. For example, if selectedPlan == .weekly, then use managerIAP.weeklyPrice.
                    ActionButton(title: "Subscribe for \(managerIAP.weeklyPrice)" ,isPurchasing: true)
                }
            }  
            .padding(.bottom, 70)
            .padding(.horizontal, 20)
        }
        .background(Color.white)
        .task {
            subVM.isTrialFree = true
        }
        .onChange(of: subVM.isTrialFree) {_, newValue in
            if newValue {
                subVM.selectedPlan = .weeklyTrial
            } else {
                switch subVM.selectedPlan {
                case .monthly:  subVM.selectedPlan = .monthly
                case .yearly:   subVM.selectedPlan = .yearly
                case .lifetime: subVM.selectedPlan = .lifetime
                default:        subVM.selectedPlan = .yearly
                }
            }
        }
        .onChange(of: subVM.selectedPlan ){_, newValue in
            if newValue == .weeklyTrial {
                subVM.isTrialFree = true
            }
            
            if newValue == .monthly || newValue == .yearly || newValue == .lifetime {
                subVM.isTrialFree = false
            }
        }
    }
}
