import SwiftUI
import Combine
import WebKit

@MainActor
public class SharedWebViewManager: ObservableObject {
    @MainActor public static let shared = SharedWebViewManager()
    
    @Published public var webView: WKWebView?
    private var coordinator: WebViews.Coordinator?
    private var currentBindings: WebViewBindings?
    
    private init() {}
    
    public struct WebViewBindings {
        public var linkClicked: Binding<Bool>
        public var clickedURL: Binding<String>
        public var clickedButtonText: Binding<String>
        public var screenHeight: Binding<CGFloat>
        public var adsHeight: Binding<CGFloat>
        public var adsOffset: Binding<CGFloat>
        
        public init(
            linkClicked: Binding<Bool>,
            clickedURL: Binding<String>,
            clickedButtonText: Binding<String>,
            screenHeight: Binding<CGFloat>,
            adsHeight: Binding<CGFloat>,
            adsOffset: Binding<CGFloat>
        ) {
            self.linkClicked = linkClicked
            self.clickedURL = clickedURL
            self.clickedButtonText = clickedButtonText
            self.screenHeight = screenHeight
            self.adsHeight = adsHeight
            self.adsOffset = adsOffset
        }
    }
    
    public func setWebView(_ webView: WKWebView, coordinator: WebViews.Coordinator, bindings: WebViewBindings) {
   
        self.webView = webView
        self.coordinator = coordinator
        self.currentBindings = bindings
        coordinator.bindings = bindings
    }
    
    public func getWebView() -> WKWebView? {
        return webView
    }
    
    public func updateBindings(_ bindings: WebViewBindings) {

        self.currentBindings = bindings
        coordinator?.bindings = bindings
    }
    
    public func NavigateTo(url: URL) {

        guard let webView = webView else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
        webView.load(request)
        coordinator?.lastRequestedURL = url.absoluteString
    }
    
    public func clearWebView() {
        webView = nil
        coordinator = nil
        currentBindings = nil
    }
}


