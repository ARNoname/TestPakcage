import SwiftUI
import WebKit

struct WebViews: UIViewRepresentable {
    let url: URL
    @Binding var linkClicked: Bool
    @Binding var clickedURL: String
    @Binding var clickedButtonText: String
    @Binding var screenHeight: CGFloat
    @Binding var adsHeight: CGFloat
    @Binding var adsOffset: CGFloat

    var useSharedInstance: Bool = false
        
    func makeUIView(context: Context) -> WKWebView {
     
        if useSharedInstance, let sharedWebView = SharedWebViewManager.shared.getWebView() {
            let bindings = SharedWebViewManager.WebViewBindings(
                linkClicked: $linkClicked,
                clickedURL: $clickedURL,
                clickedButtonText: $clickedButtonText,
                screenHeight: $screenHeight,
                adsHeight: $adsHeight,
                adsOffset: $adsOffset
            )
            // Use setWebView to fully update the manager's state
            SharedWebViewManager.shared.setWebView(sharedWebView, coordinator: context.coordinator, bindings: bindings)
            
            // Re-assign delegates to ensure the new coordinator receives events
            sharedWebView.navigationDelegate = context.coordinator
            sharedWebView.uiDelegate = context.coordinator
            
            // Re-assign script handler
            sharedWebView.configuration.userContentController.removeScriptMessageHandler(forName: "adsMetrics")
            sharedWebView.configuration.userContentController.add(context.coordinator, name: "adsMetrics")
            
            context.coordinator.webView = sharedWebView
            context.coordinator.setupURLObservation(for: sharedWebView)
            
            return sharedWebView
        }
        
        // Створюємо новий WebView як зазвичай
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let userController = WKUserContentController()
         
        let scriptSource = """
        (function() {
          window.currentAdsOffset = 0;
          
          window.lastClickedElement = null;
          window.lastClickedLink = null;
          
          function disableTextInputs() {
            try {
              var inputs = document.querySelectorAll('input[type="text"], input[type="email"], input[type="password"], input[type="search"], input[type="url"], input[type="tel"], input[type="number"], textarea, [contenteditable="true"]');
              
              for (var i = 0; i < inputs.length; i++) {
                var input = inputs[i];
                
                input.setAttribute('readonly', 'true');
                
                input.addEventListener('touchstart', function(e) {
                  e.preventDefault();
                  e.stopPropagation();
                }, true);
              }
              
              console.log('🚫 Disabled ' + inputs.length + ' text inputs');
            } catch(e) {
              console.log('❌ Error disabling inputs:', e);
            }
          }
          
          document.addEventListener('click', function(event) {
            try {
              window.lastClickedElement = event.target;
              
              if (event.target.matches('input[type="text"], input[type="email"], input[type="password"], input[type="search"], input[type="url"], input[type="tel"], input[type="number"], textarea, [contenteditable="true"]')) {
                event.preventDefault();
                event.stopPropagation();
                console.log('🚫 Blocked text input interaction');
                return false;
              }
              
              var linkElement = event.target.closest('a');
              if (linkElement) {
                window.lastClickedLink = linkElement;
              }
              
              var texts = {
                direct: event.target.textContent || event.target.innerText || '',
                alt: event.target.getAttribute ? (event.target.getAttribute('alt') || '') : '',
                title: event.target.getAttribute ? (event.target.getAttribute('title') || '') : '',
                parent: event.target.parentElement ? (event.target.parentElement.textContent || event.target.parentElement.innerText || '') : '',
                link: linkElement ? (linkElement.textContent || linkElement.innerText || '') : ''
              };
              
            } catch(e) {
              console.log('❌ Error in click handler:', e);
            }
          }, true);
          
        
          function inViewport(r) {
            return r.width > 0 && r.height > 0 && r.bottom > 0 && r.right > 0 &&
                   r.top < window.innerHeight && r.left < window.innerWidth;
          }
          
          function collect() {
            var adBlocks = [];
            
            var iframes = Array.from(document.querySelectorAll('iframe'));
            for (var i = 0; i < iframes.length; i++) {
              var f = iframes[i];
              var src = (f.getAttribute('src') || '').toString();
              var r = f.getBoundingClientRect();
              var isAd = /google|doubleclick|afs\\/ads|syndicatedsearch/.test(src) || (r.width > 280 && r.height > 100);
              if (isAd) {
                adBlocks.push({
                  kind: 'iframe',
                  index: i,
                  src: src,
                  width: Math.round(r.width),
                  height: Math.round(r.height),
                  x: Math.round(r.left),
                  y: Math.round(r.top),
                  right: Math.round(r.right),
                  bottom: Math.round(r.bottom),
                  visible: inViewport(r)
                });
              }
            }
            
            var candidates = Array.from(document.querySelectorAll([
              'ins.adsbygoogle',
              '.adsbygoogle',
              '[data-ad-client]',
              '[data-ad-slot]',
              '[id*="ad-"]',
              '[class*="ad-"]',
              '[id*="ads"]',
              '[class*="ads"]',
              '[id*="google_ads"]',
              '[class*="google-ads"]',
              'a[href*="doubleclick"]',
              'a[href*="googleads"]',
              'a[href*="syndicatedsearch"]'
            ].join(',')));
            
            for (var j = 0; j < candidates.length; j++) {
              var el = candidates[j];
              var r2 = el.getBoundingClientRect();
              var style = window.getComputedStyle(el);
              var isFixedOverlay = (style.position === 'fixed' || style.position === 'sticky') && parseInt(style.zIndex || '0', 10) >= 10;
              var looksLikeAd = (r2.width > 280 && r2.height > 100) || isFixedOverlay;
              if (looksLikeAd) {
                adBlocks.push({
                  kind: 'node',
                  index: j,
                  src: el.tagName.toLowerCase(),
                  width: Math.round(r2.width),
                  height: Math.round(r2.height),
                  x: Math.round(r2.left),
                  y: Math.round(r2.top),
                  right: Math.round(r2.right),
                  bottom: Math.round(r2.bottom),
                  visible: inViewport(r2)
                });
              }
            }
            
            return {
              totalIframes: iframes.length,
              adBlocks: adBlocks,
              screenSize: { width: window.innerWidth, height: window.innerHeight }
            };
          }
          
          var lastSignature = '';
          function postIfChanged() {
            try {
              var payload = collect();
              var sumH = 0;
              for (var k = 0; k < payload.adBlocks.length; k++) {
                var b = payload.adBlocks[k];
                if (b.visible && b.height > 0) sumH += b.height;
              }
              // Підпис, щоб не слати однакові дані двічі
              var signature = payload.screenSize.width + 'x' + payload.screenSize.height + '|' + sumH + '|' + payload.adBlocks.length;
              if (signature !== lastSignature) {
                lastSignature = signature;
                window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.adsMetrics &&
                  window.webkit.messageHandlers.adsMetrics.postMessage(payload);
              }
            } catch(e) {}
          }
          
          var rafId = 0;
          function schedule() {
            if (rafId) cancelAnimationFrame(rafId);
            rafId = requestAnimationFrame(postIfChanged);
          }
          
          window.scrollByHeight = function(height) {
            try {
              var adBlocks = [];
              var iframes = Array.from(document.querySelectorAll('iframe'));
              for (var i = 0; i < iframes.length; i++) {
                var f = iframes[i];
                var src = (f.getAttribute('src') || '').toString();
                var r = f.getBoundingClientRect();
                var isAd = /google|doubleclick|afs\\/ads|syndicatedsearch/.test(src) || (r.width > 280 && r.height > 100);
                if (isAd) {
                  adBlocks.push({
                    element: f,
                    rect: r,
                    bottom: r.bottom
                  });
                }
              }
              
              var candidates = Array.from(document.querySelectorAll([
                'ins.adsbygoogle',
                '.adsbygoogle',
                '[data-ad-client]',
                '[data-ad-slot]',
                '[id*="ad-"]',
                '[class*="ad-"]',
                '[id*="ads"]',
                '[class*="ads"]',
                '[id*="google_ads"]',
                '[class*="google-ads"]'
              ].join(',')));
              
              for (var j = 0; j < candidates.length; j++) {
                var el = candidates[j];
                var r2 = el.getBoundingClientRect();
                var looksLikeAd = (r2.width > 280 && r2.height > 100);
                if (looksLikeAd) {
                  adBlocks.push({
                    element: el,
                    rect: r2,
                    bottom: r2.bottom
                  });
                }
              }
              
              if (adBlocks.length > 0) {
                var lowestAdBlock = adBlocks.reduce(function(prev, current) {
                  return (prev.bottom > current.bottom) ? prev : current;
                });
                
                var currentOffset = window.currentAdsOffset || 0;
                
                var targetScroll = (lowestAdBlock.bottom - window.innerHeight + window.scrollY) - currentOffset;
                
                window.scrollTo({
                  top: Math.max(0, targetScroll)
                });
              } else {
        
                window.scrollBy({
                  top: height
                });
              }
            } catch(e) {
              window.scrollBy(0, height);
            }
          };
          
          window.updateAdsOffset = function(newOffset) {
            window.currentAdsOffset = newOffset;
            
            if (window.scrollByHeight) {
              window.scrollByHeight(0); 
            }
          };
          
          document.addEventListener('DOMContentLoaded', function() {
            schedule();
            disableTextInputs(); 
          });
          
          window.addEventListener('load', function() {
            schedule();
            disableTextInputs(); 
          });
          
          window.addEventListener('resize', schedule);
          window.addEventListener('scroll', schedule, true);
          
          try {
            var mo = new MutationObserver(function() {
              schedule();
              setTimeout(disableTextInputs, 100);
            });
            mo.observe(document.documentElement || document.body, { childList: true, subtree: true, attributes: true });
          } catch(e) {}
          
          setInterval(function() {
            schedule();
            disableTextInputs(); 
          }, 1500);
          
          schedule();
          disableTextInputs();
          
          window.collectAdsMetrics = schedule;
          window.disableTextInputs = disableTextInputs; 
        })();
        """
        
        let userScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userController.addUserScript(userScript)
        userController.add(context.coordinator, name: "adsMetrics")
        config.userContentController = userController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsLinkPreview = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        context.coordinator.webView = webView
        
        if useSharedInstance {
            let bindings = SharedWebViewManager.WebViewBindings(
                linkClicked: $linkClicked,
                clickedURL: $clickedURL,
                clickedButtonText: $clickedButtonText,
                screenHeight: $screenHeight,
                adsHeight: $adsHeight,
                adsOffset: $adsOffset
            )
            SharedWebViewManager.shared.setWebView(webView, coordinator: context.coordinator, bindings: bindings)
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
        context.coordinator.lastRequestedURL = url.absoluteString
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        
        if useSharedInstance {
            let desired = url.absoluteString
            if context.coordinator.lastRequestedURL != desired {
                SharedWebViewManager.shared.NavigateTo(url: url)
                print("🔄 SharedInstance: Navigated to \(url.absoluteString)")
            }
            return
        } else {
            let desired = url.absoluteString
            if context.coordinator.lastRequestedURL != desired {
                context.coordinator.lastRequestedURL = desired
                let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
                uiView.load(request)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    @MainActor
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {

        var parent: WebViews
        var lastRequestedURL: String?
        var webView: WKWebView?
        
        var bindings: SharedWebViewManager.WebViewBindings?
        var urlObservation: NSKeyValueObservation?
        var isInitialLoadFinished: Bool = false

        init(_ parent: WebViews) {
            self.parent = parent
        }
            func setupURLObservation(for webView: WKWebView) {
            // Invalidate existing observation if any
            urlObservation?.invalidate()
            
            urlObservation = webView.observe(\.url, options: .new) { [weak self] webView, change in
                Task { @MainActor in
                    guard let self = self else { return }
                    guard let url = webView.url else { return }
                    print("🔗 KVO URL Changed: \(url.absoluteString)")
                    
                    if self.isInitialLoadFinished {
                         print("🎯 KVO Setting linkClicked = true for URL: \(url.absoluteString)")
                         if let bindings = self.bindings {
                              bindings.linkClicked.wrappedValue = true
                              bindings.clickedURL.wrappedValue = url.absoluteString
                         } else {
                              self.parent.linkClicked = true
                              self.parent.clickedURL = url.absoluteString
                         }
                    }
                }
            }
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    
            guard message.name == "adsMetrics", let dict = message.body as? [String: Any] else { return }
            
            if let screenSize = dict["screenSize"] as? [String: Any],
               let screenH = screenSize["height"] as? Int {
                DispatchQueue.main.async {
                    if let bindings = self.bindings {
                        bindings.screenHeight.wrappedValue = CGFloat(screenH)
                    } else {
                        self.parent.screenHeight = CGFloat(screenH)
                    }
                }
                print("📱ScreenSize: \(screenH)")
            }
            
            DispatchQueue.main.async {
                if let bindings = self.bindings {
                    bindings.adsHeight.wrappedValue = 0
                } else {
                    self.parent.adsHeight = 0
                }
            }
            
            if let adBlocks = dict["adBlocks"] as? [[String: Any]] {
                var totalHeight: CGFloat = 0
                for block in adBlocks {
                    let h = block["height"] as? Int ?? 0
                    let visible = block["visible"] as? Bool ?? false
                    if visible && h > 0 {
                        totalHeight += CGFloat(h)
                    }
                }
                DispatchQueue.main.async {
                    let adsOffsetValue: CGFloat
                    if let bindings = self.bindings {
                        bindings.adsHeight.wrappedValue = totalHeight
                        adsOffsetValue = bindings.adsOffset.wrappedValue
                    } else {
                        self.parent.adsHeight = totalHeight
                        adsOffsetValue = self.parent.adsOffset
                    }
                    
                    print("🎯 adsHeight updated: \(totalHeight)")
                    
                    let updateScript = "if (window.updateAdsOffset) { window.updateAdsOffset(\(adsOffsetValue)); }"
                    self.webView?.evaluateJavaScript(updateScript) { result, error in
                        if let error = error {
                            print("❌ Error updating ads offset: \(error)")
                        } else {
                            print("✅ Successfully updated ads offset to: \(adsOffsetValue)")
                        }
                    }
                }
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("📄 WebView finished loading")
            isInitialLoadFinished = true
            setupURLObservation(for: webView)
    
            webView.evaluateJavaScript("if (window.collectAdsMetrics) { window.collectAdsMetrics(); }", completionHandler: nil)
        
            self.webView = webView
        }

         func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            
            guard let url = navigationAction.request.url else {
                return .allow
            }

            let urlString = url.absoluteString
            print("WebView navigation to: \(urlString)")
        
            if navigationAction.navigationType == .linkActivated {
                let getClickedElementTextScript = """
                (function() {
                    try {
                        var targetUrl = "\(url.absoluteString.replacingOccurrences(of: "\"", with: "\\\""))";
                        if (window.lastClickedElement) {
                            var element = window.lastClickedElement;
                            var text = '';
                            text = element.textContent || element.innerText || '';
                            if (!text || text.trim() === '') {
                                text = element.getAttribute('alt') || element.getAttribute('title') || '';
                            }
                            if ((!text || text.trim() === '') && element.tagName === 'IMG' && element.parentElement) {
                                text = element.parentElement.textContent || element.parentElement.innerText || '';
                            }
                            var linkParent = element.closest('a');
                            if (linkParent && (!text || text.trim() === '')) {
                                text = linkParent.textContent || linkParent.innerText || '';
                            }
                            text = text.trim().replace(/\\s+/g, ' ');
                            if (text && text.length > 0) {
                                return text.substring(0, 200);
                            }
                        }
                        
                        var allLinks = document.querySelectorAll('a');
                        for (var i = 0; i < allLinks.length; i++) {
                            var link = allLinks[i];
                            var href = link.href || link.getAttribute('href') || '';
                            if (href === targetUrl || href.indexOf(targetUrl) !== -1 || targetUrl.indexOf(href) !== -1) {
                                var linkText = link.textContent || link.innerText || '';
                                if (!linkText || linkText.trim() === '') {
                                    var img = link.querySelector('img');
                                    if (img) {
                                        linkText = img.getAttribute('alt') || img.getAttribute('title') || 'Image';
                                    }
                                }
                                if (!linkText || linkText.trim() === '') {
                                    var urlParts = targetUrl.split('/');
                                    linkText = urlParts[urlParts.length - 1] || 'Link';
                                    var urlParams = targetUrl.split('?')[1];
                                    if (urlParams) {
                                        var params = new URLSearchParams(urlParams);
                                        linkText = params.get('q') || params.get('query') || params.get('search') || linkText;
                                    }
                                }
                                linkText = linkText.trim().replace(/\\s+/g, ' ');
                                if (linkText && linkText.length > 0) {
                                    return linkText.substring(0, 200);
                                }
                            }
                        }
                        
                        var urlObj = new URL(targetUrl);
                        var searchParams = urlObj.searchParams;
                        var searchTerms = searchParams.get('q') || 
                                         searchParams.get('query') || 
                                         searchParams.get('search') || 
                                         searchParams.get('keyword') ||
                                         searchParams.get('term') ||
                                         searchParams.get('adtitle');
                        if (searchTerms) {
                            return decodeURIComponent(searchTerms).substring(0, 200);
                        }
                        var hostname = urlObj.hostname.replace('www.', '');
                        return hostname + ' link';
                        
                    } catch(e) {
                        return 'Link clicked (error: ' + e.message + ')';
                    }
                })();
                """
                
                // Use MainActor for UI updates
                Task { @MainActor in 
                    do {
                       let result = try await webView.evaluateJavaScript(getClickedElementTextScript)
                       if let buttonText = result as? String, !buttonText.isEmpty {
                           if let bindings = self.bindings {
                               bindings.clickedButtonText.wrappedValue = buttonText
                           } else {
                               self.parent.clickedButtonText = buttonText
                           }
                       } else {
                           let fallbackText = url.lastPathComponent.isEmpty ? url.host ?? "Link" : url.lastPathComponent
                           if let bindings = self.bindings {
                               bindings.clickedButtonText.wrappedValue = fallbackText
                           } else {
                               self.parent.clickedButtonText = fallbackText
                           }
                       }
                    } catch {
                       print("JS Error: \(error)")
                    }
                    
                    print("🎯 Setting linkClicked = true for URL: \(urlString)")
                    if let bindings = self.bindings {
                        bindings.linkClicked.wrappedValue = true
                        bindings.clickedURL.wrappedValue = urlString
                    } else {
                        self.parent.linkClicked = true
                        self.parent.clickedURL = urlString
                    }
                }
                
                return .allow
            } else {
                return .allow
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("WebView failed to load: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
  
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
     }
}
