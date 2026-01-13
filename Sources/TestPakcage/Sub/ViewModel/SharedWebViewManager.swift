import SwiftUI
import Combine
import WebKit

@MainActor
class SharedWebViewManager: ObservableObject {
    @MainActor static let shared = SharedWebViewManager()
    
    @Published var webView: WKWebView?
    private var coordinator: WebViews.Coordinator?
    private var currentBindings: WebViewBindings?
    
    private init() {}
    
    struct WebViewBindings {
        var linkClicked: Binding<Bool>
        var clickedURL: Binding<String>
        var clickedButtonText: Binding<String>
        var screenHeight: Binding<CGFloat>
        var adsHeight: Binding<CGFloat>
        var adsOffset: Binding<CGFloat>
    }
    
    func setWebView(_ webView: WKWebView, coordinator: WebViews.Coordinator, bindings: WebViewBindings) {
   
        self.webView = webView
        self.coordinator = coordinator
        self.currentBindings = bindings
        coordinator.bindings = bindings
    }
    
    func getWebView() -> WKWebView? {
        return webView
    }
    
    func updateBindings(_ bindings: WebViewBindings) {

        self.currentBindings = bindings
        coordinator?.bindings = bindings
    }
    
    func NavigateTo(url: URL) {

        guard let webView = webView else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
        webView.load(request)
        coordinator?.lastRequestedURL = url.absoluteString
    }
    
    func clearWebView() {
        webView = nil
        coordinator = nil
        currentBindings = nil
    }
}


