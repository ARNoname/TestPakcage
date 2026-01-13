import SwiftUI
import WebKit

struct WebViewApp: UIViewRepresentable {
    let url: URL
      @Binding var linkClicked: Bool
      @Binding var clickedURL: String
      

      func makeUIView(context: Context) -> WKWebView {
     
          let webView = WKWebView()
          webView.navigationDelegate = context.coordinator
          
          let request = URLRequest(url: url)
          webView.load(request)
          return webView
      }

      func updateUIView(_ uiView: WKWebView, context: Context) {
      
          guard let currentURL = uiView.url else {
              let request = URLRequest(url: url)
              uiView.load(request)
              return
          }
          
          if currentURL != url {
              let request = URLRequest(url: url)
              uiView.load(request)
          }
          print("✅Updated WebView ")
      }

      func makeCoordinator() -> Coordinator {
          Coordinator(self)
      }

      class Coordinator: NSObject, WKNavigationDelegate {
          var parent: WebViewApp

          init(_ parent: WebViewApp) {
              self.parent = parent
          }

      func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

              guard let url = navigationAction.request.url else {
                  decisionHandler(.allow)
                  return
              }

              let urlString = url.absoluteString
              print("WebView navigation to: \(urlString)")
          
              if navigationAction.navigationType == .linkActivated {
                  decisionHandler(.allow)
                  DispatchQueue.main.async {
                      self.parent.linkClicked.toggle()
                      self.parent.clickedURL = urlString
                      print("✅ Link clicked: \(self.parent.linkClicked)")
                  }
              } else {
                  decisionHandler(.allow)
              }
          }

          func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
              print("WebView finished loading")
          }

          func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
              print("WebView failed to load: \(error.localizedDescription)")
          }
      }
  }

