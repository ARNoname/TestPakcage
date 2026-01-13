import SwiftUI
import WebKit
#if canImport(View_Ext)
import View_Ext

struct WebSilentOnboard: View {
    @EnvironmentObject var subVM: ScreensVM
     
    @State var selectedURl: String = "https://globytrace.com/4QnKbVjD"//AppConfig.shared.silentRSOC.links?.link_1 ?? ""
    @State private var linkClicked = false
        @State private var selectedLink = 0
        @State private var adBlockHeight: CGFloat = 0
        @State private var adsOffset: CGFloat = 0
        @State private var clickedButtonText: String = ""
        
        @State private var screenHeight: CGFloat = 0
        @State private var offset: CGFloat = 0
        @State private var opacityData: CGFloat = 0.2//0.005
        @State var isShowBanner: Bool = false
        
        @State private var isLinkClickInProgress = false
        
        @Binding var clickedURL: String
        @Binding var isOpacity: Bool
        @Binding var isShowTimer: Bool
        
        var action: () -> ()
        var actionUnlockOffer: () -> () = {}
        
        var body: some View {
            
            TTWebComponent()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 10)
                .background(Color.black.ignoresSafeArea())
                .opacity(isOpacity ? 1.0 : opacityData)
                .allowsHitTesting(subVM.isProgressAnimating ? false : true)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded({ _ in
                            if !subVM.isProgressAnimating {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    if !isLinkClickInProgress {
                                        action()
                                        feedbackApp()
                                    }}
                            }
                        })
                )
                .onChange(of: linkClicked) {_, newValue in
                    
                    if newValue {
                        isLinkClickInProgress = true
                        
                        selectedLink += 1
                        action()
                        
                        switch selectedLink {
                        case 1:
                            Task {
                                await SendManager.shared.sendSilentRSOCScreen2()
                                print("💕2 - SilentScreen 2")
                            }
                        case 2:
                            Task {
                                await SendManager.shared.sendSilentRSOCSponsorPageLoad()
                                print("💕3 - PageLoad - SPONSOR")
                            }
                        default: break
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isLinkClickInProgress = false
                            self.linkClicked = false
                        }
                    }
                }
        }
        
        @ViewBuilder
        func TTWebComponent() -> some View {
            if let url = URL(string: selectedURl) {
                WebViews(
                    url: url,
                    linkClicked: $linkClicked,
                    clickedURL: $clickedURL,
                    clickedButtonText: $clickedButtonText,
                    screenHeight: $screenHeight,
                    adsHeight: $adBlockHeight,
                    adsOffset: $adsOffset,
                    useSharedInstance: true
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1)
                }
                .offset(y: offset)
                .onAppear {
                    Task {
                        await SendManager.shared.sendSilentRSOCScreen1()
                        print("💕1 - SilentScreen 1")
                    }
                }
                .onChange(of: adBlockHeight) {_, newValue in
                    switch selectedLink {
                    case 0:
                        let randomIndex: [Double] = [10, 65]
//                        let randomIndex: [Double] = [100, 200]
                        guard let randomIndex = randomIndex.randomElement() else { return }
                        offset = (screenHeight - adBlockHeight) - randomIndex

                    case 1:
                        let offH = (screenHeight - adBlockHeight) - 140
                        offset = 610 < adBlockHeight ? -10 : offH
                        adsOffset = 610 < adBlockHeight ? 0 : 0
                        
                    case 2:
                        self.adsOffset = 0
                        self.offset = 0
                        
                    default:
                        self.adsOffset = 0
                        self.offset = 0
                    }
                }
                .onChange(of: clickedURL) {_, newValue in
                    print("‼️ ClickedURL: \(newValue)")
                }
                .onChange(of: clickedButtonText) {_, newValue in
                    print("🔘 Clicked Button Text: \(newValue)")
                    
                }
            }
        }
    }
#Preview {
    WebSilentOnboard(clickedURL: .constant(""),
                     isOpacity: .constant(false),
                     isShowTimer: .constant(false),
                     action: {},
                     actionUnlockOffer: {}
    )
}

#endif
