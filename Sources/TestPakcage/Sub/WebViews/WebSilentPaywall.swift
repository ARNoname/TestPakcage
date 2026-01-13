import SwiftUI
#if canImport(View_Ext)
import View_Ext

struct WebSilentPaywall: View {
    @EnvironmentObject var subVM: ScreensVM
        
        @State var offset: CGFloat = 0
        @State var isShowBanner: Bool = true
        
        @Binding var clickedURL: String
        @Binding var isOpacity: Bool
        @Binding var isShowTimer: Bool
        var actionUnlockOffer: () -> ()
        
        var body: some View {
            VStack(spacing: 14) {
                if isShowBanner {
                    BannerView()
                        .padding(.top, 20)
                }
                WebComponent()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 10)
            .background(Color.black.ignoresSafeArea())
            .opacity(isOpacity ? 1.0 : 0)
            .allowsHitTesting(true)
            .onAppear {
                Task {
                    await SendManager.shared.sendSilentRSOCSponsorPageVisible()
                    print("💕 Sponsor page became visible")
                }
            }
        }
        
        @ViewBuilder
        func WebComponent() -> some View {
            
            if let url = URL(string: clickedURL) {
                WebViews(
                    url: url,
                    linkClicked: .constant(false),
                    clickedURL: $clickedURL,
                    clickedButtonText: .constant("UnlockOffer"),
                    screenHeight: .constant(0),
                    adsHeight: .constant(0),
                    adsOffset: .constant(0),
                    useSharedInstance: true
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .clipShape(.rect(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1)
                }
                .offset(y: offset)
                .onChange(of: clickedURL) {_, newValue in
                    print("‼️ClickedURL: \(newValue)")
                }
            }
        }
        
        @ViewBuilder
        func BannerView(isTimer: Bool = true) -> some View {
            
            ZStack {
                VStack(spacing: 14) {
                    if isShowTimer {
                        VStack(spacing: 9) {
                            Text("Browse while you wait")
                                .fontApp(.bold, 20)
                            
                            Text("Special price ready in")
                                .fontApp(.medium, 16)
                            
                            if isTimer {
                                BannerTimer(isShowTimer: $isShowTimer)
                                    .padding(.top, 6)
                            }
                        }
                        .padding(.top, 20)
                        .transition(
                            .asymmetric(
                                insertion: .push(from: .trailing),
                                removal: .push(from: .leading)
                            )
                            .combined(with: .scale)
                            .animation(.spring(response: 0.6, dampingFraction: 0.6))
                        )
                    } else {
                        VStack(spacing: 9) {
                            Text("YOUR SPECIAL PRICE IS READY")
                                .fontApp(.bold, 20)
                            
                            Text("Tap to unlock it now")
                                .fontApp(.medium, 16)
                            
                            ButtonApp(action: {
                                actionUnlockOffer()
                            }, label: {
                                Text("Unlock Offer")
                                    .fontApp(.semibold, 30)
                                    .foregroundStyle(Color.white)
                                    .frame(width: 250, height: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.green)
                                            .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 1)
                                    )
                            })
                            .padding(.top, 6)
                            
                        }
                        .padding(.top, 20)
                        .transition(
                            .asymmetric(
                                insertion: .push(from: .trailing),
                                removal: .push(from: .leading)
                            )
                            .combined(with: .scale)
                            .animation(.spring(response: 0.6, dampingFraction: 0.6))
                        )
                    }
                }
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, maxHeight: 180)
                .background(Color.blueColors)
                .cornerRadius(20)
                .overlay {
                    Text("Limited-time Deal")
                        .fontApp(.semibold, 24)
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 28)
                        .background(scColors)
                        .clipShape(.capsule)
                        .zIndex(1)
                        .vAlig(.top, -18)
                }
            }
        }
        
        var scColors: LinearGradient {
            LinearGradient(colors: [Color(hex: "FF5B03"), Color(hex: "FF0232")], startPoint: .leading, endPoint: .trailing)
        }
    }

#endif
