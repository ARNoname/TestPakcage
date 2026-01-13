import SwiftUI
#if canImport(View_Ext)
import View_Ext

struct WebViewComponents: View {
    @EnvironmentObject var subVM: ScreensVM
    
    @Binding var selectedURL: WebViewType
    @Binding var swipeIndex: Int
    @Binding var showX: Bool
    @Binding var isShowTimer: Bool
    
    @State private var linkClicked = false
    @State private var clickedURL = ""
    @State private var selectedLink = 0
    @State private var linkText = WebViewType.linkText_1
    @State private var scaleAnimat: CGSize = CGSize(width: 1, height: 1)

    var body: some View {

        VStack(spacing: 10) {
            TTBannerView(
                text: linkText ?? LinkText(title: "", subTitle: "") ,
                isTimer: selectedLink >= 2 ? true : false
            )
            if let url = URL(string: clickedURL.isEmpty ? selectedURL.url : clickedURL) {
                
               WebViewApp(url: url, linkClicked: $linkClicked, clickedURL: $clickedURL)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(.rect(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 2)
                    }
                
            } else {
                ErrorView()
            }
        }
        .padding(.horizontal, 10)
        .background(Color.black.ignoresSafeArea())
        .onChange(of: clickedURL) {_, newValue in
            clickedURL = newValue
        }
        .onChange(of: selectedURL) {_, newValue in
            clickedURL = ""
            selectedLink = 0
            selectedURL = newValue
        }
        .onChange(of: linkClicked) {_, _ in
            print("🎯 User clicked on link")
            withAnimation {
                selectedLink += 1
                subVM.selectedLink = selectedLink
            }
            
            if selectedLink == 1 {
                Task {
                    await SendManager.shared.sendRsocScreen2View()
                    print("🔥_2")
                }
            }
            if selectedLink == 2 {
                Task {
                    await SendManager.shared.sendRsocScreen3View()
                    print("🔥_3")
                }
            }
        }
        .onChange(of: selectedLink) {_, newValue in
            switch newValue {
            case 0: return linkText = WebViewType.linkText_1
            case 1: return linkText = WebViewType.linkText_2
            case 2: return linkText = WebViewType.linkText_3
            default: break
            }
        }
    }
    @ViewBuilder
    func TitlePage(_ newValue: Int, _ text: String) -> some View {
  
        Group {
            switch newValue {
            case 0: Text(text)
            case 1: Text(text)
            case 2: Text(text)
            default:
                Text(text)
            }
        }
        .transition(
            .asymmetric(
                insertion: .push(from: .trailing),
                removal: .push(from: .leading)
            )
            .combined(with: .scale)
            .animation(.spring(response: 0.6, dampingFraction: 0.6))
        )

    }

    @ViewBuilder
    private func ErrorView() -> some View {

        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            Text("Erorr loading URL")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func TTBannerView(text: LinkText, isTimer: Bool = false) -> some View {
    
        ZStack {
            VStack(spacing: 9) {
                if isShowTimer {
                   TitlePage(selectedLink, text.title?.uppercased() ?? "")
                        .fontApp(isTimer ? .semibold : .bold, isTimer ? 18 : 35)
                    
                    Text(
                        TextColorApp.colorString(
                            text: text.subTitle ?? "",
                            rangeOne: "3-day access",
                            rangeTwo: "3 days of full features",
                            fontWeight: .semibold,
                            size: text.subTitle == "3-day access" ? 18 : 12
                        )
                    )
                    
                    if isTimer {
                        BannerTimer(isShowTimer: $isShowTimer)
                    }
                } else {
                    TitlePage(selectedLink, WebViewType.linkText_4?.title ?? "")
                        .fontApp(.semibold,30)
                    Text(WebViewType.linkText_4?.subTitle ?? "")
                        .fontApp(.medium,20)
                }
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.top, 35)
            .padding(.bottom, isTimer ? 5 : 35)
            .background(Color.blueSubColors)
            .cornerRadius(20)

        }
        .padding(.top, 30)
        .padding(.bottom, isTimer ? 5 : 30)
        .overlay{
            Text("Special Offer")
                .fontApp(.semibold, 24)
                .foregroundStyle(Color.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 28)
                .background(colors)
                .clipShape(.capsule)
                .zIndex(1)
                .vAlig(.top, 10)
            
            if !isTimer {
                Image(.chevroneDownIcon)
                    .vAlig(.bottom, 10)
                    .scaleEffect(scaleAnimat)
            }
        }
        .onAppear{
            scaleAnimat = CGSize(width: 0.95, height: 0.95)
        }
        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scaleAnimat)
    }
    
   private var colors: LinearGradient {
        LinearGradient(colors: [Color(hex: "FF5B03"), Color(hex: "FF0232")], startPoint: .leading, endPoint: .trailing)
    }
}
    
#Preview {
    NavigationView {
        WebViewComponents(
            selectedURL: .constant(.link_1),
            swipeIndex: .constant(1),
            showX: .constant(false),
            isShowTimer: .constant(false)
        )
    }
}
#endif


